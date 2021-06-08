Rails.application.routes.draw do
  get '/bitcoin', to: 'bitcoin#index'
  get '/user', to: 'user#index'
  post '/transaction-usd', to: 'transaction#create'
  post '/transaction-btc', to: 'bitcoin#create'
  get '/transaction-list/:id', to: 'transaction#index'
  get '/transaction/:id', to: 'transaction#show'
end
