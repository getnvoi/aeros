module Aeno::Form
  class Component < ::Aeno::ApplicationViewComponent
    option :model
    option :url
    option :method, default: proc { :post }

    def render_in(view_context, &block)
      @content_block = block
      super(view_context)
    end

    def render_form_layout(form_builder)
      layout = Aeno::Form::LayoutComponent.new(form_builder: form_builder)
      @content_block.call(layout) if @content_block
      render(layout)
    end

    private

    def form_options
      { data: { controller: "aeno--form" } }
    end
  end
end
