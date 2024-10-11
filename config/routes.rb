Rails.application.routes.draw do
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :meetings
  # resources :meetings do
  #   get 'attendance', on: :collection
  # end
  resources :meetings do
    get 'member_view', on: :collection
    #delete 'remove_member', to: 'meetings#remove_member_from_meeting', as: 'remove_member_from_meeting'
  end
  resources :meetings_members do
    delete 'remove_member_from_meeting', on: :collection, as: 'remove_member_from_meeting_meetings_member'
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
  
    get 'login2', to: 'users/sessions#new2'
    get 'loginevent', to: 'users/sessions#newevent' 
    get 'loginlink', to: 'users/sessions#newlink' 
  
    get 'one_time_logout', to: 'users/sessions#destroy'
  end


  get "/redirect", to: "calendars#redirect"
  get "/callback", to: "calendars#callback"

  # for exporting table data
  get 'meetings_export', to: 'meetings_members#export', as: 'meetings_export'

  get 'events_export', to: 'events_members#export', as: 'events_export'

  resources :speeches
  post '/read_and_convert', to: 'speeches#read_and_convert' 

  get '/check_member_attendance', to: 'members#check_member_attendance'

  
end
