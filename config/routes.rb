Rails.application.routes.draw do

  get 'items/show'
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users, only: [:new, :create, :show, :edit, :update] do
    resources :posts, only: [:create, :show, :update, :destroy] do
      resources :comments, only: [:create, :update, :destroy]
    end
  end
  resources :posts, only: [:index, :new]
  get '/users/:id/myposts', to: 'users#myposts', as: 'myposts'
  get '/users/:id/withdrawal', to: 'users#withdrawal', as: 'withdrawal'
  patch '/users/:id/withdrawal', to: 'users#quit', as: 'quit'
  resources :categories, only: [:index, :show] do
    resources :sections, only: [] do
      resources :items, only: [:show]
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :tags, only: [:index, :create, :update]
  resources :favorite_tags, only: [:create, :destroy]
  resources :post_tags, only: [:create, :destroy]
  resources :item_tags, only: [:create, :destroy]

  namespace :admin do
    root                'sessions#home'
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    resources :users, only: [:index, :show]
    patch '/users/:id/withdrawal', to: 'users#quit', as: 'admin_quit'
    resources :posts, only: [:index, :new, :create, :show, :update, :destroy] do
      resources :comments, only: [:index, :create, :update, :destroy]
    end
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :sections, only: [:index, :create, :show, :update, :destroy]
    end
    resources :items, only: [:create, :update, :destroy]
    resources :tags, only: [:index, :create, :update, :destroy]
    resources :post_tags, only: [:create, :destroy]
    resources :item_tags, only: [:create, :destroy]
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
