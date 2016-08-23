Rails.application.routes.draw do

  get 'manage_users', to: 'manage_users#index'

  devise_for :users

  root 'home#index'

end
