Rails.application.routes.draw do
  resources :genres
  root "movies#index"

  get "movies/filter/:filter" => "movies#index", as: :filtered_movies

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy]
  get "signin" => "sessions#new"
  get 'session' => redirect('/session/new') # guard against 404 on refresh
                                            # after un/pw fail

  resources :users
  get "signup" => "users#new"
end
