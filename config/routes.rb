Rails.application.routes.draw do
  resources :outcomer_prepayments
  resources :transaction_histories
  resources :incomes do
    collection do
      post :new_income
      get :define_outcomer
    end
  end
  resources :packages do
    collection do
      post :new_package
    end
  end

  resources :sausages do
    collection do
      get :operators_payment
    end
  end
  resources :machine_sizes
  resources :participations do
    collection do
      post 'accept_new_participation', action: :accept_new_participation, as: :accept_new_participation
    end
  end
  resources :billets do
    collection do
      post :new_billet, as: :new_billet
    end
  end
  resources :expenditures do
    collection do
      get :payment_expenditure
      get :product_expenditure
    end
  end
  resources :product_prices
  devise_for :users, controllers: { sessions: 'sessions' }
  resources :products

  # pages
  get 'main_page', to: 'pages#main_page'
  get 'dashboard', to: 'pages#dashboard'
  get 'roles', to: 'pages#roles'

  root 'pages#welcoming_page'

  resources :users do
    get :toggle_active_user, on: :member
    get :new_user_form, on: :collection
    post :auto_user_creation, on: :collection
  end
  resources :refunds
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
