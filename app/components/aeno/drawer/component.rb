module Aeno::Drawer
  class Component < ::Aeno::ApplicationViewComponent
    option(:width, default: proc { "w-1/3" })
    option(:id, optional: true)
    option(:frame_id, default: proc { "drawer-content" })
    option(:standalone, default: proc { false }) # Keep for backward compatibility with existing examples

    renders_one(:trigger)
    renders_one(:drawer_content, "Aeno::Drawer::ContentComponent")

    style(:bg) do
      base { "bg-slate-800/70 fixed inset-0 transition-opacity duration-300 opacity-0 pointer-events-none" }
    end

    style(:wrapper) do
      base { "fixed top-0 right-0 bottom-0 h-full transition-transform duration-300 translate-x-full bg-white shadow-xl" }
    end

    erb_template <<~ERB
      <div id="<%= id %>" data-controller="<%= controller_name %>">
        <% if trigger %>
          <div data-action="click-><%= controller_name %>#open" data-<%= controller_name %>-target="trigger">
            <%= trigger %>
          </div>
        <% end %>

        <!-- Persistent drawer shell -->
        <button
          type="button"
          class="<%= style(:bg) %>"
          data-action="click-><%= controller_name %>#close"
          data-<%= controller_name %>-target="background"
        ></button>

        <div
          class="<%= style(:wrapper) %> <%= width %>"
          data-<%= controller_name %>-target="wrapper"
        >
          <div class="h-screen flex flex-col">
            <% if standalone %>
              <%# Standalone mode: render drawer_content slot or fallback to raw content %>
              <%= drawer_content || content %>
            <% else %>
              <%# Turbo mode: wrap content in turbo frame for swapping %>
              <%= turbo_frame_tag(frame_id, class: "h-full flex flex-col min-h-0") do %>
                <%= drawer_content || content %>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    ERB

    examples("Drawer", description: "Slide-out panel") do |b|
      b.example(:basic, title: "Basic Content") do |e|
        e.preview standalone: true do |drawer|
          drawer.with_trigger { '<button class="px-4 py-2 bg-slate-600 text-white rounded">Open Drawer</button>'.html_safe }
          '<div class="p-6"><p>Simple drawer content</p></div>'.html_safe
        end
      end

      b.example(:scrollable, title: "Long Scrollable Content") do |e|
        e.preview standalone: true do |drawer|
          drawer.with_trigger { '<button class="px-4 py-2 bg-slate-600 text-white rounded">Open Scrollable Drawer</button>'.html_safe }
          content = '<div class="flex-1 overflow-y-auto p-6">'
          20.times do |i|
            content += "<h3 class='font-semibold mt-4 mb-2'>Section #{i + 1}</h3>"
            content += "<p class='text-gray-600 mb-2'>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>"
          end
          content += '</div>'
          content.html_safe
        end
      end

      b.example(:with_header, title: "With Header Only") do |e|
        e.preview_template standalone: true, template: <<~TEMPLATE
          <%= render(Aeno::Drawer::Component.new(standalone: true)) do |drawer| %>
            <% drawer.with_trigger do %>
              <button class="px-4 py-2 bg-slate-600 text-white rounded">Open with Header</button>
            <% end %>
            <% drawer.with_drawer_content do |content| %>
              <% content.with_header do %>
                <h2 class="text-lg font-semibold">Header Title</h2>
              <% end %>
              <div class="space-y-4">
                <p class="text-gray-600">Content with header and close button.</p>
                <p class="text-gray-600">Notice the X button in the header.</p>
              </div>
            <% end %>
          <% end %>
        TEMPLATE
      end

      b.example(:with_footer, title: "With Footer Only") do |e|
        e.preview_template standalone: true, template: <<~TEMPLATE
          <%= render(Aeno::Drawer::Component.new(standalone: true)) do |drawer| %>
            <% drawer.with_trigger do %>
              <button class="px-4 py-2 bg-slate-600 text-white rounded">Open with Footer</button>
            <% end %>
            <% drawer.with_drawer_content do |content| %>
              <% content.with_footer do %>
                <div class="flex gap-2">
                  <button class="px-4 py-2 bg-slate-600 text-white rounded">Save</button>
                  <button class="px-4 py-2 bg-gray-200 rounded" data-action="click->aeno--drawer#close">Cancel</button>
                </div>
              <% end %>
              <div class="space-y-4">
                <p class="text-gray-600">Content with footer actions.</p>
                <p class="text-gray-600">Notice the action buttons at the bottom.</p>
              </div>
            <% end %>
          <% end %>
        TEMPLATE
      end

      b.example(:with_header_and_footer, title: "With Header and Footer") do |e|
        e.preview_template standalone: true, template: <<~TEMPLATE
          <%= render(Aeno::Drawer::Component.new(standalone: true, width: "w-2/5")) do |drawer| %>
            <% drawer.with_trigger do %>
              <button class="px-4 py-2 bg-slate-600 text-white rounded">Open Full Drawer</button>
            <% end %>
            <% drawer.with_drawer_content do |content| %>
              <% content.with_header do %>
                <h2 class="text-lg font-semibold">Edit Profile</h2>
              <% end %>
              <% content.with_footer do %>
                <div class="flex gap-2">
                  <button class="px-4 py-2 bg-slate-600 text-white rounded">Save Changes</button>
                  <button class="px-4 py-2 bg-gray-200 rounded" data-action="click->aeno--drawer#close">Cancel</button>
                </div>
              <% end %>
              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                  <input type="text" class="w-full px-3 py-2 border rounded" placeholder="John Doe">
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                  <input type="email" class="w-full px-3 py-2 border rounded" placeholder="john@example.com">
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Bio</label>
                  <textarea class="w-full px-3 py-2 border rounded" rows="4" placeholder="Tell us about yourself..."></textarea>
                </div>
              </div>
            <% end %>
          <% end %>
        TEMPLATE
      end

      b.example(:nested, title: "Nested Drawers (Stacking)") do |e|
        e.preview_template standalone: true, template: <<~TEMPLATE
          <%= render(Aeno::Drawer::Component.new(standalone: true, width: "w-[700px]")) do |drawer1| %>
            <% drawer1.with_trigger do %>
              <%= render(Aeno::Button::Component.new(variant: :default, label: "Open First Drawer")) %>
            <% end %>
            <div class="p-6">
              <h2 class="text-lg font-semibold mb-4">First Drawer</h2>
              <%= render(Aeno::Drawer::Component.new(standalone: true, width: "w-[650px]")) do |drawer2| %>
                <% drawer2.with_trigger do %>
                  <%= render(Aeno::Button::Component.new(variant: :default, label: "Open Second Drawer")) %>
                <% end %>
                <div class="p-6">
                  <h2 class="text-lg font-semibold mb-4">Second Drawer</h2>
                  <%= render(Aeno::Drawer::Component.new(standalone: true, width: "w-[600px]")) do |drawer3| %>
                    <% drawer3.with_trigger do %>
                      <%= render(Aeno::Button::Component.new(variant: :default, label: "Open Third Drawer")) %>
                    <% end %>
                    <div class="p-6">
                      <h2 class="text-lg font-semibold">Third Drawer</h2>
                      <p class="text-gray-600">This demonstrates z-index stacking</p>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          <% end %>
        TEMPLATE
      end
    end
  end
end
