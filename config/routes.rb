Jarviis::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :issues
      resources :users, only: :index
    end
  end

  devise_for :users

  root to: "dashboard#index"

  get "/issues/:id" => "dashboard#index"
end
