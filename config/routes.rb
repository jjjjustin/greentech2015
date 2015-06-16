Rails.application.routes.draw do
  
  devise_for :users
  resources :users, only: [:index, :show]
  
  resources :user_profiles, only: [:new, :create, :edit, :update]

  resources :templates

  get '/terms', to: 'pages#terms'
  get '/privacy', to: 'pages#privacy'

  resources :lessons do
    collection do
      post :sort
    end
  end

  resources :steps do
    collection do
      post :sort
    end
    get 'submit', on: :member
  end

  resources :fields do
    collection do
      post :sort
    end
  end

  resources :ideas do
    get :show_admin
  end

  # resources :plans do
  #   patch :unsubscribe

  #   get :edit_card
  #   patch :update_card
  #   patch :remove_card
  # end

  resources :plan_options

  authenticated :user do
    root :to => "ideas#index", as: :authenticated_root
  end

  root :to => "pages#landing"
end
