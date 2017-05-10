Rails.application.routes.draw do

  	root 'welcome#index'
  	get 'home' => 'home#index', as: :home, :alias => :home
  	resources :posts
  	devise_for :users, controllers: {registrations: 'users/registrations', confirmations: 'users/confirmations', :omniauth_callbacks => "users/omniauth_callbacks"}
end
