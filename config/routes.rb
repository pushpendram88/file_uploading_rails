Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # Defines the root path route ("/")
  # root "posts#index"
  get "up" => "rails/health#show", as: :rails_health_check
  post '/login', to: 'users#create'
  delete '/logout', to: 'users#destroy'
  resource :file_upload, :controller => "holes", only: [:create]
  resources :data_visualization, :controller => "hole_details", only: %i[index create]
end
