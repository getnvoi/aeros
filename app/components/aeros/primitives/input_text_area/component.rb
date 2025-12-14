module Aeros::Primitives::InputTextArea
  class Component < ::Aeros::FormBuilder::BaseComponent
    option(:rows, default: proc { 4 })
  end
end
