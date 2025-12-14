# frozen_string_literal: true

require "test_helper"

class Aeros::ApplicationViewComponentTest < ActiveSupport::TestCase
  # Test css_identifier method across different component naming patterns
  test "css_identifier strips Aeros:: prefix" do
    assert_equal "primitives--spinner", Aeros::Primitives::Spinner::Component.css_identifier
  end

  test "css_identifier strips ::Component suffix" do
    assert_equal "primitives--spinner", Aeros::Primitives::Spinner::Component.css_identifier
  end

  test "css_identifier converts underscores to dashes" do
    # The method should convert snake_case to kebab-case
    identifier = Aeros::Primitives::Spinner::Component.css_identifier
    refute_match /_/, identifier, "css_identifier should not contain underscores"
  end

  test "css_identifier converts slashes to double dashes" do
    identifier = Aeros::Primitives::Spinner::Component.css_identifier
    assert_match /--/, identifier, "css_identifier should use -- for namespace separation"
  end

  # Test class_for method
  test "class_for prefixes with c--" do
    component = Aeros::Primitives::Spinner::Component.new
    assert component.class_for("test").start_with?("c--")
  end

  test "class_for includes css_identifier" do
    component = Aeros::Primitives::Spinner::Component.new
    assert_includes component.class_for("test"), "primitives--spinner"
  end

  test "class_for appends element name" do
    component = Aeros::Primitives::Spinner::Component.new
    assert component.class_for("container").end_with?("--container")
  end

  # Test controller_name method
  test "controller_name has aeros prefix" do
    component = Aeros::Primitives::Spinner::Component.new
    assert component.controller_name.start_with?("aeros--")
  end

  test "controller_name converts namespace to dashes" do
    component = Aeros::Primitives::Spinner::Component.new
    assert_equal "aeros--primitives--spinner", component.controller_name
  end

  # Test stimulus helpers
  test "stimulus_controller returns correct hash" do
    component = Aeros::Primitives::Spinner::Component.new
    assert_equal({ controller: "aeros--primitives--spinner" }, component.stimulus_controller)
  end

  test "stimulus_target returns correct hash" do
    component = Aeros::Primitives::Spinner::Component.new
    expected = { "aeros--primitives--spinner-target" => "element" }
    assert_equal expected, component.stimulus_target("element")
  end

  test "stimulus_action returns correct hash" do
    component = Aeros::Primitives::Spinner::Component.new
    expected = { action: "click->aeros--primitives--spinner#toggle" }
    assert_equal expected, component.stimulus_action("click", "toggle")
  end

  test "stimulus_value returns correct hash" do
    component = Aeros::Primitives::Spinner::Component.new
    expected = { "aeros--primitives--spinner-active-value" => true }
    assert_equal expected, component.stimulus_value("active", true)
  end
end
