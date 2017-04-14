Rails.application.routes.draw do
  get 'pages/landing'

  resources :homes

  root 'pages#landing'

  get    '/auth/:provider'          => 'omniauth#auth',    as: :auth
  get    '/auth/:provider/callback' => 'session#create'
  get    '/auth/failure'            => 'session#failure'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
