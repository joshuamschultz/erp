class GlAccount < ActiveRecord::Base
  attr_accessible :gl_active, :gl_description, :gl_title, :gl_mode, :gl_identifier, :gl_category, :gl_type_id

  belongs_to :gl_type, :class_name => "MasterType", :foreign_key => "gl_type_id", 
  	:conditions => ['type_category = ?', 'gl_type']

  after_initialize :default_values

  def default_values
    self.gl_active = true if self.gl_active.nil?
  end

  (validates_uniqueness_of :gl_title if validates_length_of :gl_title, :minimum => 2, :maximum => 20) if validates_presence_of :gl_title
  validates_presence_of :gl_type, :gl_mode, :gl_category
end