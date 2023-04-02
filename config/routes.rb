Rails.application.routes.draw do
  resources :product_prices
  devise_for :users
  resources :products
  root 'books#index'
  resources :books
  resources :users
  resources :outcomers do
    member do
      get :show_buyer
      get :show_supplier
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
