# frozen_string_literal: true

module Aeros::Primitives::InputSlider
  class Component < ::Aeros::ApplicationViewComponent
    option(:name)
    option(:id, optional: true)
    option(:value, default: proc { 50 })
    option(:min, default: proc { 0 })
    option(:max, default: proc { 100 })
    option(:step, default: proc { 1 })
    option(:label, optional: true)
    option(:show_value, default: proc { true })
    option(:helper_text, optional: true)
    option(:disabled, default: proc { false })
    option(:data, default: proc { {} })
    option(:css, optional: true)

    style do
      base do
        %w[
          w-full
          h-2
          rounded-full
          bg-muted
          appearance-none
          cursor-pointer
          [&::-webkit-slider-thumb]:appearance-none
          [&::-webkit-slider-thumb]:w-4
          [&::-webkit-slider-thumb]:h-4
          [&::-webkit-slider-thumb]:rounded-full
          [&::-webkit-slider-thumb]:bg-primary
          [&::-webkit-slider-thumb]:cursor-pointer
          [&::-webkit-slider-thumb]:transition-colors
          [&::-webkit-slider-thumb]:hover:bg-primary-hover
          [&::-moz-range-thumb]:w-4
          [&::-moz-range-thumb]:h-4
          [&::-moz-range-thumb]:rounded-full
          [&::-moz-range-thumb]:bg-primary
          [&::-moz-range-thumb]:border-0
          [&::-moz-range-thumb]:cursor-pointer
          focus:outline-none
          focus-visible:ring-2
          focus-visible:ring-ring
          focus-visible:ring-offset-2
        ]
      end
    end

    def input_id
      id || name
    end

    def classes
      [css, style].compact.join(" ")
    end
  end
end
