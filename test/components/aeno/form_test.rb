require "test_helper"

class Aeno::FormTest < ViewComponent::TestCase
  def test_form_with_block_dsl
    render_inline(Aeno::Form::Component.new(url: "/contacts", method: :post)) do |f|
      f.with_input(type: :text, name: "email", label: "Email")

      f.with_group(title: "Contact Information") do |g|
        g.with_input(type: :text, name: "name", label: "Name")

        g.with_nested(name: :siblings, label: "Siblings") do |s|
          s.with_input(type: :text, name: "name", label: "Sibling Name")
          s.with_input(type: :text, name: "age", label: "Age")

          s.with_nested(name: :phones, label: "Phone Numbers") do |p|
            p.with_input(type: :text, name: "number", label: "Number")
          end
        end
      end

      f.with_group(title: "Address") do |g|
        g.with_row(css: "grid-cols-2") do |r|
          r.with_input(type: :text, name: "city", label: "City")
          r.with_input(type: :text, name: "state", label: "State")
        end
      end

      f.with_submit(label: "Create Contact", variant: :primary)
      f.with_action(label: "Cancel", variant: :secondary)
    end

    # Form element with proper attributes
    assert_selector "form[action='/contacts'][method='post']"
    assert_selector "form[data-controller='aeno--form']"

    # Basic form structure
    assert_selector "form div.space-y-12"

    # Top-level input
    assert_selector "input[name='email']"
    assert_selector "label", text: "Email"

    # Group titles (template uses h2, not h3)
    assert_selector "h2", text: "Contact Information"
    assert_selector "h2", text: "Address"

    # Group: Contact Information - direct input
    assert_selector "input[name='name']"
    assert_selector "label", text: "Name"

    # Nested: Siblings
    assert_selector "h3", text: "Siblings"
    assert_selector "button", text: "+ Add Sibling"

    # There should be div templates for nested forms (hidden with class)
    assert_selector "div[data-aeno--form-target='template'].hidden", visible: false, minimum: 2

    # Get all templates
    templates = page.all("div[data-aeno--form-target='template'].hidden", visible: false)
    all_template_content = templates.map { |t| t.native.inner_html }.join(" ")

    # Siblings template should contain input fields with NEW_RECORD placeholder
    assert_includes all_template_content, "NEW_RECORD", "Templates should contain NEW_RECORD placeholder"
    assert_includes all_template_content, "siblings_attributes[NEW_RECORD]", "Should have proper Rails nested attributes name"
    assert_includes all_template_content, "Sibling Name", "Template should contain Sibling Name label"
    assert_includes all_template_content, "Age", "Template should contain Age label"

    # Double-nested: Phones within Siblings
    assert_includes all_template_content, "Phone Numbers", "Template should contain nested Phone Numbers"
    assert_includes all_template_content, "phones_attributes", "Should have nested phones attributes"
    assert_includes all_template_content, "Number", "Template should contain Number label for phones"

    # Group: Address - row with two inputs
    assert_selector "input[name='city']"
    assert_selector "label", text: "City"
    assert_selector "input[name='state']"
    assert_selector "label", text: "State"

    # Row should have grid layout
    assert_selector "div.grid-cols-2"

    # Action buttons
    assert_selector "button[type='submit']", text: "Create Contact"
    assert_selector "button[type='button']", text: "Cancel"
    assert_selector "div.mt-6.flex.items-center.justify-end.gap-x-6"

    # Nested form should have Stimulus controller
    assert_selector "div[data-controller='aeno--form']"
    assert_selector "div[data-aeno--form-target='target']"

    # Remove button in template
    assert_includes all_template_content, "Remove", "Template should contain Remove button"
    assert_includes all_template_content, "data-action=\"aeno--form#remove\"", "Template should have Stimulus remove action"

    # VANILLA VIEWCOMPONENT ASSERTIONS - No custom hacks
    html = page.native.to_html

    # Assert NO DUPLICATION - count exact occurrences of each visible field
    email_count = html.scan(/<input[^>]*name="email"/).count
    assert_equal 1, email_count, "Email field must appear exactly 1 time (found #{email_count})"

    name_count = html.scan(/<input[^>]*name="name"/).count
    assert_equal 1, name_count, "Name field must appear exactly 1 time (found #{name_count})"

    city_count = html.scan(/<input[^>]*name="city"/).count
    assert_equal 1, city_count, "City field must appear exactly 1 time (found #{city_count})"

    state_count = html.scan(/<input[^>]*name="state"/).count
    assert_equal 1, state_count, "State field must appear exactly 1 time (found #{state_count})"

    # Count group headers - should appear exactly once each
    contact_info_count = html.scan(/<h2[^>]*>Contact Information</).count
    assert_equal 1, contact_info_count, "Contact Information header must appear exactly 1 time (found #{contact_info_count})"

    address_count = html.scan(/<h2[^>]*>Address</).count
    assert_equal 1, address_count, "Address header must appear exactly 1 time (found #{address_count})"

    siblings_count = html.scan(/<h3[^>]*>Siblings</).count
    assert_equal 1, siblings_count, "Siblings header must appear exactly 1 time (found #{siblings_count})"

    # Verify components don't have custom hacks
    group = Aeno::Form::GroupComponent.new(title: "Test")
    refute group.instance_variable_defined?(:@__setup_block), "GroupComponent must not have @__setup_block instance variable"

    nested = Aeno::Form::NestedComponent.new(name: :test)
    refute nested.instance_variable_defined?(:@__setup_block), "NestedComponent must not have @__setup_block instance variable"
    refute nested.instance_variable_defined?(:@__setup_block_called), "NestedComponent must not have @__setup_block_called instance variable"

    row = Aeno::Form::RowComponent.new
    refute row.instance_variable_defined?(:@__setup_block), "RowComponent must not have @__setup_block instance variable"
  end
end
