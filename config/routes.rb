Rails.application.routes.draw do

  root "home#index"

  get "embed", to: "embed#index"

end
