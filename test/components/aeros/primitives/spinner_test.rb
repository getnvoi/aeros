# frozen_string_literal: true

require "test_helper"

class Aeros::Primitives::SpinnerTest < ViewComponent::TestCase
  # Test css_identifier class method
  test "css_identifier returns correct scoped name" do
    assert_equal "primitives--spinner", Aeros::Primitives::Spinner::Component.css_identifier
  end

  # Test class_for instance method
  test "class_for generates scoped CSS class" do
    component = Aeros::Primitives::Spinner::Component.new
    assert_equal "c--primitives--spinner--base", component.class_for("base")
    assert_equal "c--primitives--spinner--lg", component.class_for("lg")
  end

  # Test rendering
  test "renders spinner with default classes" do
    render_inline(Aeros::Primitives::Spinner::Component.new)

    assert_selector "span.c--primitives--spinner--base"
    assert_selector "span.c--primitives--spinner--default" # default size
    assert_selector "span.c--primitives--spinner--default" # default variant
  end

  test "renders spinner with size option" do
    render_inline(Aeros::Primitives::Spinner::Component.new(size: :lg))

    assert_selector "span.c--primitives--spinner--base"
    assert_selector "span.c--primitives--spinner--lg"
  end

  test "renders spinner with variant option" do
    render_inline(Aeros::Primitives::Spinner::Component.new(variant: :white))

    assert_selector "span.c--primitives--spinner--base"
    assert_selector "span.c--primitives--spinner--white"
  end

  test "renders spinner with custom css" do
    render_inline(Aeros::Primitives::Spinner::Component.new(css: "my-custom-class"))

    assert_selector "span.c--primitives--spinner--base.my-custom-class"
  end

  test "renders spinner with all options" do
    render_inline(Aeros::Primitives::Spinner::Component.new(size: :sm, variant: :primary, css: "extra"))

    assert_selector "span.c--primitives--spinner--base"
    assert_selector "span.c--primitives--spinner--sm"
    assert_selector "span.c--primitives--spinner--primary"
    assert_selector "span.extra"
  end
end
