class QualityAction < ActiveRecord::Base
	belongs_to :item
	belongs_to :item_revision
	belongs_to :item_alt_name
	belongs_to :po_header
	belongs_to :cause_analysis
	attr_accessible :definition_of_issue, :due_date, :ic_action_id, :organization_quality_type_id, :quality_action_active, 
				:quality_action_no, :quality_action_status, :quantity, :required_action, :short_term_fix, :submit_time,
				:item_id, :item_alt_id, :item_revision_id, :cause_analysis_id, :po_header_id, :item_alt_name_id, :created_user_id

	has_many :quality_actions_users, :dependent => :destroy
	has_many :users, :through => :quality_actions_users

	before_save :before_save_process
	before_validation :before_save_validate

	def before_save_validate
		self.quality_action_no = CheckCode.get_next_quality_action_number
	end

	def before_save_process
		self.item = self.item_alt_name.item
    	self.item_revision = self.item_alt_name.item.current_revision
	end

	validates_presence_of :quality_action_no

	validates_presence_of :item_alt_name_id, :item_alt_name, :quantity, :created_user_id


	belongs_to :ic_action, :class_name => "MasterType", :foreign_key => "ic_action_id",
	    :conditions => ['type_category = ?', 'icp_quallity_action']

	belongs_to :organization_quality_type, :class_name => "MasterType", :foreign_key => "organization_quality_type_id",
        :conditions => ['type_category = ?', 'organization_type_q_a']

    belongs_to :created_user, :foreign_key => "created_user_id", :class_name => "User"


    scope :status_based_quality, lambda{|status| where(:quality_action_status => status) }

    def set_user(params)
    	users = params[:users] || []
        self.quality_actions_users.where(:user_id != users).destroy_all

        if users
            users.each do |user_id|
              unless self.quality_actions_users.find_by_user_id(user_id)
                self.quality_actions_users.create(:user_id =>user_id)                        
              end
            end
        end    	
    end

end
