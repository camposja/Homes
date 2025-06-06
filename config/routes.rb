Rails.application.routes.draw do
  # Mount Shrine download endpoint
  mount Shrine.download_endpoint => "/attachments"

  get 'pages/landing'
  root 'pages#landing'

  resources :homes do
    member do
      post 'favorite'
      post 'unfavorite'
    end
  end

  get '/search', to: 'homes#index'

  get    '/auth/:provider',          to: 'omniauth#auth',  as: :auth
  get    '/auth/:provider/callback', to: 'session#create'
  get    '/auth/failure',            to: 'session#failure'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get  '/login',  to: 'session#new'
  post '/login',  to: 'session#create'
  get  '/logout', to: 'session#destroy'
end
