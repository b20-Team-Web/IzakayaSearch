Rails.application.routes.draw do
  get '/'         => 'home#top'
  get '/:params'  => 'home#top'
  get '/show/:id' => 'home#show'
  get '/gurunabi' => 'gurunabi#index'
end
