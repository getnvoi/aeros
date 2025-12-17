Rails.application.routes.draw do
  get "example", to: "home#index"

  mount Aeno::Engine => "/"
end
