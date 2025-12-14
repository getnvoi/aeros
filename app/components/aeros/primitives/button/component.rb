module Aeros::Primitives::Button
  class Component < ::Aeros::ApplicationViewComponent
    option(:css, optional: true)
    option(:type, optional: true)
    option(:label, optional: true)
    option(:method, optional: true)
    option(:href, optional: true)
    option(:data, default: proc { {} })
    option(:icon, optional: true)
    option(:variant, default: proc { :default })
    option(:disabled, default: proc { false })
    option(:full, default: proc { false })
    option(:size, default: proc { nil })
    option(:as, default: proc { :button })
    option(:target, optional: true)

    def classes
      [
        class_for("base"),
        class_for(variant.to_s),
        size ? class_for(size.to_s) : nil,
        disabled ? class_for("disabled") : nil,
        full ? class_for("full") : nil,
        css
      ].compact.join(" ")
    end

    erb_template <<~ERB
      <% if href %>
        <%= link_to(href, method:, data: merged_data, class: classes, target:) do %>
          <%= lucide_icon(icon, class: "flex-shrink-0 icon") if icon %>
          <%= ui("spinner", size: :sm, variant: :white, css: "spinner hidden") %>
          <% if label %><span class="truncate flex-shrink"><%= label %></span><% end %>
        <% end %>
      <% else %>
        <%= content_tag(as, data: merged_data, type: type || "button", class: classes) do %>
          <%= lucide_icon(icon, class: "flex-shrink-0 icon") if icon %>
          <%= ui("spinner", size: :sm,  variant: :white, css: "spinner hidden") %>
          <% if label %><span class="truncate flex-shrink"><%= label %></span><% end %>
        <% end %>
      <% end %>
    ERB
  end
end
