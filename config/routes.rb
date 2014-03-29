Jarviis::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :issues do
        member do
          post :resolve
        end
      end
      resources :users, only: :index
    end
  end

  devise_for :users

  root to: "dashboard#index"

  get "/issues/:id" => "dashboard#index"
end
