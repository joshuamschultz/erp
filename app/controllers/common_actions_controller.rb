class CommonActionsController < ApplicationController
  def get_info
  		# result = []
  		case(params[:mode])
  			when "po_line_revisions"
  				po_line = PoLine.find(params[:id])
          result = {}
  				result[:aaData] = po_line.present? ? po_line.item.item_revisions : []
          result[:default] = (po_line.present? && po_line.item.current_revision.present?) ? po_line.item.current_revision.id : 0

  			when "po_header_items"
  				po_header = PoHeader.find(params[:id])
  				result = po_header.present? ? po_header.po_lines : []
  				result = result.each {|line| line[:po_line_item_name] = line.po_line_item_name }

        when "lot_item_material_elements"
          lot = QualityLot.find(params[:id])
          result = lot.lot_item_material_elements
          result = result.each {|line| line[:element_with_symbol] = line.element_with_symbol }

        when "lot_item_dimensions"
          lot = QualityLot.find(params[:id])
          result = lot.lot_item_dimensions

        when "material_element_info"
          result = MaterialElement.find(params[:id])

        when "organization_payables"
          organization = Organization.find(params[:id])
          result = organization.present? ? organization.payables.where(:payable_status => "open") : []

        when "organization_receivables"
          organization = Organization.find(params[:id])
          result = organization.present? ? organization.receivables.where(:receivable_status => "open") : []

        when "payment_payable_info"
          payable = Payable.find(params[:id])
          payable["payable_balance"] = payable.payable_current_balance
          result = payable

        when "receipt_receivable_info"
          receivable = Receivable.find(params[:id])
          receivable["receivable_balance"] = receivable.receivable_current_balance
          result = receivable

        when "organization_open_pos"
          organization = Organization.find(params[:id])
          result = organization.present? ? organization.purchase_orders.where(:po_status => "open") : []

  		end
  		render json: {:aaData => result}
  end
end
