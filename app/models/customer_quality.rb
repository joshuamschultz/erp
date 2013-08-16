class CustomerQuality < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :quality_active, :quality_control_plan, :quality_created_id, :quality_description, 
  :quality_dimensional_cofc, :quality_floor_plan, :quality_fmea, :quality_form, :quality_gauge, 
  :quality_material_cofc, :quality_name, :quality_notes, :quality_packaging, :quality_process_flow, 
  :quality_psw, :quality_study, :quality_supplier_a, :quality_supplier_b, :quality_updated_id

  after_initialize :default_values

  def default_values
    	self.quality_active = true if self.quality_active.nil?
  end

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 50) if validates_presence_of :quality_name

  validates_length_of :quality_description, :maximum => 50

  validates_length_of :quality_notes, :maximum => 200

  has_many :organizations

  has_many :item_revisions
  has_many :po_lines

  has_many :attachments, :as => :attachable, :dependent => :destroy

  has_many :customer_quality_levels, :dependent => :destroy
  has_many :master_types, :through => :customer_quality_levels 

  def redirect_path
      customer_quality_path(self)
  end

  def self.quality_level_associations(customer_quality, params)

    if customer_quality
      quality_levels = params[:customer_quality_levels] || []
      customer_quality.customer_quality_levels.where(:master_type_id != quality_levels).destroy_all
    end
    
    if quality_levels
      quality_levels.each do |quality_id|
        unless customer_quality.customer_quality_levels.find_by_id(quality_id)
            customer_quality.customer_quality_levels.new(:master_type_id => quality_id).save
        end
      end
    end
  end

end
