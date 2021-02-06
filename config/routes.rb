Rails.application.routes.draw do



  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'products#index'
  get 'toppages/index'
  get 'users/show' #ユーザのマイページ

  resources :products, only: [:show, :create, :new, :update, :edit, :destroy, :index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
