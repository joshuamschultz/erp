# == Schema Information
#
# Table name: checklists
#
#  id                  :integer          not null, primary key
#  quality_lot_id      :integer
#  checklist_status    :string(255)
#  po_line_id          :integer
#  customer_quality_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Checklist < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :po_line
  belongs_to :customer_quality   

  has_many :check_list_lines, :dependent => :destroy

  validate :quality_lot, :po_line, :customer_quality
  validates_uniqueness_of :quality_lot_id
  def checklist_params
      params.require(:checklist).permit(:checklist_status, :quality_lot_id, :po_line_id, :customer_quality_id)
  end      
end
