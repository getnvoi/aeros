module Aeno::Sidebar
  class Component < Aeno::ApplicationViewComponent
    renders_many(:items, Aeno::Sidebar::Item)
    renders_many(:groups, Aeno::Sidebar::Group)
    renders_one(:header)
    renders_one(:footer)

    style :menu do
      base { "flex w-full min-w-0 flex-col gap-1" }
    end

    examples("Sidebar", description: "Navigation sidebar with items and groups") do |b|
      b.example(:basic, title: "Basic") do |e|
        e.preview css: "w-64" do |sidebar|
          sidebar.with_item(label: "Dashboard", href: "#", icon: "layout-dashboard")
          sidebar.with_item(label: "Projects", href: "#", icon: "folder")
          sidebar.with_item(label: "Settings", href: "#", icon: "settings")
        end
      end
    end
  end
end
