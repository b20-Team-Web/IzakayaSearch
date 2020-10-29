Rails.application.routes.draw do
  get '/', to: 'home#top', as: 'top'

  get '/show/:id' => 'home#show'
  get '/gurunabi' => 'gurunabi#index'
end
