module Ui::InputPassword
  class Component < ::Ui::FormBuilder::BaseComponent
    option(:autocomplete, default: proc { "current-password" })
    option(:show_toggle, default: proc { true })
  end
end
