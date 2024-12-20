Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create, :show] do
    member do
      get :available_events
      put :book_event
    end
  end
end
