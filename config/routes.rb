# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :item_channels
  get 'auto_complete' => 'so_lines#auto_complete'

  namespace :api do
    namespace :vi do
      resources :organizations
    end
  end

  resources :item_lots

  resources :events do
    member do
      get 'change_date'
    end
  end

  get 'permissions/error'

  resources :comments
  concern :commentable do
    resources :comments do
      member do
        delete 'delete_comment'
        post 'add_comment'
      end
    end
  end

  resources :quality_histories

  resources :notifications

  resources :credit_registers

  resources :check_registers

  resources :process_type_specifications

  resources :inventory_adjustments

  resources :quality_documents

  resources :so_mails
  resources :logos

  get 'home/index'

  resources :ppaps

  resources :check_list_lines

  resources :checklists

  resources :printing_screens

  resources :deposit_checks do
    collection do
      get 'report'
    end
  end

  resources :reconciles

  resources :packages

  resources :quality_actions do
    member do
      get 'quality_report'
    end
    get :autocomplete_quality_action_quality_action_no, on: :collection
  end

  resources :cause_analyses do
    get :autocomplete_cause_analysis_name, on: :collection
  end

  resources :customer_feedbacks

  resources :capacity_plannings

  resources :run_at_rates do
    get :autocomplete_run_at_rate_run_at_rate_name, on: :collection
  end

  resources :customer_quotes do
    resources :customer_quote_lines
    get 'populate', on: :member
  end

  # resources :customer_quotes

  resources :group_organizations

  resources :groups

  resources :check_codes

  resources :receivables do
    member do
      get 'invoice_report'
    end
    collection do
      get 'report'
    end
    resources :receivable_accounts
  end

  resources :payables do
    collection do
      get 'manual_new'
    end
    member do
      get 'manual_edit'
    end
    resources :payable_accounts
  end

  resources :check_entries do
    collection do
      post 'generate_check_entry'
      get 'report'
    end
  end

  resources :gl_entries do
    member do
      get 'populate'
    end
  end

  resources :gl_types

  resources :gl_accounts do
    get :autocomplete_gl_account_gl_account_title, on: :collection
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

  get 'quotes/quotes-history' => 'quotes#history', as: :quotes_history

  resources :quotes do
    resources :quote_vendors
  end

  resources :quotes do
    resources :quote_lines
    get 'populate', on: :member
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

  get 'common_actions/get_info'
  get 'quality_lots/lot_info'

  resources :control_plans do
    get :autocomplete_control_plan_plan_name, on: :collection
  end

  resources :fmea_types do
    get :autocomplete_fmea_type_fmea_name, on: :collection
  end

  resources :quality_lot_materials

  resources :process_flows do
    get :autocomplete_process_flow_process_name, on: :collection
  end

  resources :elements do
    get :autocomplete_element_element_name, on: :collection
  end

  resources :so_headers do
    concerns :commentable
    member do
      get 'report'
      get 'packing_report'
      get 'pick_report'
    end
    resources :so_lines
    member do
      get 'populate'
      get 'so_info'
    end
    get :autocomplete_so_header_so_identifier, on: :collection
  end

  resources :po_shipments

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', password: 'password' } do
    root to: 'devise/sessions#new'
  end

  resources :customer_quality_levels

  resources :po_headers do
    concerns :commentable
    member do
      get 'purchase_report'
    end
    resources :po_lines
    member do
      get 'populate'
      get 'po_info'
    end
    get :autocomplete_po_header_po_identifier, on: :collection
  end

  resources :quality_lots, except: :new do
    get :autocomplete_quality_lot_lot_control_no, on: :collection
    member do
      get 'populate'
      get 'material_report'
      get 'dimension_report'
      get 'gage_report'
      get 'psw_report'
      get 'csk_report'
      get 'package_report'
      get 'process_flow_report'
      get 'fmea_report'
    end
    collection do
      get 'report'
    end
    concerns :commentable
  end

  resources :items do
    resources :item_revisions do
      resources :item_part_dimensions
    end
    get :autocomplete_item_item_part_no, on: :collection
  end

  resources :privileges

  resources :item_selected_names do
    get :autocomplete_item_selected_name_item_name, on: :collection
  end

  resources :item_processes

  resources :item_materials

  resources :item_specifications

  resources :item_prints

  resources :prints do
    get :autocomplete_print_print_identifier, on: :collection
  end

  resources :item_alt_names do
    get :autocomplete_item_alt_name_item_alt_identifier, on: :collection
  end

  resources :gauges

  resources :dimensions

  resources :images

  resources :attachments

  resources :organization_processes

  resources :contacts do
    post 'set_default'
  end

  resources :addresses


  resources :organizations do
    concerns :commentable
    get 'main_address'
    post 'set_default'
    member do
      post 'populate'
      get 'organization_info'
    end
    get :autocomplete_organization_organization_name, on: :collection
  end

  get 'static_pages/landing'

  get 'static_pages/empty'

  get 'static_pages/error_404'

  get 'static_pages/error_500'

  resources :specifications

  resources :territories

  resources :commodities do
    get :autocomplete_commodity_commodity_identifier, on: :collection
  end

  resources :company_infos

  resources :customer_qualities do
    get 'set_default'
  end

  resources :vendor_qualities do
    get 'set_default'
  end

  resources :master_types

  resources :process_types do
    collection do
      get 'process_specs'
    end
  end

  resources :materials do
    resources :material_elements
    get :autocomplete_material_material_short_name, on: :collection
  end

  resources :test_items

  resources :test_packages

  ChessErp::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?
  end

  match '/tester' => 'account#tester', via: %i[get post]

  get 'account/dashboard'

  get '/404' => 'static_pages#error_404'
  get '/500' => 'static_pages#error_500'

  root to: 'account#dashboard'
end
