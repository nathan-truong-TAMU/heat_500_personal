Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :events do
    collection do
      delete 'destroy_all' # Route for clearing all events
    end
  end

  resources :members
  root 'pages#home'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :meetings do
    get 'member_view', on: :collection
  end
    
  resources :links
  # resources :events_members
  resources :events_members, only: [:index, :create]

  resources :events_members do
    delete 'remove_member_from_event', on: :collection
  end

  # Add this route for toggling the authenticated view
  devise_scope :user do
    get 'toggle_view_mode', to: 'users/sessions#toggle_view_mode'
    get 'login', to: 'users/sessions#new'
    post 'login', to: 'users/sessions#create'
  
    get 'login_manual', to: 'users/sessions#login_manual'
    # get 'loginevent', to: 'users/sessions#newevent' 
    # get 'loginlink', to: 'users/sessions#newlink' 
  
    get 'one_time_logout', to: 'users/sessions#destroy'
  end

  get "/redirect", to: "calendars#redirect"
  get "/callback", to: "calendars#callback"

  get 'events_export', to: 'events_members#export', as: 'events_export'

  get '/check_member_attendance', to: 'members#check_member_attendance'
end
