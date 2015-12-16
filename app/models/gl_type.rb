class GlType < ActiveRecord::Base
  attr_accessible :gl_active, :gl_description, :gl_identifier, :gl_name, :gl_report, :gl_side

  after_initialize :default_values

  def default_values
    self.gl_active = true if self.attributes.has_key?("gl_active") && self.gl_active.nil?
  end

  has_many :gl_accounts, dependent: :destroy
  default_scope :order => 'gl_report DESC'

  validates_presence_of :gl_name

  def default_values
    self.gl_active = true if self.gl_active.nil?
  end
end
