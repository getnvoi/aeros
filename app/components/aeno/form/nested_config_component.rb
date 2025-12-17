module Aeno::Form
  class NestedConfigComponent < ::Aeno::ApplicationViewComponent
    option :nested_component
    option :options

    def call
      nested_component
    end

    def to_nested(model:)
      NestedComponent.new(**options.merge(model: model))
    end
  end
end
