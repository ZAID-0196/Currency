Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "currency_converters#index"
  post "convert_currency", to: "currency_converters#convert_currency"
end
