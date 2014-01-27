Jarviis::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :issues
    end
  end

  devise_for :users

  root to: "dashboard#index"
end
