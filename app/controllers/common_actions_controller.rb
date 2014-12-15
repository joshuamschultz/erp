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

            when "get_quality_lots_inventory"
              if params[:id].present?
                item_alt_name = ItemAltName.find(params[:id])
                result = item_alt_name.present? ? item_alt_name.item.quality_lots : []
                result = result.each {|line| line[:lot_control_no] = line.lot_control_no }
              end


            when "org_contact_mail"
              if params[:organization_id].present?
                organization = Organization.find(params[:organization_id])
                result = organization.present? ? organization.contacts : []
                result = result.each {|line| line[:contact_email] = line.contact_email }
              end


            when "get_quality_lot_current_quantity"
              if params[:id].present?
                quality_lot = QualityLot.find(params[:id])
                result = quality_lot
              end


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

              if params[:contact_id].present? && params[:quote_id].present?
                quote = Quote.find(params[:quote_id])
                quote.quote_vendors.each do |quote_vendor|
                  if quote_vendor.organization.contact_type.type_name == "Email"
                    UserMailer.send_quote(quote, quote_vendor,params[:contact_id]).deliver
                  end
                end
                result = "success"
               else
                result = "fail"
               end
              
            when "send_po_order_mail"
              val =  params[:organizations]
              @po_header = PoHeader.find(params[:po_header_id])
              @contact = Contact.find(val["0"]["value"].to_i)
              @vendor_email = @contact.contact_email
              UserMailer.purchase_order_mail(@po_header, @vendor_email).deliver
              result = "success"
              
            when "send_invoice"
              @receivable = Receivable.find(params[:receivable_id])
              if @receivable.so_header.present?
                if @receivable.so_header.bill_to_address.present?
                  @customer_eamil = @receivable.so_header.bill_to_address.contact_email
                  UserMailer.customer_billing_mail(@receivable, @customer_eamil).deliver
                end
                result = "success" 
              else
                result = 'fail'
              end
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
              if params[:customer_quote_id].present? && params[:contact].present?
                UserMailer.send_customer_quote(params[:customer_quote_id], params[:contact])
                result = "success"
              else
                result = "fail"
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
              if params[:reconcile_ids].present? && params[:balance].present?
                Reconcile.where(id: params[:reconcile_ids]).each do |obj|
                  obj.update_attributes(:tag => "reconciled")
                  if obj.payment_id.present?
                    check_register = CheckRegister.find_by_payment_id(obj.payment_id)
                    check_register.update_attributes(:rec => true) if  check_register
                    credit_register = CreditRegister.find_by_payment_id(obj.payment_id)
                    credit_register.update_attributes(:rec => true) if  credit_register
                  elsif obj.receipt_id.present?
                    check_register = CheckRegister.find_by_receipt_id(obj.receipt_id)
                    check_register.update_attributes(:rec => true) if  check_register                      
                  end  

                end  
                reconciled = Reconciled.first            
                reconciled.update_attributes(balance: params[:balance])
                result ="Success"
              end
             when "add_or_update_expense" 
              if  params[:payable_id].present? && params[:expense_amt].present? 
                payable = Payable.find(params[:payable_id])             
                if payable.update_attributes(:payable_total => params[:expense_amt] )                  
                  result ="Success"
                end
              end 
            when "add_or_update_freight" 
              if  params[:payable_id].present? && params[:freight_amt].present? 
                payable = Payable.find(params[:payable_id])             
                if payable.update_attributes(:payable_freight => params[:freight_amt] )
                  payable.update_payable_total
                  result ="Success"
                end
              end
             when "add_or_update_receivable_freight" 
              if  params[:receivable_id].present? && params[:freight_amt].present? 
                receivable = Receivable.find(params[:receivable_id])             
                if receivable.update_attributes(:receivable_freight => params[:freight_amt] )
                  receivable.update_receivable_total
                  result ="Success"
                end
              end
            when "add_or_update_discount"
              if  params[:payable_id].present? && params[:discount].present? 
                payable = Payable.find(params[:payable_id])             
                if payable.update_attributes(:payable_discount => params[:discount] )
                  payable.update_payable_total
                  result ="Success"
                end
              end
            when "add_or_update_receivable_discount"
              if  params[:receivable_id].present? && params[:discount].present? 
                receivable = Receivable.find(params[:receivable_id])             
                if receivable.update_attributes(:receivable_discount => params[:discount] )
                  receivable.update_receivable_total
                  result ="Success"
                end
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
            when "get_quality_lots"
              if params[:id].present?
                quality_lots = SoLine.find(params[:id]).item.quality_lots.map { |x| (x && x.quantity_on_hand && x.quantity_on_hand > 0) ? [x.id,x.lot_control_no] : [] } 
                result = quality_lots
              end



            when "get_quality_lots_po"
              if params[:id].present?
                quality_lots = PoLine.find(params[:id]).item.quality_lots.map { |x| [x.id,x.lot_control_no] }
                result = quality_lots
              end
            when "get_gl_account_title" 
              gl_account_titles = Hash.new 
              @gl_account = GlAccount.where(:gl_account_identifier =>   "11050").first              
              gl_account_titles["11050"] = @gl_account.gl_account_title
              @gl_account = GlAccount.where(:gl_account_identifier =>   "51010020").first
              gl_account_titles["51010020"] = @gl_account["gl_account_title"]
              @gl_account = GlAccount.where(:gl_account_identifier =>   "51020020").first
              gl_account_titles["51020020"] = @gl_account["gl_account_title"]
              @gl_account = GlAccount.where(:gl_account_identifier =>   "71107").first
              gl_account_titles["71107"] = @gl_account["gl_account_title"]
              result = gl_account_titles 

            when "after_print_checks"
              if params[:id].present? 
                check_entry = CheckEntry.find(params[:id]) 
                check_entry.update_attributes(:status => "Printed", :check_active => 0)
                payment = Payment.find_by_check_entry_id(params[:id])
                payment.update_transactions
                @reconcile = Reconcile.where(:payment_id => payment.id).first
                if @reconcile.nil?                                  
                  Reconcile.create(tag: "not reconciled",reconcile_type: "check", payment_id: payment.id, printing_screen_id: params[:id])                                             
                end 
                check_register = CheckRegister.where(payment_id: payment.id).first
                unless  check_register.present?                    
                    balance = 0 
                    amount =  payment.payment_check_amount * -1 
                    gl_account = GlAccount.where('gl_account_identifier' => '11012' ).first                     
                    if  CheckRegister.exists? 
                      check_register = CheckRegister.last                                       
                      balance += amount + check_register.balance
                    else
                      balance += gl_account.gl_account_amount                         
                    end                   
                                                     
                    CheckRegister.create(transaction_date: Date.today.to_s, check_code: payment.payment_check_code, organization_id: payment.organization_id, amount: amount, rec: false, payment_id: payment.id, balance: balance)
                end          
                result = "success"
              end 
            when "after_print_deposits"
              if params[:id].present? 
                deposit_check = DepositCheck.find(params[:id]) 
                deposit_check.update_attributes(:status => "Printed", :active => 0)
                receipt = Receipt.find_by_deposit_check_id(params[:id])
                receipt.update_transactions
                @reconcile = Reconcile.where(:receipt_id => receipt.id).first
                if @reconcile.nil?                                  
                  Reconcile.create(tag: "not reconciled",reconcile_type: deposit_check.receipt_type, receipt_id: receipt.id, deposit_check_id: params[:id])                                             
                end  
                check_register = CheckRegister.where(receipt_id: receipt.id).first
                unless  check_register.present? 
                    if deposit_check.receipt_type != 'credit'
                      balance = 0                  
                      gl_account = GlAccount.where('gl_account_identifier' => '11012' ).first                     
                      if  CheckRegister.exists?                 
                        check_register = CheckRegister.last                          
                        balance +=  receipt.receipt_check_amount + check_register.balance
                      else
                        balance += gl_account.gl_account_amount                           
                      end            

                      CheckRegister.create(transaction_date: Date.today.to_s, check_code: receipt.receipt_check_code, organization_id: receipt.organization_id, deposit: receipt.receipt_check_amount, rec: false, receipt_id: receipt.id, balance: balance)
                    end  
                end          
                result = "success"
              end                    
        end
         render json: {:aaData => result}
    end
end
