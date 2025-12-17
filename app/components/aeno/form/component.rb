module Aeno::Form
  class Component < ::Aeno::ApplicationViewComponent
    renders_many :inputs, lambda { |**opts|
      Aeno::Input::Component.new(**resolve_input_options(opts))
    }

    renders_many :groups, lambda { |**opts|
      GroupComponent.new(**opts.merge(model: model))
    }

    renders_many :rows, lambda { |**opts|
      RowComponent.new(**opts.merge(model: model))
    }

    renders_one :submit, lambda { |**opts|
      Aeno::Button::Component.new(**opts.merge(type: "submit"))
    }

    renders_one :action, lambda { |**opts|
      Aeno::Button::Component.new(**opts.merge(type: "button"))
    }

    option :model, optional: true
    option :url, optional: true
    option :method, default: proc { :post }
    option :data, optional: true
    option :css, optional: true
    option :debug, default: proc { false }

    def model_name
      @model_name ||= model&.class&.model_name&.param_key
    end

    private

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

    examples("Form", description: "Form with block-based DSL") do |b|
      b.example(:block_dsl, title: "Block-based DSL with Double Nesting") do |e|
        e.preview url: "/contacts", method: :post, debug: true do |component|
          component.with_input(type: :text, name: "email", label: "Email")

          component.with_group(title: "Contact Information") do |g|
            g.with_input(type: :text, name: "name", label: "Name")

            g.with_nested(name: :siblings, label: "Siblings") do |s|
              s.with_input(type: :text, name: "name", label: "Sibling Name")
              s.with_input(type: :text, name: "age", label: "Age")

              s.with_nested(name: :phones, label: "Phone Numbers") do |p|
                p.with_input(type: :text, name: "number", label: "Number")
                p.with_input(type: :select, name: "type", label: "Type") do |select|
                  select.with_option(value: "mobile", label: "Mobile")
                  select.with_option(value: "home", label: "Home")
                end
              end
            end
          end

          component.with_group(title: "Address") do |g|
            g.with_row(css: "grid-cols-2") do |r|
              r.with_input(type: :text, name: "city", label: "City")
              r.with_input(type: :text, name: "state", label: "State")
            end
          end

          component.with_submit(label: "Create Contact", variant: :primary)
          component.with_action(label: "Cancel", variant: :secondary)
        end
      end
    end
  end
end
