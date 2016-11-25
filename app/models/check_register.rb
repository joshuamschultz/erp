class CheckRegister < ActiveRecord::Base

  
  
  belongs_to :payment 
  belongs_to :receipt  
  def check_register_params
      params.require(:check_register).permit(:amount, :balance, :check_code, :deposit, :organization_id, :rec, :transaction_date, :payment_id, :receipt_id)
  end
  
end
