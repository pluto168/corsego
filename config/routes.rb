Rails.application.routes.draw do
  
  resources :enrollments do
    get :my, on: :collection
  end
  
  devise_for :users

  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  
  resources :users, only: [:index, :edit, :show, :update]
  
  #get 'static_pages/landing_pages'
  #get 'static_pages/privacy_policy'
  
  # get "static_pages/activity"
  get "activity", to: "static_pages#activity"

  get 'analytics', to: 'static_pages#analytics'
  
  # get 'charts/users_per_day', to: 'charts#users_per_day'
  # get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  # get 'charts/course_popularity', to: 'charts#course_popularity'
  # get 'charts/money_makers', to: 'charts#money_makers'
  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers' 
  end


  root "static_pages#landing_pages"
  get "static_pages/landing_pages"
  get "privacy_policy", to: "static_pages#privacy_policy"
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routi ng.html


end
