Rails.application.routes.draw do
  get 'consumption/get'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "consumption#get"
end
