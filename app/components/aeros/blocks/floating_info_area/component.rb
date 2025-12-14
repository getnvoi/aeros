# frozen_string_literal: true

module Aeros::Blocks::FloatingInfoArea
  class Component < ::Aeros::ApplicationViewComponent
    option(:icon, default: proc { "settings" })
    option(:position, default: proc { :bottom_right })
    option(:width, default: proc { "w-80" })

    renders_one :trigger
    renders_one :header

    style :toggle do
      base do
        %w[
          w-12 h-12
          rounded-full
          bg-button hover:bg-button-hover
          text-button-foreground
          shadow-lg
          flex items-center justify-center
          cursor-pointer
          transition-all duration-200
          focus:outline-none focus-visible:ring-2 focus-visible:ring-ring
        ]
      end
    end

    style :panel do
      base do
        %w[
          bg-card-bg border border-card-border
          rounded-card shadow-xl
          overflow-hidden
          transition-all duration-300 ease-out
          origin-bottom-right
        ]
      end
    end

    def controller_name
      "aeros--blocks--floating-info-area"
    end
  end
end
