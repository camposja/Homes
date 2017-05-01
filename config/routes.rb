Rails.application.routes.draw do
  get 'pages/landing'
  root 'pages#landing'


  resources :homes do
    member do
      post 'favorite'
      post 'unfavorite'
    end
  end

  get '/search' => 'homes#index'

  get    '/auth/:provider'          => 'omniauth#auth',    as: :auth
  get    '/auth/:provider/callback' => 'session#create'
  get    '/auth/failure'            => 'session#failure'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get  '/login'  => 'session#new'
  post '/login'  => 'session#create'
  get  '/logout' => 'session#destroy'

  mount Shrine::DownloadEndpoint => "/attachments"
end
