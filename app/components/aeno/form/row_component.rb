module Aeno::Form
  class RowComponent < ::Aeno::ApplicationViewComponent
    renders_many :inputs, lambda { |**opts|
      Aeno::Input::Component.new(**resolve_input_options(opts))
    }

    option :css, optional: true
    option :model, optional: true

    private

    def model_name
      @model_name ||= model&.class&.model_name&.param_key
    end

    def resolve_input_options(opts)
      return opts unless model && opts[:name]

      field_name = opts[:name].to_s
      value = opts[:value] || model.send(field_name) if model.respond_to?(field_name)
      error_text = model.errors[field_name].first if model.respond_to?(:errors)

      opts.merge(
        name: model_name ? "#{model_name}[#{field_name}]" : field_name,
        value: value,
        error_text: error_text
      ).compact
    end
  end
end
