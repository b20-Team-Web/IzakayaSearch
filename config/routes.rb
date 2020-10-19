Rails.application.routes.draw do
  get '/', to: 'home#top', as: 'top'
  get '/show/:id', to: 'home#show', as: 'show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/gurunabi' => 'gurunabi#index'
end
