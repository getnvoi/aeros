# Feature: Form Error Handling - TODO

## Context

This branch (`feature/form-error-handling`) was merged from main where **main's structure prevails**. The original error handling features need to be re-implemented on top of main's codebase.

**Current Status:**
- ✅ Merged main successfully
- ✅ Deleted obsolete branches (claude/review-recent-commits-oNpvp, feat/www-showcase, fix/viewcomponent-previews)
- ✅ Database migrations working
- ✅ 63 tests running, 332 assertions
- ⚠️ 1 minor test failure (wrong exception type expectation)

---

## 1. Automatic Error Display (HIGH PRIORITY)

### Problem
Forms require manual error passing - developers must explicitly pass `error_text` to each input field.

### Solution
Forms should automatically read validation errors from model objects and display them beneath fields.

### Implementation

**File:** `app/components/aeno/form/concerns/input_slots.rb`

**Add method:**
```ruby
def read_error_from_model(name)
  return nil unless form_builder&.object&.errors
  errors = form_builder.object.errors[name]
  errors.first if errors.any?
end
```

**Update `input_slot_lambda` (line 6-12):**
```ruby
def input_slot_lambda
  ->(**args) {
    scoped_name = form_builder.object_name ? "#{form_builder.object_name}[#{args[:name]}]" : args[:name].to_s
    value = args[:value] || read_value_from_model(args[:name])
    error_text = args[:error_text] || read_error_from_model(args[:name])
    Aeno::Input::Component.new(**args, name: scoped_name, value:, error_text:)
  }
end
```

### Testing
Add test to verify errors are automatically piped from models to inputs at all nesting levels.

---

## 2. Data-Role Attributes for Testing (MEDIUM PRIORITY)

### Problem
Tests rely on CSS classes to find error/helper text, which is fragile.

### Solution
Add semantic `data-role` attributes for more robust testing.

### Implementation

**File:** `app/components/aeno/input/component.rb`

**Update `error_html` method (line 58-60):**
```ruby
def error_html
  content_tag(:p, error_text, class: "mt-1 text-sm text-red-600", data: { role: "error" })
end
```

**Update `helper_html` method (line 62-64):**
```ruby
def helper_html
  content_tag(:p, helper_text, class: "mt-1 text-sm text-gray-500", data: { role: "helper" })
end
```

### Testing
Tests can now use: `assert_selector '[data-role="error"]'` instead of class-based selectors.

---

## 3. Validation-Based Nested Rendering (MEDIUM PRIORITY)

### Problem
New (unsaved) nested records with validation errors don't render, so users can't see what went wrong.

### Solution
Render nested records if they are persisted OR have changes OR have validation errors.

### Implementation

**File:** `app/components/aeno/form/nested_component.html.erb`

**Update lines 38-48:**
```erb
<%# Existing records with fields_for %>
<div data-aeno--form-target="target">
  <%
    collection = form_builder.object&.public_send(name) || []
    # Include persisted records OR new records that have been modified/have errors
    collection = collection.select do |record|
      record.persisted? || record.changed? || record.errors.any?
    end
  %>
  <% if collection.any? %>
    <%= form_builder.fields_for(name, collection) do |nested_builder| %>
```

### Why This Matters
When a user submits a form with invalid nested records, they need to see:
- The invalid nested record (even though it's not saved)
- The validation errors on that record
- The ability to fix and resubmit

---

## 4. Model Validations (OPTIONAL)

### Problem
Example models have no validations, making error handling features invisible.

### Solution
Add example validations to demonstrate the error handling system.

### Implementation

**File:** `app/models/aeno/contact.rb`

```ruby
class Aeno::Contact < ApplicationRecord
  has_many :contact_relationships, dependent: :destroy
  has_many :related_contacts, through: :contact_relationships
  has_many :phones, dependent: :destroy

  accepts_nested_attributes_for :contact_relationships, allow_destroy: true
  accepts_nested_attributes_for :related_contacts, allow_destroy: true
  accepts_nested_attributes_for :phones, allow_destroy: true

  # Add validations for demonstration
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
```

**File:** `app/models/aeno/phone.rb`

```ruby
class Aeno::Phone < ApplicationRecord
  belongs_to :contact, class_name: "Aeno::Contact"

  # Add validations for demonstration
  validates :number, presence: true
  validates :phone_type, inclusion: { in: %w[mobile work home] }, allow_blank: true
end
```

### Why Optional
These are just examples. Real applications will have their own validation requirements.

---

## 5. Fix Test Expectation (LOW PRIORITY)

### Problem
Test expects `NoMethodError` but Ruby 3.4 raises `NameError` for undefined local variables/methods.

### Implementation

**File:** `test/components/aeno/application_view_component_test.rb`

**Update line 8-14:**
```ruby
def test_raises_when_data_method_does_not_exist
  component = TestComponent.new
  assert_raises(NameError) do  # Changed from NoMethodError
    component.merged_data
  end
end
```

### Why This Changed
Ruby 3.4 changed the exception type for undefined method calls in certain contexts.

---

## Additional Considerations

### Defensive Programming Removal
The original branch removed `respond_to?` checks that were silently swallowing errors. Main already has this fixed - no action needed.

### Table Components
The original branch had extensive table enhancements (pagination, filters, batch actions). Main independently developed its own table system. Main's version is already in place - no action needed.

### Migration Cleanup
- ✅ Deleted old migration: `test/dummy/db/migrate/20251218091105_add_city_and_state_to_contacts.rb`
- ✅ Added `state` field to `db/migrate/20251219100001_create_aeno_contacts.rb`
- ✅ Database schema is clean and working

---

## Implementation Order

1. **Data-Role Attributes** (easiest, safest)
2. **Automatic Error Display** (core feature)
3. **Validation-Based Nested Rendering** (builds on #2)
4. **Model Validations** (for testing/examples)
5. **Fix Test Expectation** (trivial)

---

## Testing Strategy

After implementing each feature:
1. Run `bin/rails test` to ensure no regressions
2. Manually test form submission with invalid data
3. Verify errors appear at all nesting levels
4. Verify new nested records with errors render correctly

---

## Notes

- Main's structure is the foundation - we're adding features, not replacing code
- All changes should be additive and backward-compatible
- The goal is automatic error handling without breaking existing forms
- Focus on developer experience: less boilerplate, better defaults
