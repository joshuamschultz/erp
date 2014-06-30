class CommonActionsController < ApplicationController
    def get_info
      # result = []
        case(params[:mode])
            when "po_line_revisions"
              po_line = PoLine.find(params[:id])
              result = {}
              result[:aaData] = po_line.present? ? po_line.item.item_revisions : []
              result[:default] = (po_line.present? && po_line.item.current_revision.present?) ? po_line.item.current_revision.id : 0
              latest_received = po_line.po_shipments.order(:created_at).last
              result[:latest_received_count] = latest_received.present? ? latest_received.po_shipped_count : ""

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

            when "create_payable"
              # puts params[:shipments].to_s
              # PoHeader.process_payable_po_lines(params)

            when "send_quotes_mail"
              p params[:organizations].to_yaml
              # quote = Quote.find(params[:quote_id])
              # quote.quote_vendors.each do |quote_vendor|
              #   if quote_vendor.organization.contact_type.type_name == "Email"
              #     UserMailer.send_quote(quote, quote_vendor).deliver
              #   end
              # end
              result = "success"
            when "get_item_description"
              if params[:item_id].present?
                description = ItemAltName.find(params[:item_id]).item.current_revision.item_description
                result = description if description
                result = "fail" if !description
              else
                result = "fail"
              end
            when "get_quote_info"
                if params[:quote_id].present?
                  quote = Quote.find(params[:quote_id])
                  result = CustomerQuoteLine.get_line_items(quote)
                else
                  result = "fail"
                end
            when "get_item_info"
              if params[:quote_id] && params[:item_id].present?
                result = Quote.get_item_prices(params[:quote_id], params[:item_id])
              else
                result = "fail"
              end
            when "send_customer_quotes_mail"
              if params[:customer_quote_id].present?
                UserMailer.send_customer_quote(params[:customer_quote_id], params[:contact])
              end
            when "set_quote_status"
              if params[:quote_id].present? && params[:status_id].present?
                quote = Quote.find(params[:quote_id])
                quote.quote_status = params[:status_id]
                if quote.save
                  result = "success"
                else
                  result = "fail"
                end
              end
            when "get_vendor_po"
              if params[:organization_id].present? && params[:alt_name_id]
                item_id = ItemAltName.find(params[:alt_name_id]).item.id
                # organization = Organization.find(params[:organization_id])
                result = PoHeader.joins(:po_lines).select("po_headers.po_identifier").where("po_headers.organization_id = ? AND po_lines.item_id = ?", params[:organization_id], item_id).order("po_headers.created_at DESC")
              end
            when "set_customer_quote_status"
              if params[:customer_quote_id].present? && params[:status_id].present?
                  customer_quote = CustomerQuote.find(params[:customer_quote_id])
                  customer_quote.customer_quote_status = params[:status_id]
                  if customer_quote.save
                      result = "success"
                  else
                      result = "fail"
                  end
              end  
            when "process_reconcile"
              if params[:reconcile_ids].present?
                Reconcile.where(id: params[:reconcile_ids]).each do |obj|
                   obj.update_attributes(:tag => "reconciled")
                end 
                result ="Success"
              end
            when "set_checklist"
              if params[:id].present? && params[:value].present?
                checklist = CheckListLine.find(params[:id])
                if checklist.update_attributes(:check_list_status => params[:value])
                  result ="Success"
                end
              else
                result = "false"
              end
            when "set_psw_value"              
              if params[:field].present? && params[:psw_id].present? && params[:value].present?         
                Ppap.set_levels(params[:field],params[:psw_id],params[:value], params[:type])                   
                result ="Success"
              else
                result = "fail"
              end
            when "set_tag"
              if params[:id].present? && params[:value].present?
                organization = Organization.find(params[:id])
                tags = params[:value]
                tags = tags.collect(&:strip).compact
                tags = tags.reject(&:empty?)
                Comment.process_comments(current_user, organization, tags, "tag")
                result ="Success"   
              end
            when "set_process"
              if params[:id].present? && params[:value].present?
                organization = Organization.find(params[:id])
                OrganizationProcess.process_organization_processes(current_user, organization, params[:value])
                result ="Success"   
              end
                            
        end
         render json: {:aaData => result}
    end
end
