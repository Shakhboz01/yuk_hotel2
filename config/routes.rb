Rails.application.routes.draw do
  resources :expenditures do
    collection do
      get :payment_expenditure
      get :product_expenditure
    end
  end
  resources :product_prices
  devise_for :users
  resources :products

  # pages
  get 'main_page', to: 'pages#main_page'
  get 'dashboard', to: 'pages#dashboard'
  root 'pages#welcoming_page'

  resources :books
  resources :users do
    get :toggle_active_user, on: :member
  end
  resources :outcomers do
    member do
      get :toggle_active_outcomer
      get :show_buyer
      get :show_supplier
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
