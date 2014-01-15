Jarviis::Application.routes.draw do
  devise_for :users

  root to: "sample#index"
end
