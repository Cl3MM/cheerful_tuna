require 'sidekiq/web'

CheerfulTuna::Application.routes.draw do

  resources :invoices

  match '/ISsYdQwCSALG36XEMkOmgM7yroE', to: 'members#proxy_check', via: [:get, :post],   as: :proxy_check
  # Price Comparator
  constraints subdomain: 'comparison' do
    match '/', to: 'costs_comparison#index', via: [:get, :post],   as: :pvcycle_comparator
  end
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.is_admin? }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :email_templates
  resources :mailings
  resources :articles
  resources :collection_points

  resources :html_snippets do
    member { post :mercury_update }
  end

  namespace :mercury do
    resources :images
  end

  mount Mercury::Engine => '/'

  devise_for :users, :path => "/users", :path_names => { :sign_in => 'login', :sign_out => 'logout' }
  devise_scope :user do
    get "login", to: "devise/sessions#new", as: :user_login
  end
  #match "members/profile" => "profiles#index", via: "get"
    #constraints :subdomain => "admin" do
    #end

  #match "joomla" => "joomla::users#new"
  namespace :joomla do
    match "/" => "users#new"
    get 'profile',  to: 'users#index'
    get 'login',    to: 'users#new'
    get 'logout',   to: 'users#destroy'
    resources :users, except: [:show, :edit]
    #get 'delivery_request', to: 'delivery_requests#new'
    match 'delivery_request_pdf/:id'  => 'delivery_requests#delivery_request_pdf',  as: :delivery_request_pdf,      via: :get,  format: :pdf
    match "delivery_request/nearbys"  => "delivery_requests#nearbys",               as: :delivery_request_nearbys,  via: :post, format: :json
    #resources :delivery_requests, only: [:create, :show, :new ]
  end

  constraints subdomain: 'request' do
    match '/',    to: 'joomla/delivery_requests#new',     via: :get,  as: :new_joomla_delivery_request
    match '/new', to: 'joomla/delivery_requests#new',     via: :get,  as: :new_joomla_delivery_request
    match '/',    to: 'joomla/delivery_requests#create',  via: :post, as: :joomla_delivery_requests
    match '/:id.:format', to: 'joomla/delivery_requests#delivery_request_pdf', via: :get,  as: :joomla_delivery_request_pdf, format: :pdf
    match '/:id', to: 'joomla/delivery_requests#show',    via: :get,  as: :joomla_delivery_request
  end
  resources :delivery_requests

  get "tags/:tag", to: "contacts#tag_cloud", as: :tag

  resources :email_listings

  match 'contacts/tag_cloud' => 'contacts#tag_cloud', as: :tag_cloud
  match 'contacts/search' => 'contacts#search', via: :get
  match 'contacts/statistics' => 'contacts#statistics', as: :stats_contacts
  match 'contacts/activation/:id' => 'contacts#activation', as: :contact_activation, via: :get
  match 'contacts/more_contacts/:id' => 'contacts#more_contacts', as: :more_contacts, via: :post
  match 'contacts/duplicate/:id' => 'contacts#duplicate', as: :duplicate

  resources :contacts do
    get 'page/:page', :action => :index, :on => :collection
  end
  #resources :contacts
  resources :members do
    resources :subscriptions
    #resources :memberships
    get 'page/:page', :action => :index, :on => :collection
  end
  match 'users/statistics' => 'users#statistics', as: :stats_users
  match "users/chart/:timeframe/:date" => "users#generate_chart", via: "post",
    as: :generate_chart, constraints: {timeframe: /week|month/, date: /\d{4}-\d{2}-\d{2}/},
    defaults: { timeframe: 'month', date: Date.today.to_json }
  #match "users/monthly_chart/:date", :to => "users#generate_chart", :via => "post", as: :generate_chart

  #resources :members
  match 'certificate/:checksum' => 'members#generate_certificate', as: :generate_certificate, via: [:post]
  #match "members/create_user_name/:company", :to => "members#create_user_name_from_company", :via => "post", as: :create_user_name

  root to: 'contacts#index'

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
