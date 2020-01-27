Rails.application.routes.draw do
  get '/create_array/:num_elements', to: 'application#create_array'
  get '/return_array/:element', to: 'application#return_array'
end
