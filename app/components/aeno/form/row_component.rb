module Aeno::Form
  class RowComponent < ::Aeno::ApplicationViewComponent
    include Aeno::Form::Concerns::InputSlots

    option :css, optional: true
    option :form_builder

    renders_many :items, types: {
      input: ->(**args) { input_slot_lambda.call(**args) }
    }
  end
end
