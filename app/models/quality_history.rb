class QualityHistory < ActiveRecord::Base
  attr_accessible :quality_lot_id, :quality_status, :user_id
  belongs_to :quality_lot
  def self.lot_all_status(lot_id)
  	quality_lot = QualityLot.find(lot_id)
  	if quality_lot.present?
  		temp1 = temp2 = temp3 = source = ''
  		quality_lot.quality_histories.order("created_at DESC").each do |quality_history|
  			temp = '<tr><td>'+quality_history.quality_status+'</td><td>'+User.find(quality_history.user_id).name+'</td><td>'+quality_history.created_at.strftime('%a %b %d %H:%M:%S %Z %Y')+'</td></tr>'
  		source += temp
  		end 
		temp3 = '</tbody></table></form></div>'
		source = source+temp3 
  	end          
  end
end
