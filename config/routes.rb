AllianceFasteners::Application.routes.draw do
  
  resources :items

  resources :images

  resources :attachments

  resources :organization_processes

  resources :contacts

  resources :comments

  resources :organizations do
      member do
          post 'populate'
      end

      resources :gauges do
          resources :dimensions
      end
  end

  get "static_pages/landing"

  get "static_pages/empty"

  get "static_pages/error_404"

  get "static_pages/error_500"

  resources :specifications


  resources :territories


  resources :commodities


  resources :company_infos


  resources :customer_qualities


  resources :vendor_qualities


  resources :owners


  resources :master_types


  resources :process_types


  resources :materials do
    resources :material_elements
  end

  resources :test_items


  resources :test_packages


  get "account/dashboard"

  devise_for :users, :path => 'auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :password => 'password' } do
      root :to => 'devise/sessions#new'
  end

  match "/tester" => "account#tester", via: [:get, :post] 

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

  match "/404" => "static_pages#error_404"
  match "/500" => "static_pages#error_500"

  # match ':not_found' => 'account#dashboard', :constraints => { :not_found => /.*/ }

  match "*path", :to => "static_pages#error_404"
end
