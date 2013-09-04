class CommonActionsController < ApplicationController
  def get_info
  		result = []
  		case(params[:mode])
  			when "po_line_revisions"
  				po_line = PoLine.find(params[:id])
  				result = po_line.present? ? po_line.item.item_revisions : []
  			when "po_header_items"
  				po_header = PoHeader.find(params[:id])
  				result = po_header.present? ? po_header.po_lines : []
  				result = result.each {|po_line| po_line[:po_line_item_name] = po_line.po_line_item_name }
  		end
  		render json: {:aaData => result}
  end
end
