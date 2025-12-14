# frozen_string_literal: true

module Aeros::Primitives::InputColor
  class Component < ::Aeros::ApplicationViewComponent
    option(:name)
    option(:id, optional: true)
    option(:value, default: proc { "#000000" })
    option(:label, optional: true)
    option(:helper_text, optional: true)
    option(:disabled, default: proc { false })
    option(:data, default: proc { {} })
    option(:css, optional: true)
    option(:size, default: proc { :default })

    style do
      base do
        %w[
          rounded-input
          cursor-pointer
          border
          border-input-border
          focus:outline-none
          focus-visible:ring-2
          focus-visible:ring-ring
          focus-visible:ring-offset-2
        ]
      end

      variants do
        size do
          small { "w-8 h-8" }
          default { "w-10 h-10" }
          large { "w-12 h-12" }
        end
      end
    end

    def input_id
      id || name
    end

    def classes
      [css, style(size:)].compact.join(" ")
    end
  end
end
