class Item < ActiveRecord::Base
  attr_accessible :owner_id, :organization_id, :item_active, :item_cost, :item_created_id, 
  :item_description, :item_name, :item_notes, :item_part_no, :item_quantity_in_hand, 
  :item_quantity_on_order, :item_revision, :item_revision_date, :item_tooling, :item_updated_id

  after_initialize :default_values

  def default_values
    self.item_active = true if self.item_active.nil?
  end

  validates_presence_of :owner
  validates_presence_of :organization
  (validates_uniqueness_of :item_part_no if validates_length_of :item_part_no, :minimum => 2, :maximum => 50) if validates_presence_of :item_part_no
  validates_length_of :item_name, :minimum => 2, :maximum => 50 if validates_presence_of :item_name

  belongs_to :owner
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]

  has_many :item_prints, :dependent => :destroy
  has_many :prints, :through => :item_prints

  has_many :item_materials, :dependent => :destroy
  has_many :materials, :through => :item_materials

  has_many :item_processes, :dependent => :destroy
  has_many :process_types, :through => :item_processes

  has_many :item_specifications, :dependent => :destroy
  has_many :specifications, :through => :item_specifications 

  has_many :item_selected_names, :dependent => :destroy
  has_many :item_alt_names, :through => :item_selected_names

  has_many :item_part_dimensions, :dependent => :destroy

  	def self.process_item_associations(item, params)
      alt_names = params[:alt_names].split(",") || []
      alt_name_ids = ItemAltName.where(:item_alt_identifier => alt_names)
      item.item_selected_names.where(:item_alt_name_id != alt_name_ids).destroy_all

  		processes = params[:processes] || []
  		item.item_processes.where(:process_type_id != processes).destroy_all

  		prints = params[:prints] || []
  		item.item_prints.where(:print_id != prints).destroy_all

  		specs = params[:specs] || []
  		item.item_specifications.where(:specification_id != specs).destroy_all

  		materials = params[:materials] || []
  		item.item_materials.where(:material_id != materials).destroy_all

      if alt_names
          alt_names.each do |alt_name|
            item_alt_name = ItemAltName.find_by_item_alt_identifier(alt_name)

            unless item_alt_name            
                item_alt_name = ItemAltName.new(:item_alt_identifier => alt_name)
                item_alt_name.save
            end

            unless item_alt_name.nil? && item.item_selected_names.find_by_item_alt_name_id(item_alt_name.id)
                item.item_selected_names.new(:item_alt_name_id => item_alt_name.id).save
            end
          end
      end

  		if processes
	      	processes.each do |process_id|
    				unless item.item_processes.find_by_process_type_id(process_id)
    					  item.item_processes.new(:process_type_id => process_id).save
    				end
	      	end
	    end

	    if prints
	      	prints.each do |print_id|
    				unless item.item_prints.find_by_print_id(print_id)
    					  item.item_prints.new(:print_id => print_id).save
    				end
	      	end
	    end

	    if specs
	      	specs.each do |specification_id|
    				unless item.item_specifications.find_by_specification_id(specification_id)
    					  item.item_specifications.new(:specification_id => specification_id).save
    				end
	      	end
	    end

	    if materials
	      	materials.each do |material_id|
    				unless item.item_materials.find_by_material_id(material_id)
					      item.item_materials.new(:material_id => material_id).save
    				end
	      	end
	    end
  	end
end
