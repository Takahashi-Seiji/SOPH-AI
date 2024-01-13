Rails.application.routes.draw do
  devise_for :users
  root to: "pages#dashboard"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "dashboard" => "pages#dashboard", as: :dashboard
  get "welcome" => "pages#welcome", as: :welcome

  resources :lectures do
    resources :quizzes, only: [:create, :update, :destroy, :show]
    resources :notes
    resources :chats, only: [:create, :update, :destroy] do
      resources :messages, only: [:create]
    end
  end

  resources :messages, only: [:create]

  resources :chats do
    resources :messages, only: [:create]
  end
end
