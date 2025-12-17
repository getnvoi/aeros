module Aeno::Empty
  class Component < ::Aeno::ApplicationViewComponent
    renders_one(:title)

    examples("Empty", description: "Empty state placeholder") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview do |empty|
          empty.with_title { "No items found" }
          "Try creating a new item to get started"
        end
      end
    end
  end
end
