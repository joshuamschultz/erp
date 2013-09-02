class CommonActionsController < ApplicationController
  def get_info
  		result = []
  		case(params[:mode])
  			when "po_line_revisions"
  				po_line = PoLine.find(params[:id])
  				result = po_line.present? ? po_line.item.item_revisions : []
  		end
  		render json: {:aaData => result}
  end
end
