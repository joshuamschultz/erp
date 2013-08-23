class SoHeader < ActiveRecord::Base
  has_many :so_lines
  belongs_to :organization
  attr_accessible :so_bill_to_id, :so_cofc, :so_comments, :so_identifier, :so_notes, :so_ship_to_id, :so_squality, :so_status, :so_total, :organization_id
  validates_presence_of :organization
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
