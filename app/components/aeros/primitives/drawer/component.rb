module Aeros::Primitives::Drawer
  class Component < ::Aeros::ApplicationViewComponent
    option(:width, default: proc { "33%" })
    option(:id, optional: true)
    option(:standalone, default: proc { false })
    option(:form_submit_close, default: proc { true })

    renders_one(:header)
    renders_one(:trigger)
    renders_one(:footer)

    private

    def data_actions
      actions = []
      actions << "turbo:frame-load->#{controller_name}#open" unless standalone
      actions << "turbo:submit-end->#{controller_name}#closeOnSubmit" if form_submit_close
      actions.join(" ").presence
    end
  end
end
