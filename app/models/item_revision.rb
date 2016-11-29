class ItemRevision < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :item
  belongs_to :owner
  belongs_to :print
  belongs_to :material
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :organization, -> {where organization_type_id: MasterType.find_by_type_value("vendor").id}

  attr_accessible :item_cost, :item_description, :item_name, :item_notes, :item_revision_created_id, 
  :item_revision_date, :item_revision_name, :item_revision_updated_id, :item_tooling, :item_id, :owner_id,
  :organization_id, :vendor_quality_id, :customer_quality_id, :print_id, :material_id, :latest_revision,
  :item_revision_complete, :item_sell, :item_revision_weekly_usage, :item_revision_lead_time
  before_save :process_before_save


  def process_before_save
      self.item_revision_name ||= "0"

      unless CommonActions.nil_or_blank(self.item_name) || 
        CommonActions.nil_or_blank(self.item_description) || 
        CommonActions.nil_or_blank(self.item_revision_name) || 
        CommonActions.nil_or_blank(self.item_cost) || 
        CommonActions.nil_or_blank(self.item_tooling) || 
        self.owner.nil? || self.print.nil? || self.material.nil?
          self.item_revision_complete = true
      else
          self.item_revision_complete = false
      end

      return true
  end

  validates_presence_of :owner, :item_revision_date
  validates_length_of :item_name, :minimum => 2, :maximum => 50 if validates_presence_of :item_name
  validates_length_of :item_revision_name, :maximum => 50 if validates_presence_of :item_revision_name
  validates_numericality_of :item_cost if validates_presence_of :item_cost
  validates_numericality_of :item_tooling if validates_presence_of :item_tooling

  validates :item_revision_name, uniqueness: {scope: :item_id}
  
  after_save :update_recent_revision

  def update_recent_revision    
      ItemRevision.skip_callback("save", :after, :update_recent_revision)
      recent_revison = self.item.item_revisions.order("item_revision_date desc").first
      recent_revison.update_attributes(:latest_revision => true)
      self.item.item_revisions.where("id != ?", recent_revison.id).update_all(:latest_revision => false)
      ItemRevision.set_callback("save", :after, :update_recent_revision)
  end

  # has_one :item_print, :dependent => :destroy
  # has_one :print, :through => :item_print 

  # has_many :item_materials, :dependent => :destroy
  # has_many :materials, :through => :item_materials

  has_many :item_processes, :dependent => :destroy
  has_many :process_types, :through => :item_processes
  has_many :item_specifications, :dependent => :destroy
  has_many :specifications, :through => :item_specifications 
  has_many :item_selected_names, :dependent => :destroy
  has_many :item_alt_names, :through => :item_selected_names
  # has_many :item_part_dimensions, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :po_lines, :dependent => :destroy
  has_many :so_lines, :dependent => :destroy
  has_many :quality_lots, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy
  has_many :quality_actions, :dependent => :destroy

  has_many :item_revision_item_part_dimensions, dependent: :destroy
  has_many :item_part_dimensions, through: :item_revision_item_part_dimensions

  def self.process_item_associations(item_revision, params)
        if item_revision
          # alt_names = params[:alt_names].split(",") || []
          # alt_name_ids = ItemAltName.where(:item_alt_identifier => alt_names)
          # item_revision.item_selected_names.where(:item_alt_name_id != alt_name_ids).destroy_all

          processes = params[:processes] || []
          item_revision.item_processes.where(:process_type_id != processes).destroy_all

          # prints = params[:prints] || []
          # item_revision.item_prints.where(:print_id != prints).destroy_all

          specs = params[:specs] || []
          item_revision.item_specifications.where(:specification_id != specs).destroy_all

          # materials = params[:materials] || []
          # item_revision.item_materials.where(:material_id != materials).destroy_all

           # if alt_names
           #      alt_names.each do |alt_name|
           #        item_alt_name = ItemAltName.find_by_item_alt_identifier(alt_name)

           #        unless item_alt_name            
           #            item_alt_name = ItemAltName.new(:item_alt_identifier => alt_name)
           #            item_alt_name.save
           #        end

           #        unless item_alt_name.nil? && item_revision.item_selected_names.find_by_item_alt_name_id(item_alt_name.id)
           #            item_revision.item_selected_names.new(:item_alt_name_id => item_alt_name.id).save
           #        end
           #      end
           # end

          if processes
              processes.each do |process_id|
                unless item_revision.item_processes.find_by_process_type_id(process_id)
                    item_revision.item_processes.new(:process_type_id => process_id).save
                end
              end
          end

          # if prints
          #     prints.each do |print_id|
          #       unless item_revision.item_prints.find_by_print_id(print_id)
          #           item_revision.item_prints.new(:print_id => print_id).save
          #       end
          #     end
          # end

          if specs
              specs.each do |specification_id|
                unless item_revision.item_specifications.find_by_specification_id(specification_id)
                    item_revision.item_specifications.new(:specification_id => specification_id).save
                end
              end
          end

          # if materials
          #     materials.each do |material_id|
          #       unless item_revision.item_materials.find_by_material_id(material_id)
          #          item_revision.item_materials.new(:material_id => material_id).save
          #       end
          #     end
          # end

          item_part_dimension_ids = item_revision.item.item_part_dimensions.collect(&:id)

            if item_part_dimension_ids.present?
              item_part_dimension_ids.each do |item_part_dimension_id|
                unless item_revision.item_revision_item_part_dimensions.find_by_item_part_dimension_id(item_part_dimension_id)
                   item_revision_dimension = item_revision.item_revision_item_part_dimensions.create(:item_part_dimension_id => item_part_dimension_id)
                   item_revision_dimension.save
                end
              end
            end
        end
  end

    def redirect_path
        item_path(self.item, revision_id: self.id)
    end

    def purchase_orders
        PoHeader.joins(:po_lines).where("po_lines.item_revision_id = ?", self.id)
    end

    def sales_orders
        SoHeader.joins(:so_lines).where("so_lines.item_revision_id = ?", self.id)
    end 

    
    scope :recent_revisions, -> { joins(:item).where('item_revisions.latest_revision = ?', true) }

end
