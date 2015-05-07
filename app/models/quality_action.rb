class QualityAction < ActiveRecord::Base
    include Rails.application.routes.url_helpers
    belongs_to :item
    belongs_to :item_revision
    belongs_to :item_alt_name
    belongs_to :po_header
    belongs_to :cause_analysis
    belongs_to :quality_lot
    attr_accessible :definition_of_issue, :due_date, :ic_action_id, :organization_quality_type_id, :quality_action_active, 
                :quality_action_no, :quality_action_status, :quantity, :required_action, :short_term_fix, :submit_time,
                :item_id, :item_alt_id, :item_revision_id, :cause_analysis_id, :po_header_id, :item_alt_name_id, 
                :created_user_id, :root_cause, :quality_lot_id, :notification_attributes

    has_many :quality_actions_users, :dependent => :destroy
    has_many :users, :through => :quality_actions_users
    has_many :customer_feedbacks, :dependent => :destroy
    has_many :attachments, :as => :attachable, :dependent => :destroy

    has_many :notification, :as => :notable

    accepts_nested_attributes_for :notification, :allow_destroy => true

    before_save :before_save_process
    before_validation :before_save_validate
    # before_create :process_after_creates
    def before_save_validate
        unless self.persisted?
            self.quality_action_no = CheckCode.get_next_quality_action_number
        end       
    end

    def before_save_process
        if self.item_alt_name.present?
            self.item = self.item_alt_name.item
            self.item_revision = self.item_alt_name.item.current_revision
        end
    end

    validates_presence_of :quality_action_no, :ic_action_id, :organization_quality_type_id

    belongs_to :ic_action, :class_name => "MasterType", :foreign_key => "ic_action_id",
        :conditions => ['type_category = ?', 'icp_quallity_action']

    belongs_to :organization_quality_type, :class_name => "MasterType", :foreign_key => "organization_quality_type_id",
        :conditions => ['type_category = ?', 'organization_type_q_a']

    belongs_to :created_user, :foreign_key => "created_user_id", :class_name => "User"


    scope :status_based_quality_action, lambda{|status| where(:quality_action_status => status)}


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

    def action_type
        self.ic_action.type_name
    end

    def organization_type
        self.organization_quality_type.type_name        
    end

    def redirect_path
       quality_action_path(self)
    end

    def get_link
        if self.quality_action_status == "finished"         
            self.submit_time.to_date == Date.today ? '<a  href="/quality_actions/'+self.id.to_s+'/edit"><button class="btn btn-warning" type="button" style="width: 45px; height: 26px; font-size:11px">Undo</button></a>'.html_safe : ""
        else
            '<a class="btn-action glyphicons pencil btn-success" href="/quality_actions/'+self.id.to_s+'/edit"><i></i></a>'.html_safe
        end
    end

    def self.quality_action_filtering
        quality_actions = []
        if User.current_user.organization.present?
            organization_quality_type = User.current_user.organization.organization_type 
            quality_actions = QualityAction.where(:organization_quality_type_id => organization_quality_type.id )
           return quality_actions
        else
            return quality_actions
        end 
    end

    def self.quality_action_filtering_status(status_param)
        quality_actions = []
         
        if User.current_user.organization.present?
           organization_quality_type = User.current_user.organization.organization_type 
           quality_actions = QualityAction.where("organization_quality_type_id = ? AND quality_action_status = ?", organization_quality_type, status_param)
           return quality_actions
        else
            return quality_actions
        end 
    end

end
