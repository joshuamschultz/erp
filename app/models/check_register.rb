# == Schema Information
#
# Table name: check_registers
#
#  id               :integer          not null, primary key
#  transaction_date :date
#  check_code       :string(255)
#  organization_id  :integer
#  amount           :decimal(10, )
#  deposit          :decimal(10, )
#  balance          :decimal(10, )
#  rec              :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  payment_id       :integer
#  receipt_id       :integer
#

class CheckRegister < ActiveRecord::Base

  
  
  belongs_to :payment 
  belongs_to :receipt  
  def check_register_params
      params.require(:check_register).permit(:amount, :balance, :check_code, :deposit, :organization_id, :rec, :transaction_date, :payment_id, :receipt_id)
  end
  
end
