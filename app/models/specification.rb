# == Schema Information
#
# Table name: specifications
#
#  id                        :integer          not null, primary key
#  specification_active      :boolean
#  specification_identifier  :string(255)
#  specification_description :string(255)
#  specification_notes       :text(65535)
#  created_at                :datetime
#  updated_at                :datetime
#

class Specification < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  after_initialize :default_values

  def default_values
    self.specification_active = true if self.specification_active.nil?
  end

  

  # (validates_uniqueness_of :specification_identifier if validates_length_of :specification_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :specification_identifier

  # validates_length_of :specification_description, :maximum => 50

  has_many :item_specifications, :dependent => :destroy
  has_many :item_revisions, :through => :item_specifications

  has_many :process_type_specifications, :dependent => :destroy
  has_many :process_types, :through => :process_type_specifications

  has_one :attachment, :as => :attachable, :dependent => :destroy


  has_one :notification, :as => :notable,  dependent: :destroy

  accepts_nested_attributes_for :notification, :allow_destroy => true

  
  
  default_scope { order('specification_identifier ASC') } 

  accepts_nested_attributes_for :attachment, :allow_destroy => true

  def redirect_path
      specification_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.specification_identifier = self.attachment.attachment_name
  end
  def self.item_specification(item)
    specifications=[]
    Item.find(item).item_revisions.each do |item_revision|
      if item_revision.present?
        item_revision.item_specifications.each do |process|
          if process.present?
            specifications<<process.specification
          end
        end
      end
    end
    process_types =ProcessType.item_process_type(item)
    process_specifications = ProcessType.process_type_specifications(process_types)
    process_specifications.each do |process_spec|
      specifications << process_spec
    end

    specifications.uniq
  end     
end
