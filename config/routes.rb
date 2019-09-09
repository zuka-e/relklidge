Rails.application.routes.draw do
  namespace :admin do
    get 'tags/index'
  end
  namespace :admin do
    get 'sections/index'
    get 'sections/show'
  end
  namespace :admin do
    get 'categories/index'
    get 'categories/new'
    get 'categories/edit'
  end
  namespace :admin do
    get 'comments/index'
  end
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
    get 'posts/new'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end
  namespace :admin do
    get 'sessions/new'
  end
  get 'tags/index'
  get 'sections/index'
  get 'sections/show'
  get 'categories/index'
  get 'posts/index'
  get 'posts/new'
  get 'posts/show'
  get 'users/new'
  get 'users/show'
  get 'users/edit'
  get 'users/withdrawal'
  get 'sessions/new'
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
