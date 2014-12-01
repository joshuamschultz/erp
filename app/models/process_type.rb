class ProcessType < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :process_active, :process_created_id, :process_description, 
  :process_notes, :process_short_name, :process_updated_id, :attachment_attributes

  after_initialize :default_values

  def default_values
    self.process_active = true if self.process_active.nil?
  end

  # (validates_uniqueness_of :process_short_name if validates_length_of :process_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :process_short_name

  # validates_length_of :process_description, :maximum => 50

  has_many :organization_processes, :dependent => :destroy
  has_many :organizations, :through => :organization_processes
  has_many :item_processes, :dependent => :destroy
  has_many :item_revisions, :through => :item_processes
  has_many :specifications, :through => :process_type_specifications

  has_one :attachment, :as => :attachable, :dependent => :destroy

  default_scope :order => 'process_short_name ASC'
  accepts_nested_attributes_for :attachment, :allow_destroy => true



  def self.process_item_associations(process_type, params)
        if process_type

          specs = params[:specs] || []
         # process_type.process_type_specifications.where(:specification_id != specs).destroy_all
          if specs
              specs.each do |specification_id|
                unless process_type.process_type_specifications.find_by_specification_id(specification_id)
                    process_type.process_type_specifications.new(:specification_id => specification_id).save
                end
              end
          end
        end
  end

  def redirect_path
      process_type_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.process_short_name = self.attachment.attachment_name
  end
  def self.item_process_type(item)
      process_types=[]
     Item.find(item).item_revisions.each do |item_revision|
        if item_revision.present?
          item_revision.item_processes.each do |process|
            if process.present?
              process_types<<process.process_type
            end
          end
        end
      end
      return process_types
  end
  
end
