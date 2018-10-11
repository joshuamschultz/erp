# == Schema Information
#
# Table name: receivable_lines
#
#  id                          :integer          not null, primary key
#  receivable_id               :integer
#  receivable_line_identifier  :string(255)
#  receivable_line_description :string(255)
#  receivable_line_cost        :decimal(25, 10)  default(0.0)
#  receivable_line_notes       :text(65535)
#  receivable_line_status      :string(255)
#  receivable_line_active      :boolean
#  receivable_line_created_id  :integer
#  receivable_line_updated_id  :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#

class ReceivableLine < ActiveRecord::Base
	belongs_to :receivable
	
	attr_accessor :receivable_line_active, :receivable_line_cost, :receivable_line_created_id, 
	:receivable_line_description, :receivable_line_identifier, :receivable_line_notes, :receivable_line_status, 
	:receivable_line_updated_id, :receivable_id

	validates_presence_of :receivable_line_description, :receivable_line_cost

	validates_numericality_of :receivable_line_cost

	after_save :update_receivable_total
	after_destroy :update_receivable_total

	def update_receivable_total
		receivable_total = self.receivable.process_receivable_total		
		# self.update_gl_account
    end
    # def update_gl_account
    # 	CommonActions.update_gl_accounts('INVENTORY', 'decrement',self.receivable_line_cost)
    # 	CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'increment',self.receivable_line_cost )	
    # end
    
   
end
