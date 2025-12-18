module Aeno::Form::Concerns
  module InputSlots
    extend ActiveSupport::Concern

    included do
      def input_slot_lambda
        ->(**args) {
          scoped_name = form_builder.object_name ? "#{form_builder.object_name}[#{args[:name]}]" : args[:name].to_s
          value = args[:value] || read_value_from_model(args[:name])
          error_text = args[:error_text] || read_error_from_model(args[:name])
          Aeno::Input::Component.new(**args, name: scoped_name, value: value, error_text: error_text)
        }
      end
    end

    private

    def read_value_from_model(name)
      return nil unless form_builder&.object
      form_builder.object.public_send(name)
    end

    def read_error_from_model(name)
      return nil unless form_builder&.object
      errors = form_builder.object.errors[name]
      errors.first if errors.any?
    end
  end
end
