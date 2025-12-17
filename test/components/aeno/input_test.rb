# frozen_string_literal: true

require "test_helper"

class Aeno::InputTest < ViewComponent::TestCase
  test "select renders options from block" do
    render_inline(Aeno::Input::Component.new(
      type: :select,
      name: "option",
      label: "Select Option"
    )) do |select|
      select.with_option(value: "1", label: "Option 1")
      select.with_option(value: "2", label: "Option 2")
      select.with_option(value: "3", label: "Option 3")
    end

    assert_selector "select[name='option']"
    assert_selector "option[value='1']", text: "Option 1"
    assert_selector "option[value='2']", text: "Option 2"
    assert_selector "option[value='3']", text: "Option 3"
  end

  test "checkbox_collection renders options from block" do
    render_inline(Aeno::Input::Component.new(
      type: :checkbox_collection,
      name: "options",
      label: "Select Options"
    )) do |checkboxes|
      checkboxes.with_option(value: "1", label: "Option 1")
      checkboxes.with_option(value: "2", label: "Option 2")
      checkboxes.with_option(value: "3", label: "Option 3")
    end

    assert_selector "input[type='checkbox'][value='1']"
    assert_selector "input[type='checkbox'][value='2']"
    assert_selector "input[type='checkbox'][value='3']"
    assert_selector "label", text: "Option 1"
    assert_selector "label", text: "Option 2"
    assert_selector "label", text: "Option 3"
  end
end
