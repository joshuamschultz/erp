# == Schema Information
#
# Table name: item_revisions
#
#  id                       :integer          not null, primary key
#  item_revision_name       :string(255)      default("0")
#  item_revision_date       :date
#  item_id                  :integer
#  owner_id                 :integer
#  organization_id          :integer
#  vendor_quality_id        :integer
#  customer_quality_id      :integer
#  item_name                :string(255)
#  item_description         :text(65535)
#  item_notes               :text(65535)
#  item_tooling             :decimal(25, 10)  default(0.0)
#  item_cost                :decimal(25, 10)  default(0.0)
#  item_revision_created_id :integer
#  item_revision_updated_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#  print_id                 :integer
#  material_id              :integer
#  latest_revision          :boolean
#  item_revision_complete   :boolean          default(FALSE)
#  item_sell                :decimal(15, 10)
#  lot_count                :integer          default(0)
#

class ItemRevision < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :item
  belongs_to :print, optional: true
  belongs_to :material, optional: true
  belongs_to :vendor_quality, optional: true
  belongs_to :customer_quality, optional: true
  belongs_to :organization, -> {where organization_type_id: MasterType.find_by_type_value("vendor").id}, optional: true
  # has_one :item_print, :dependent => :destroy
  # has_one :print, :through => :item_print

  has_many :item_processes, :dependent => :destroy
  has_many :process_types, :through => :item_processes
  has_many :item_specifications, :dependent => :destroy
  has_many :specifications, :through => :item_specifications
  has_many :item_selected_names, :dependent => :destroy
  has_many :item_alt_names, through: :item_selected_names
  has_many :item_part_dimensions, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :po_lines, :dependent => :destroy
  has_many :so_lines, :dependent => :destroy
  has_many :quality_lots, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy
  has_many :quality_actions, :dependent => :destroy
  # has_many :item_materials, :dependent => :destroy
  # has_many :materials, :through => :item_materials
  # has_many :item_revision_item_part_dimensions, dependent: :destroy
  # has_many :item_part_dimensions, through: :item_revision_item_part_dimensions

  validates_length_of :item_name, :minimum => 2, :maximum => 50 if validates_presence_of :item_name
  validates_length_of :item_revision_name, :maximum => 50 if validates_presence_of :item_revision_name
  validates_numericality_of :item_tooling if validates_presence_of :item_tooling
  validates :item_revision_name, uniqueness: {scope: :item_id}
  #validates_numericality_of :item_cost if validates_presence_of :item_cost

  after_save :update_recent_revision

  scope :recent_revisions, -> { joins(:item).where('item_revisions.latest_revision = ?', true) }

  def process_before_save
      self.item_revision_name ||= "0"

      unless CommonActions.nil_or_blank(self.item_name) ||
        CommonActions.nil_or_blank(self.item_description) ||
        CommonActions.nil_or_blank(self.item_revision_name) ||
        CommonActions.nil_or_blank(self.item_cost) ||
        CommonActions.nil_or_blank(self.item_tooling) ||
        self.print.nil? || self.material.nil?
          self.item_revision_complete = true
      else
          self.item_revision_complete = false
      end

      return true
  end

  def update_recent_revision
      ItemRevision.skip_callback("save", :after, :update_recent_revision, raise: false)
      recent_revison = self.item.current_revision
      recent_revison.update_attributes(:latest_revision => true)
      self.item.item_revisions.where("id != ?", recent_revison.id).update_all(:latest_revision => false)
      ItemRevision.set_callback("save", :after, :update_recent_revision)
  end


  def self.process_item_associations(item_revision, params)
        if item_revision
          # alt_names = params[:alt_names].split(",") || []
          # alt_name_ids = ItemAltName.where(:item_alt_identifier => alt_names)
          # item_revision.item_selected_names.where(:item_alt_name_id != alt_name_ids).destroy_all

          processes = params[:processes] || []
          item_revision.item_processes.where.not(:process_type_id => processes).destroy_all

          # prints = params[:prints] || []
          # item_revision.item_prints.where(:print_id != prints).destroy_all

          specs = params[:specs] || []
          item_revision.item_specifications.where.not(:specification_id => specs).destroy_all

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
                    process = ProcessType.find process_id
                    item_revision.specifications << process.specifications
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

          # NOT SURE WHEN THIS WILL HAPPEN OR IS IT EVEN REQUIRED
          # Item_part_dimension belongs to item_revision -> every item_part_dimension has item_revision
          # All Items have item_revisions
          # Items (1) -> (M) item_revisions (1) -> (M) item_part_dimensions
          # if item_part_dimension_ids.present?
          #   item_part_dimension_ids.each do |item_part_dimension_id|
          #     unless item_revision.item_part_dimensions.where(id: item_part_dimension_id).exists?
          #        item_revision_dimension = item_revision.create(:item_part_dimension_id => item_part_dimension_id)
          #        item_revision_dimension.save
          #     end
          #   end
          # end
        end
  end

    def self.item_sync_checkbox(itemRevision)
     "<input type='checkbox' class='item_sync' name='item_revision_#{itemRevision.id}' id='item_revision_#{itemRevision.id}' value='#{itemRevision.id}'>  "
    end
    def redirect_path
        item_path(self.item, revision_id: self.id, item_alt_name_id: self.item_alt_names.last)
    end

    def purchase_orders
        PoHeader.joins(:po_lines).where("po_lines.item_revision_id = ?", self.id)
    end

    def sales_orders
        SoHeader.joins(:so_lines).where("so_lines.item_revision_id = ?", self.id)
    end

end
