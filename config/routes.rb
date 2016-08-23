Rails.application.routes.draw do

  resources :nowhere, only: [:create, :update], controller: 'nowhere'

  get 'manage_users', to: 'manage_users#index'

  devise_for :users

  root 'home#index'

end
