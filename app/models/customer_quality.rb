class CustomerQuality < ActiveRecord::Base
  attr_accessible :quality_active, :quality_control_plan, :quality_created_id, :quality_description, :quality_dimensional_cofc, :quality_floor_plan, :quality_fmea, :quality_form, :quality_gauge, :quality_material_cofc, :quality_name, :quality_notes, :quality_packaging, :quality_process_flow, :quality_psw, :quality_study, :quality_supplier_a, :quality_supplier_b, :quality_updated_id

  after_initialize :default_values

  def default_values
    	self.quality_active ||= true
  end

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 50) if validates_presence_of :quality_name

  validates_length_of :quality_description, :maximum => 50

  validates_length_of :quality_notes, :maximum => 200
end
