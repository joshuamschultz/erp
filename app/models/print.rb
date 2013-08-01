class Print < ActiveRecord::Base
  attr_accessible :print_active, :print_created_id, :print_description, :print_identifier, 
  :print_notes, :print_updated_id
  
  has_many :item_prints, :dependent => :destroy
end
