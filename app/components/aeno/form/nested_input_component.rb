module Aeno::Form
  class NestedInputComponent < ::Aeno::ApplicationViewComponent
    option :base_name
    option :index
    option :record, optional: true
    option :field_options

    def call
      field_name = field_options[:name].to_s
      resolved_name = "#{base_name}[#{field_name}]"

      value = field_options[:value]
      value ||= record.send(field_name) if record&.respond_to?(field_name)

      error_text = record.errors[field_name].first if record&.respond_to?(:errors)

      render Aeno::Input::Component.new(**field_options.merge(
        name: resolved_name,
        value: value,
        error_text: error_text,
        id: resolved_name.gsub(/\[|\]/, '_')
      ).compact)
    end
  end
end
