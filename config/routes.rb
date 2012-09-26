CheerfulTuna::Application.routes.draw do

  #get "stat/index"
  #get "stat/user"
  #get "stat/contact"

  devise_for :users, :path => "/users", :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  #match "members/profile" => "profiles#index", via: "get"

  #devise_for :members, :path => "/members", :path_names => { :sign_in => 'login', :sign_out => 'logout' }, :controllers => { :confirmations => "members/confirmations" }
  #as :member do
    #match 'members/confirmation' => 'members/confirmations#update', :via => :put, :as => :update_member_confirmation
  #end

  #resources :countries
  resources :email_listings

  match 'contacts/statistics' => 'contacts#statistics', as: :stats_contacts
  match 'contacts/more_contacts/:id' => 'contacts#more_contacts', as: :more_contacts, via: ["post", "get"]#, constraints: {id: /\d/}
  match 'contacts/duplicate/:id' => 'contacts#duplicate', as: :duplicate
  resources :contacts
  resources :contacts do
    get 'page/:page', :action => :index, :on => :collection
  end
  match 'users/statistics' => 'users#statistics', as: :stats_users
  match "users/chart/:timeframe/:date" => "users#generate_chart", via: "post",
    as: :generate_chart, constraints: {timeframe: /week|month/, date: /\d{4}-\d{2}-\d{2}/},
    defaults: { timeframe: 'month', date: Date.today.to_json }
  #match "users/monthly_chart/:date", :to => "users#generate_chart", :via => "post", as: :generate_chart

  resources :members
  #match "members/create_user_name/:company", :to => "members#create_user_name_from_company", :via => "post", as: :create_user_name

  root :to => 'contacts#index'

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
