Rails.application.routes.draw do
  resources :enrollments
  devise_for :users

  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  
  resources :users, only: [:index, :edit, :show, :update]
  
  #get 'static_pages/landing_pages'
  #get 'static_pages/privacy_policy'
  
  # get "static_pages/activity"
  get "activity", to: "static_pages#activity"
  get "static_pages/landing_pages"
  get "privacy_policy", to: "static_pages#privacy_policy"
  
  root "static_pages#landing_pages"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routi ng.html


end
