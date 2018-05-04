Rails.application.routes.draw do

  root 'static_pages#home'
 
  get '/help'      => 'static_pages#help'
 
  get '/about'     => 'static_pages#about'
 
  get '/signup'    => 'users#new'
 
  get '/login'     => 'sessions#new'

  post '/login'    => 'sessions#create'

  delete '/logout' => 'sessions#destroy'

  # post '/create' => 'users#create', as:'users'

  # get '/:id/'    => 'users#show', as:'user'
  resources :microposts, only: [:create, :destroy]
  resources :users, except: :new do
    member do  #memberメソッドを使うとユーザーidがURLに含まれるように扱う
      get :following, :followers #/users/:id/followers(.:format)
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]


	#GET /users/1/following  following following_user_path(1)
  #GET /users/1/followers  followers followers_user_path(1

end
