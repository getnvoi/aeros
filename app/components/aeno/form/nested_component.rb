module Aeno::Form
  class NestedComponent < ::Aeno::ApplicationViewComponent
    renders_many :inputs, lambda { |**opts|
      NestedInputConfigComponent.new(field_options: opts)
    }

    renders_many :nesteds, NestedComponent

    option :name
    option :label, optional: true
    option :model, optional: true
    option :parent_name, optional: true
    option :wrapper_selector, default: proc { ".nested-form-wrapper" }
    option :add_button_label, optional: true
    option :remove_button_label, default: proc { "Remove" }
    option :allow_destroy, default: proc { true }

    def model_name
      @model_name ||= model&.class&.model_name&.param_key
    end

    def association_name
      "#{name}_attributes"
    end

    def add_label
      add_button_label || "Add #{name.to_s.singularize.titleize}"
    end

    def existing_records
      return [] unless model && model.respond_to?(name)
      model.send(name)
    end

    def base_name_for_index(index)
      model_name ? "#{model_name}[#{association_name}][#{index}]" : "#{association_name}[#{index}]"
    end
  end
end
