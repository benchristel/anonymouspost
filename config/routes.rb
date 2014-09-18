Anonymouspost::Application.routes.draw do
  resources :posts, only: [:index, :create]
end
