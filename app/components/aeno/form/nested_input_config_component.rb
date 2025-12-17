module Aeno::Form
  class NestedInputConfigComponent < ::Aeno::ApplicationViewComponent
    option :field_options

    def call
      nil # This component doesn't render, it just holds config
    end

    def to_input(base_name:, index:, record: nil)
      field_name = field_options[:name].to_s
      resolved_name = "#{base_name}[#{field_name}]"

      value = field_options[:value]
      value ||= record.send(field_name) if record&.respond_to?(field_name)

      error_text = record.errors[field_name].first if record&.respond_to?(:errors)

      Aeno::Input::Component.new(**field_options.merge(
        name: resolved_name,
        value: value,
        error_text: error_text,
        id: resolved_name.gsub(/\[|\]/, '_')
      ).compact)
    end
  end
end
