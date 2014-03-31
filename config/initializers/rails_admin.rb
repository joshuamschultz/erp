# RailsAdmin config file. Generated on August 19, 2013 13:23
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Alliance Fasteners', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { } # auto-generated

  config.authorize_with{
    unless current_user.has_role? [:superadmin]
      redirect_to "/"
    end
 }
  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Attachment', 'Comment', 'Commodity', 'CompanyInfo', 'Contact', 'CustomerQuality', 'CustomerQualityLevel', 'Dimension', 'Gauge', 'Image', 'Item', 'ItemAltName', 'ItemMaterial', 'ItemPartDimension', 'ItemPrint', 'ItemProcess', 'ItemRevision', 'ItemSelectedName', 'ItemSpecification', 'MasterType', 'Material', 'MaterialElement', 'Organization', 'OrganizationProcess', 'Owner', 'PoHeader', 'PoLine', 'Print', 'ProcessType', 'SoLine', 'Specification', 'Territory', 'TestItem', 'TestPackage', 'User', 'VendorQuality']

  # Include specific models (exclude the others):
  # config.included_models = ['Attachment', 'Comment', 'Commodity', 'CompanyInfo', 'Contact', 'CustomerQuality', 'CustomerQualityLevel', 'Dimension', 'Gauge', 'Image', 'Item', 'ItemAltName', 'ItemMaterial', 'ItemPartDimension', 'ItemPrint', 'ItemProcess', 'ItemRevision', 'ItemSelectedName', 'ItemSpecification', 'MasterType', 'Material', 'MaterialElement', 'Organization', 'OrganizationProcess', 'Owner', 'PoHeader', 'PoLine', 'Print', 'ProcessType', 'SoLine', 'Specification', 'Territory', 'TestItem', 'TestPackage', 'User', 'VendorQuality']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



  ###  Attachment  ###

  # config.model 'Attachment' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your attachment.rb model definition

  #   # Found associations:

  #     configure :attachable, :polymorphic_association 
  #     configure :created_by, :belongs_to_association 
  #     configure :updated_by, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :attachable_id, :integer         # Hidden 
  #     configure :attachable_type, :string         # Hidden 
  #     configure :attachment_file_name, :string         # Hidden 
  #     configure :attachment_content_type, :string         # Hidden 
  #     configure :attachment_file_size, :string         # Hidden 
  #     configure :attachment, :paperclip 
  #     configure :attachment_revision_title, :string 
  #     configure :attachment_revision_date, :date 
  #     configure :attachment_effective_date, :date 
  #     configure :attachment_name, :string 
  #     configure :attachment_description, :string 
  #     configure :attachment_document_type, :string 
  #     configure :attachment_document_type_id, :integer 
  #     configure :attachment_notes, :text 
  #     configure :attachment_public, :boolean 
  #     configure :attachment_active, :boolean 
  #     configure :attachment_status, :string 
  #     configure :attachment_status_id, :integer 
  #     configure :attachment_created_id, :integer         # Hidden 
  #     configure :attachment_updated_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Comment  ###

  # config.model 'Comment' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your comment.rb model definition

  #   # Found associations:

  #     configure :commentable, :polymorphic_association 
  #     configure :created_by, :belongs_to_association 
  #     configure :updated_by, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :comment, :string 
  #     configure :comment_type, :string 
  #     configure :commentable_id, :integer         # Hidden 
  #     configure :commentable_type, :string         # Hidden 
  #     configure :comment_active, :boolean 
  #     configure :comment_created_id, :integer         # Hidden 
  #     configure :comment_updated_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Commodity  ###

  # config.model 'Commodity' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your commodity.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :commodity_active, :boolean 
  #     configure :commodity_created_id, :integer 
  #     configure :commodity_updated_id, :integer 
  #     configure :commodity_identifier, :string 
  #     configure :commodity_description, :string 
  #     configure :commodity_notes, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CompanyInfo  ###

  # config.model 'CompanyInfo' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your company_info.rb model definition

  #   # Found associations:

  #     configure :image, :has_one_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :company_name, :string 
  #     configure :company_address1, :text 
  #     configure :company_address2, :text 
  #     configure :company_phone1, :string 
  #     configure :company_phone2, :string 
  #     configure :company_mobile, :string 
  #     configure :company_fax, :string 
  #     configure :company_website, :string 
  #     configure :company_slogan, :string 
  #     configure :company_active, :boolean 
  #     configure :company_created_id, :integer 
  #     configure :company_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Contact  ###

  # config.model 'Contact' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your contact.rb model definition

  #   # Found associations:

  #     configure :contactable, :polymorphic_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :contactable_id, :integer         # Hidden 
  #     configure :contactable_type, :string         # Hidden 
  #     configure :contact_type, :string 
  #     configure :contact_title, :string 
  #     configure :contact_description, :string 
  #     configure :contact_address_1, :text 
  #     configure :contact_address_2, :text 
  #     configure :contact_city, :string 
  #     configure :contact_state, :string 
  #     configure :contact_country, :string 
  #     configure :contact_zipcode, :string 
  #     configure :contact_telephone, :string 
  #     configure :contact_fax, :string 
  #     configure :contact_email, :string 
  #     configure :contact_website, :string 
  #     configure :contact_notes, :text 
  #     configure :contact_active, :boolean 
  #     configure :contact_created_id, :integer 
  #     configure :contact_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :first_name, :string 
  #     configure :last_name, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CustomerQuality  ###

  # config.model 'CustomerQuality' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your customer_quality.rb model definition

  #   # Found associations:

  #     configure :organizations, :has_many_association 
  #     configure :item_revisions, :has_many_association 
  #     configure :po_lines, :has_many_association 
  #     configure :attachments, :has_many_association 
  #     configure :customer_quality_levels, :has_many_association 
  #     configure :master_types, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :quality_name, :string 
  #     configure :quality_description, :string 
  #     configure :quality_notes, :text 
  #     configure :quality_active, :boolean 
  #     configure :quality_created_id, :integer 
  #     configure :quality_updated_id, :integer 
  #     configure :quality_supplier_a, :boolean 
  #     configure :quality_supplier_b, :boolean 
  #     configure :quality_floor_plan, :boolean 
  #     configure :quality_form, :boolean 
  #     configure :quality_packaging, :boolean 
  #     configure :quality_psw, :boolean 
  #     configure :quality_control_plan, :boolean 
  #     configure :quality_fmea, :boolean 
  #     configure :quality_process_flow, :boolean 
  #     configure :quality_gauge, :boolean 
  #     configure :quality_study, :boolean 
  #     configure :quality_dimensional_cofc, :boolean 
  #     configure :quality_material_cofc, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CustomerQualityLevel  ###

  # config.model 'CustomerQualityLevel' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your customer_quality_level.rb model definition

  #   # Found associations:

  #     configure :customer_quality, :belongs_to_association 
  #     configure :master_type, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :customer_quality_id, :integer         # Hidden 
  #     configure :master_type_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Dimension  ###

  # config.model 'Dimension' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your dimension.rb model definition

  #   # Found associations:

  #     configure :item_part_dimensions, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :dimension_identifier, :string 
  #     configure :dimension_description, :string 
  #     configure :dimension_notes, :text 
  #     configure :dimension_active, :boolean 
  #     configure :dimension_created_id, :integer 
  #     configure :dimension_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Gauge  ###

  # config.model 'Gauge' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your gauge.rb model definition

  #   # Found associations:

  #     configure :organization, :belongs_to_association 
  #     configure :item_part_dimensions, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :organization_id, :integer         # Hidden 
  #     configure :gauge_tool_name, :string 
  #     configure :gauge_tool_category, :string 
  #     configure :gauge_tool_no, :string 
  #     configure :gage_caliberation_last_at, :date 
  #     configure :gage_caliberation_due_at, :date 
  #     configure :gage_caliberaion_period, :integer 
  #     configure :gauge_active, :boolean 
  #     configure :gauge_created_id, :integer 
  #     configure :gauge_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Image  ###

  # config.model 'Image' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your image.rb model definition

  #   # Found associations:

  #     configure :imageable, :polymorphic_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :imageable_id, :integer         # Hidden 
  #     configure :imageable_type, :string         # Hidden 
  #     configure :image_title, :string 
  #     configure :image_description, :string 
  #     configure :image_notes, :text 
  #     configure :image_file_name, :string         # Hidden 
  #     configure :image_content_type, :string         # Hidden 
  #     configure :image_file_size, :string         # Hidden 
  #     configure :image, :paperclip 
  #     configure :image_public, :boolean 
  #     configure :image_active, :boolean 
  #     configure :image_created_id, :integer 
  #     configure :image_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Item  ###

  # config.model 'Item' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item.rb model definition

  #   # Found associations:

  #     configure :item_revisions, :has_many_association 
  #     configure :item_part_dimensions, :has_many_association 
  #     configure :po_lines, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_part_no, :string 
  #     configure :item_quantity_on_order, :integer 
  #     configure :item_quantity_in_hand, :integer 
  #     configure :item_active, :boolean 
  #     configure :item_created_id, :integer 
  #     configure :item_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemAltName  ###

  # config.model 'ItemAltName' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_alt_name.rb model definition

  #   # Found associations:

  #     configure :item_selected_names, :has_many_association 
  #     configure :item_revisions, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_alt_identifier, :string 
  #     configure :item_alt_description, :string 
  #     configure :item_alt_notes, :text 
  #     configure :item_alt_active, :boolean 
  #     configure :item_alt_created_id, :integer 
  #     configure :item_alt_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemMaterial  ###

  # config.model 'ItemMaterial' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_material.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :material, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :material_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemPartDimension  ###

  # config.model 'ItemPartDimension' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_part_dimension.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :dimension, :belongs_to_association 
  #     configure :gauge, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :dimension_id, :integer         # Hidden 
  #     configure :gauge_id, :integer         # Hidden 
  #     configure :item_part_letter, :string 
  #     configure :item_part_dimension, :string 
  #     configure :item_part_pos_tolerance, :string 
  #     configure :item_part_neg_tolerance, :string 
  #     configure :item_part_critical, :boolean 
  #     configure :item_part_notes, :text 
  #     configure :item_part_active, :boolean 
  #     configure :item_part_created_id, :integer 
  #     configure :item_part_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemPrint  ###

  # config.model 'ItemPrint' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_print.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :print, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :print_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemProcess  ###

  # config.model 'ItemProcess' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_process.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :process_type, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :process_type_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemRevision  ###

  # config.model 'ItemRevision' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_revision.rb model definition

  #   # Found associations:

  #     configure :item, :belongs_to_association 
  #     configure :owner, :belongs_to_association 
  #     configure :organization, :belongs_to_association 
  #     configure :vendor_quality, :belongs_to_association 
  #     configure :customer_quality, :belongs_to_association 
  #     configure :print, :belongs_to_association 
  #     configure :material, :belongs_to_association 
  #     configure :item_processes, :has_many_association 
  #     configure :process_types, :has_many_association 
  #     configure :item_specifications, :has_many_association 
  #     configure :specifications, :has_many_association 
  #     configure :item_selected_names, :has_many_association 
  #     configure :item_alt_names, :has_many_association 
  #     configure :item_part_dimensions, :has_many_association 
  #     configure :attachments, :has_many_association 
  #     configure :po_lines, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_name, :string 
  #     configure :item_revision_date, :date 
  #     configure :item_id, :integer         # Hidden 
  #     configure :owner_id, :integer         # Hidden 
  #     configure :organization_id, :integer         # Hidden 
  #     configure :vendor_quality_id, :integer         # Hidden 
  #     configure :customer_quality_id, :integer         # Hidden 
  #     configure :item_name, :string 
  #     configure :item_description, :string 
  #     configure :item_notes, :text 
  #     configure :item_tooling, :decimal 
  #     configure :item_cost, :decimal 
  #     configure :item_revision_created_id, :integer 
  #     configure :item_revision_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :print_id, :integer         # Hidden 
  #     configure :material_id, :integer         # Hidden 
  #     configure :latest_revision, :boolean 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemSelectedName  ###

  # config.model 'ItemSelectedName' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_selected_name.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :item_alt_name, :belongs_to_association 
  #     configure :po_lines, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :item_alt_name_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ItemSpecification  ###

  # config.model 'ItemSpecification' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item_specification.rb model definition

  #   # Found associations:

  #     configure :item_revision, :belongs_to_association 
  #     configure :specification, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :specification_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  MasterType  ###

  # config.model 'MasterType' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your master_type.rb model definition

  #   # Found associations:

  #     configure :owners, :has_many_association 
  #     configure :type_based_organizations, :has_many_association 
  #     configure :contact_based_organizations, :has_many_association 
  #     configure :type_based_pos, :has_many_association 
  #     configure :customer_quality_levels, :has_many_association 
  #     configure :customer_qualities, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :type_name, :string 
  #     configure :type_description, :string 
  #     configure :type_category, :string 
  #     configure :type_active, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :type_value, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Material  ###

  # config.model 'Material' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your material.rb model definition

  #   # Found associations:

  #     configure :created_by, :belongs_to_association 
  #     configure :updated_by, :belongs_to_association 
  #     configure :material_elements, :has_many_association 
  #     configure :item_revisions, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :material_short_name, :string 
  #     configure :material_description, :string 
  #     configure :material_notes, :text 
  #     configure :material_created_id, :integer         # Hidden 
  #     configure :material_updated_id, :integer         # Hidden 
  #     configure :material_active, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  MaterialElement  ###

  # config.model 'MaterialElement' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your material_element.rb model definition

  #   # Found associations:

  #     configure :material, :belongs_to_association 
  #     configure :created_by, :belongs_to_association 
  #     configure :updated_by, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :material_id, :integer         # Hidden 
  #     configure :element_symbol, :string 
  #     configure :element_name, :string 
  #     configure :element_low_range, :string 
  #     configure :element_high_range, :string 
  #     configure :element_active, :boolean 
  #     configure :element_created_id, :integer         # Hidden 
  #     configure :element_updated_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Organization  ###

  # config.model 'Organization' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your organization.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 
  #     configure :organization_type, :belongs_to_association 
  #     configure :territory, :belongs_to_association 
  #     configure :customer_quality, :belongs_to_association 
  #     configure :contact_type, :belongs_to_association 
  #     configure :max_vendor_quality, :belongs_to_association 
  #     configure :vendor_quality, :belongs_to_association 
  #     configure :min_vendor_quality, :belongs_to_association 
  #     configure :comments, :has_many_association 
  #     configure :contacts, :has_many_association 
  #     configure :organization_processes, :has_many_association 
  #     configure :gauges, :has_many_association 
  #     configure :item_revisions, :has_many_association 
  #     configure :po_headers, :has_many_association 
  #     configure :po_lines, :has_many_association 
  #     configure :attachments, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :organization_type_id, :integer         # Hidden 
  #     configure :territory_id, :integer         # Hidden 
  #     configure :customer_quality_id, :integer         # Hidden 
  #     configure :customer_contact_type_id, :integer         # Hidden 
  #     configure :customer_max_quality_id, :integer         # Hidden 
  #     configure :vendor_quality_id, :integer         # Hidden 
  #     configure :vendor_expiration_date, :date 
  #     configure :organization_name, :string 
  #     configure :organization_short_name, :string 
  #     configure :organization_description, :string 
  #     configure :organization_address_1, :text 
  #     configure :organization_address_2, :text 
  #     configure :organization_city, :string 
  #     configure :organization_state, :string 
  #     configure :organization_country, :string 
  #     configure :organization_zipcode, :string 
  #     configure :organization_telephone, :string 
  #     configure :organization_fax, :string 
  #     configure :organization_email, :string 
  #     configure :organization_website, :string 
  #     configure :organization_notes, :text 
  #     configure :organization_active, :boolean 
  #     configure :organization_created_id, :integer 
  #     configure :organization_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :customer_min_quality_id, :integer         # Hidden 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  OrganizationProcess  ###

  # config.model 'OrganizationProcess' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your organization_process.rb model definition

  #   # Found associations:

  #     configure :organization, :belongs_to_association 
  #     configure :process_type, :belongs_to_association 
  #     configure :created_by, :belongs_to_association 
  #     configure :updated_by, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :organization_id, :integer         # Hidden 
  #     configure :process_type_id, :integer         # Hidden 
  #     configure :org_process_active, :boolean 
  #     configure :org_process_created_id, :integer         # Hidden 
  #     configure :org_process_updated_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Owner  ###

  # config.model 'Owner' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your owner.rb model definition

  #   # Found associations:

  #     configure :commission_type, :belongs_to_association 
  #     configure :items, :has_many_association 
  #     configure :item_revisions, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :owner_identifier, :string 
  #     configure :owner_description, :string 
  #     configure :owner_commission_type_id, :integer         # Hidden 
  #     configure :owner_commission_amount, :decimal 
  #     configure :owner_created_id, :integer 
  #     configure :owner_updated_id, :integer 
  #     configure :owner_active, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  PoHeader  ###

  # config.model 'PoHeader' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your po_header.rb model definition

  #   # Found associations:

  #     configure :po_type, :belongs_to_association 
  #     configure :organization, :belongs_to_association 
  #     configure :po_lines, :has_many_association 
  #     configure :comments, :has_many_association 
  #     configure :attachments, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :po_type_id, :integer         # Hidden 
  #     configure :organization_id, :integer         # Hidden 
  #     configure :po_identifier, :string 
  #     configure :po_description, :string 
  #     configure :po_total, :decimal 
  #     configure :po_status, :string 
  #     configure :po_notes, :text 
  #     configure :po_active, :boolean 
  #     configure :po_created_id, :integer 
  #     configure :po_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  PoLine  ###

  # config.model 'PoLine' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your po_line.rb model definition

  #   # Found associations:

  #     configure :po_header, :belongs_to_association 
  #     configure :organization, :belongs_to_association 
  #     configure :so_line, :belongs_to_association 
  #     configure :vendor_quality, :belongs_to_association 
  #     configure :customer_quality, :belongs_to_association 
  #     configure :item, :belongs_to_association 
  #     configure :item_revision, :belongs_to_association 
  #     configure :item_selected_name, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :po_header_id, :integer         # Hidden 
  #     configure :organization_id, :integer         # Hidden 
  #     configure :so_line_id, :integer         # Hidden 
  #     configure :vendor_quality_id, :integer         # Hidden 
  #     configure :customer_quality_id, :integer         # Hidden 
  #     configure :item_id, :integer         # Hidden 
  #     configure :item_revision_id, :integer         # Hidden 
  #     configure :item_selected_name_id, :integer         # Hidden 
  #     configure :po_line_customer_po, :string 
  #     configure :po_line_cost, :decimal 
  #     configure :po_line_quantity, :integer 
  #     configure :po_line_total, :decimal 
  #     configure :po_line_status, :string 
  #     configure :po_line_notes, :text 
  #     configure :po_line_active, :boolean 
  #     configure :po_line_created_id, :integer 
  #     configure :po_line_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Print  ###

  # config.model 'Print' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your print.rb model definition

  #   # Found associations:

  #     configure :item_revisions, :has_many_association 
  #     configure :attachment, :has_one_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :print_active, :boolean 
  #     configure :print_created_id, :integer 
  #     configure :print_updated_id, :integer 
  #     configure :print_identifier, :string 
  #     configure :print_description, :string 
  #     configure :print_notes, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ProcessType  ###

  # config.model 'ProcessType' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your process_type.rb model definition

  #   # Found associations:

  #     configure :organization_processes, :has_many_association 
  #     configure :item_processes, :has_many_association 
  #     configure :item_revisions, :has_many_association 
  #     configure :attachment, :has_one_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :process_short_name, :string 
  #     configure :process_description, :string 
  #     configure :process_notes, :text 
  #     configure :process_active, :boolean 
  #     configure :process_created_id, :integer 
  #     configure :process_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  SoLine  ###

  # config.model 'SoLine' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your so_line.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Specification  ###

  # config.model 'Specification' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your specification.rb model definition

  #   # Found associations:

  #     configure :item_specifications, :has_many_association 
  #     configure :item_revisions, :has_many_association 
  #     configure :attachment, :has_one_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :specification_active, :boolean 
  #     configure :specification_created_id, :integer 
  #     configure :specification_updated_id, :integer 
  #     configure :specification_identifier, :string 
  #     configure :specification_description, :string 
  #     configure :specification_notes, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Territory  ###

  # config.model 'Territory' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your territory.rb model definition

  #   # Found associations:

  #     configure :organizations, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :territory_active, :boolean 
  #     configure :territory_created_id, :integer 
  #     configure :territory_updated_id, :integer 
  #     configure :territory_identifier, :string 
  #     configure :territory_description, :string 
  #     configure :territory_zip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  TestItem  ###

  # config.model 'TestItem' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your test_item.rb model definition

  #   # Found associations:

  #     configure :test_package, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :test_package_id, :integer         # Hidden 
  #     configure :item_name, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  TestPackage  ###

  # config.model 'TestPackage' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your test_package.rb model definition

  #   # Found associations:

  #     configure :test_items, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:

  #     configure :organization, :has_one_association 
  #     configure :created_materials, :has_many_association 
  #     configure :updated_materials, :has_many_association 
  #     configure :created_elements, :has_many_association 
  #     configure :updated_elements, :has_many_association 
  #     configure :created_comments, :has_many_association 
  #     configure :updated_comments, :has_many_association 
  #     configure :created_org_processes, :has_many_association 
  #     configure :updated_org_processes, :has_many_association 
  #     configure :created_attachments, :has_many_association 
  #     configure :updated_attachments, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :name, :string 
  #     configure :gender, :string 
  #     configure :address, :text 
  #     configure :city, :string 
  #     configure :state, :string 
  #     configure :country, :string 
  #     configure :telephone_no, :string 
  #     configure :mobile_no, :string 
  #     configure :fax, :string 
  #     configure :active, :boolean 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :confirmation_token, :string 
  #     configure :confirmed_at, :datetime 
  #     configure :confirmation_sent_at, :datetime 
  #     configure :unconfirmed_email, :string 
  #     configure :failed_attempts, :integer 
  #     configure :unlock_token, :string 
  #     configure :locked_at, :datetime 
  #     configure :authentication_token, :string 
  #     configure :roles_mask, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  VendorQuality  ###

  # config.model 'VendorQuality' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your vendor_quality.rb model definition

  #   # Found associations:

  #     configure :organizations, :has_many_association 
  #     configure :max_quality_customers, :has_many_association 
  #     configure :min_quality_customers, :has_many_association 
  #     configure :item_revisions, :has_many_association 
  #     configure :po_lines, :has_many_association 
  #     configure :attachments, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :quality_name, :string 
  #     configure :quality_description, :string 
  #     configure :quality_notes, :text 
  #     configure :quality_active, :boolean 
  #     configure :quality_created_id, :integer 
  #     configure :quality_updated_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
