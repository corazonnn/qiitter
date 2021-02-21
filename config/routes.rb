Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'products#index'
  resources :users, only: [:show] do
    member do #URLを深掘りするオプションを付与する
      get :likings
      get :followings #user/id/followings.つまり特定のユーザの全フォローを表示
      get :followers
    end
  end
  resources :products do
    resources :comments, only: [:create, :destroy]
    collection do
      get :search
      get :graph
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: [:index, :destroy]


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
