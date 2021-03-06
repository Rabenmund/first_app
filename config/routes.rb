BasicApp::Application.routes.draw do
  root to: 'static_pages#home'
  
  # users
  get '/signup',          to: 'users#new'
  get '/activate/:id',    to: 'users#activate',         as: :activate
  get '/deactivate/:id',  to: 'users#deactivate',       as: :deactivate
  resources :users do #, except: [:destroy]
    resources :seasons do
      resources :matchdays do
        get '/tipps/index', to: 'tipps#index'
        post '/tipps/save_tipps', to: 'tipps#save_tipps'
        post '/tipps/select_user', to: 'tipps#select_user'
      end
    end
  end
  
  # sessions
  resources :sessions, only: [:new, :create, :destroy]
  get '/signin',          to: 'sessions#new'
  
  # microposts
  resources :microposts, only: [:create, :destroy]
  
  # static_pages
  get '/help',            to: 'static_pages#help'
  get '/about',           to: 'static_pages#about'
  get '/contact',         to: 'static_pages#contact'
  get '/landing',         to: 'static_pages#landing'
  get '/home',            to: 'static_pages#home'
  
  # teams
  resources :teams
  
  # seasons
  resources :seasons do
    resources :matchdays do
      member do
        put 'in_row'
        put 'redate_games'
      end
      resources :games 
      get '/listings/overview', to: 'listings#overview'
      get '/listings/tipplist', to: 'listings#tipplist'
    end
  end
  post 'seasons/:id/calculate',  to: 'seasons#calculate'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
