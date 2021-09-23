Rails.application.routes.draw do
  root to: "home#index"
  devise_for :players, controllers: {sessions: "sessions"}
  mount ActionCable.server => '/cable'
  get '/:slug', to: 'games#show', as: :game
  resources :players, only: %i(show), param: :username
  resources :games, only: %i(create), param: :slug do
    member do
      post 'accept_invite'
      post 'play'
      post 'rematch'
    end
  end
end
