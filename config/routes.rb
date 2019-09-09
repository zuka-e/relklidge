Rails.application.routes.draw do
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
