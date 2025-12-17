pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "aeno/application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from(
  Aeno::Engine.root.join("app/javascript/aeno/controllers"),
  under: "aeno/controllers",
)

pin_all_from(
  Aeno::Engine.root.join("app/components/aeno"),
  under: "aeno/components",
  to: "aeno"
)
