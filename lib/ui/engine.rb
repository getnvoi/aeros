require "importmap-rails"
require "view_component-contrib"
require "dry-effects"
require "tailwind_merge"

module Ui
  class << self
    attr_accessor :importmap
  end

  class Engine < ::Rails::Engine
    isolate_namespace Ui

    # Support both Propshaft and Sprockets
    initializer "ui.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app/javascript")
        app.config.assets.paths << root.join("app/components")
      end
    end

    initializer "ui.importmap", before: "importmap" do |app|
      Ui.importmap = Importmap::Map.new
      Ui.importmap.draw(app.root.join("config/importmap.rb"))
      Ui.importmap.draw(root.join("config/importmap.rb"))
      Ui.importmap.cache_sweeper(watches: root.join("app/components"))

      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end

      ActiveSupport.on_load(:action_controller_base) do
        before_action { Ui.importmap.cache_sweeper.execute_if_updated }
      end
    end
  end
end
