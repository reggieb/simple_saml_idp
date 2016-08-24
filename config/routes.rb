Rails.application.routes.draw do

  resources :nowhere, only: [:create, :update]
  resource :identify, only: [:new]
  resources :manage_users, only: [:index]

  devise_for :users

  root 'home#index'

end
