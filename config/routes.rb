Jarviis::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resource :attachments, only: :destroy

      resources :issues do
        member do
          post :resolve
          post :close
          post :wontfix
          post :open
          get  :comments

          resources :attachments, only: :create
        end

        collection do
          get :search
        end
      end

      resources :users, only: :index do
        collection do
          get :search
        end
      end

      resources :comments, only: [:create, :destroy]

      resources :teams, only: [:index, :show]
    end
  end

  namespace :admin do
    resources :dashboard, only: :index
    resources :users, only: [:index, :destroy, :edit, :update]
  end

  devise_for :users

  root to: "dashboard#index"

  get "/issues/:id" => "dashboard#index"
end
