module Aeno::Card
  class Component < ::Aeno::ApplicationViewComponent
    style do
      base { "shadow-lg ring ring-stone-400/20 rounded-lg" }
    end

    examples("Card", description: "Container with shadow and border") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview css: "p-6"
      end
    end
  end
end
