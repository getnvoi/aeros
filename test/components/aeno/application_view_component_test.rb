require "test_helper"

class Aeno::ApplicationViewComponentTest < ViewComponent::TestCase
  class TestComponent < Aeno::ApplicationViewComponent
    # Component without data option - should raise when merged_data is called
  end

  def test_raises_when_data_method_does_not_exist
    component = TestComponent.new

    error = assert_raises(NoMethodError) do
      component.merged_data
    end

    assert_match(/data/, error.message)
  end
end
