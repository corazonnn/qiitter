Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'products#index'
  get 'toppages/index'
  resources :users, only: [:show] do
    member do #URLを深掘りするオプションを付与する
      get :followings #user/id/followings.つまり特定のユーザの全フォローを表示
      get :followers
    end
  end
  resources :products
  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
