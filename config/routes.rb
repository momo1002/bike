# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'home#index'

  resources :spots, only: %i[index new create show edit update]

  get 'login', to: 'sessions#new'
  get 'signup', to: 'users#new'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get  '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :spots do
    member do
      delete :destroy
    end
  end

  resources :spots do
    member do
      delete :delete_image
    end
  end
end
