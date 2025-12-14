module Aeros::Primitives::Spinner
  class Component < ::Aeros::ApplicationViewComponent
    option(:size, default: proc { :default })
    option(:variant, default: proc { :default })
    option(:css, optional: true)

    def classes
      [
        class_for("base"),
        class_for(size.to_s),
        class_for(variant.to_s),
        css
      ].compact.join(" ")
    end

    erb_template <<~ERB
      <span class="<%= classes %>"></span>
    ERB
  end
end
