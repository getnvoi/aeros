pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "ui/application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from(
  Ui::Engine.root.join("app/javascript/ui/controllers"),
  under: "ui/controllers",
)

pin_all_from(
  Ui::Engine.root.join("app/components/ui"),
  under: "ui/components",
  to: "ui"
)