Rails.application.routes.draw do
  devise_for :users
  resources :evaluations, only: [:new, :create, :show]
  root "evaluations#new"
end
