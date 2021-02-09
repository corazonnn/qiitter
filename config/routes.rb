Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'products#index'
  get 'toppages/index'
  resources :users, only: [:show] do
    member do
      get :likings
    end
  end
  resources :products
  resources :likes, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
