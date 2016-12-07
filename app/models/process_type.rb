class ProcessType < ActiveRecord::Base
  include Rails.application.routes.url_helpers


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

  has_many :process_type_specifications, :dependent => :destroy
  has_many :specifications, :through => :process_type_specifications

  has_one :attachment, :as => :attachable, :dependent => :destroy


  default_scope { order('process_short_name ASC') }

  accepts_nested_attributes_for :attachment, :allow_destroy => true


  has_one :notification, :as => :notable,  dependent: :destroy

  accepts_nested_attributes_for :notification, :allow_destroy => true



  def self.process_item_associations(process_type, params)
        if process_type
          p params[:specs]
          specs = params[:specs] || []
          process_type.process_type_specifications.destroy_all
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
      process_types = process_types.uniq
      return process_types
  end

  def self.process_type_specifications(process_types)
    specifications = []
    process_types.each do |process_type|
      if process_type.present?
         process_type.specifications.each do |pro_spec|
          specifications<<pro_spec
        end
      end
    end
    specifications.uniq
  end

end
