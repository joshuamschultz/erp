AllianceFasteners::Application.routes.draw do

  resources :run_at_rates


  resources :customer_quotes do
    resources :customer_quote_lines
  end

  #resources :customer_quotes


  resources :group_organizations


  resources :groups


  resources :check_codes

  resources :receivables do
    resources :receivable_accounts
  end

  resources :payables do
    resources :payable_accounts
  end

  resources :check_entries do
    collection do
      post 'generate_check_entry'
    end
  end


  resources :gl_entries do
    member do
      post 'populate'
    end
  end

  resources :gl_types

  resources :gl_accounts do
    get :autocomplete_gl_account_gl_account_title, :on => :collection
    member do
      get 'gl_account_info'
    end
  end

  resources :payable_po_shipments

  resources :receivable_so_shipments

  resources :so_shipments

  resources :quality_lot_gauges do
    resources :quality_lot_gauge_results
  end

  resources :quality_lot_gauges do
    resources :quality_lot_gauge_dimensions
  end

  resources :quality_lot_gauges

  get "quotes/quotes-history" => 'quotes#history', as: :quotes_history

  resources :quotes do
    resources :quote_vendors
  end



  resources :quotes do
    resources :quote_lines
    member do
      post 'populate'
    end
  end


  resources :quotes

  resources :quote_line_costs

  resources :receipts do
    resources :receipt_lines
  end

  resources :receivables do
    resources :receivable_lines
  end

  resources :receivables do
    resources :receivable_shipments
  end

  resources :receivables

  resources :payments do
    resources :payment_lines
  end

  resources :payments

  resources :payables do
    resources :payable_lines
  end

  resources :payables do
    resources :payable_shipments
  end

  resources :quality_lot_capabilities

  resources :payables

  resources :quality_lot_dimensions

  get "common_actions/get_info"
  get "quality_lots/lot_info"

  resources :control_plans do
    get :autocomplete_control_plan_plan_name, :on => :collection
  end

  resources :fmea_types do
    get :autocomplete_fmea_type_fmea_name, :on => :collection
  end

  resources :quality_lot_materials


  resources :process_flows do
    get :autocomplete_process_flow_process_name, :on => :collection
  end

  resources :elements do
    get :autocomplete_element_element_name, :on => :collection
  end

  resources :so_headers do
    resources :so_lines
    member do
      post 'populate'
      get 'so_info'
    end
    get :autocomplete_so_header_so_identifier, :on => :collection
  end

  resources :po_shipments

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :path => 'auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :password => 'password' } do
    root :to => 'devise/sessions#new'
  end

  resources :customer_quality_levels

  resources :po_headers do
    resources :po_lines
    member do
      post 'populate'
      get 'po_info'
    end
    get :autocomplete_po_header_po_identifier, :on => :collection
  end

  resources :quality_lots do
    member do
      post 'populate'
    end
  end

  resources :items do
    resources :item_revisions do
      resources :item_part_dimensions
    end
    get :autocomplete_item_item_part_no, :on => :collection
  end

  resources :privileges

  resources :item_selected_names do
    get :autocomplete_item_selected_name_item_name, :on => :collection
  end

  resources :item_processes

  resources :item_materials

  resources :item_specifications

  resources :item_prints

  resources :prints do
    get :autocomplete_print_print_identifier, :on => :collection
  end

  resources :item_alt_names do
    get :autocomplete_item_alt_name_item_alt_identifier, :on => :collection
  end

  resources :gauges

  resources :dimensions

  resources :images

  resources :attachments

  resources :organization_processes

  resources :contacts do
    get 'set_default'
  end

  resources :comments

  resources :organizations do
    get 'main_address'
    member do
      post 'populate'
      get 'organization_info'
    end
    get :autocomplete_organization_organization_name, :on => :collection
  end

  get "static_pages/landing"

  get "static_pages/empty"

  get "static_pages/error_404"

  get "static_pages/error_500"

  resources :specifications


  resources :territories


  resources :commodities do
    get :autocomplete_commodity_commodity_identifier, :on => :collection
  end


  resources :company_infos


  resources :customer_qualities do
    get 'set_default'
  end


  resources :vendor_qualities do
    get 'set_default'
  end


  resources :owners


  resources :master_types


  resources :process_types


  resources :materials do
    resources :material_elements
    get :autocomplete_material_material_short_name, :on => :collection
  end

  resources :test_items


  resources :test_packages

  match "/tester" => "account#tester", via: [:get, :post]


  get "account/dashboard"

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

  # match "*path", :to => "static_pages#error_404"
end