module Aeros::Primitives::Layouts::App
  class Component < Aeros::ApplicationViewComponent
    renders_one :sidebar, ->(style: nil, &block) {
      Aeros::Primitives::Layouts::App::Sidebar.new(style: style, &block)
    }
    renders_one :header
    renders_one :aside, ->(style: nil, &block) {
      Aeros::Primitives::Layouts::App::Aside.new(style: style, &block)
    }
  end
end
