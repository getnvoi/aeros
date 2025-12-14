module Aeros
  module ApplicationHelper
    def ui(name, *args, **kwargs, &block)
      class_name = name.to_s.tr("-", "_").camelize
      component = begin
        "Aeros::Blocks::#{class_name}::Component".constantize
      rescue NameError
        "Aeros::Primitives::#{class_name}::Component".constantize
      end
      render(component.new(*args, **kwargs), &block)
    end
  end
end
