Rails.application.routes.draw do

  root "home#index"

  get "embed", to: "embed#index", constaints: {format: /html/}

end
