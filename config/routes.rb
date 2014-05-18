Jarviis::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :issues do
        member do
          post :resolve
          post :close
          post :wontfix
          post :open
        end
      end
      resources :users, only: :index do
        collection do
          get :search
        end
      end
    end
  end

  devise_for :users

  root to: "dashboard#index"

  get "/issues/:id" => "dashboard#index"
end
