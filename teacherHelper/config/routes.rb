Rails.application.routes.draw do
  resources :evaluations, only: [:new, :create, :show]
  root "evaluations#new"
end
