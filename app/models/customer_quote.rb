class CustomerQuote < ActiveRecord::Base
	include Rails.application.routes.url_helpers
  	has_many :customer_quote_lines
	belongs_to :organization
	attr_accessible :organization_id,:customer_quote_active, :customer_quote_created_id, :customer_quote_description, :customer_quote_identifier, :customer_quote_notes, :customer_quote_status, :customer_quote_updated_id

	belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
	validates_presence_of :organization

	before_create :process_before_create

	has_many :customer_quote_lines, :dependent => :destroy
	has_many :comments, :as => :commentable, :dependent => :destroy
	has_many :attachments, :as => :attachable, :dependent => :destroy

    def process_before_create
	    # self.quote_identifier = CommonActions.get_new_identifier(Quote, :quote_identifier)
	    self.customer_quote_identifier =  new_customer_quote_identifier
    end


	def new_customer_quote_identifier
	    customer_quote_identifier = Time.now.strftime("%m%y") + ("%03d" % (Quote.where("month(created_at) = ?", Date.today.month).count + 1))
	    customer_quote_identifier.slice!(2)
	    "Q" + customer_quote_identifier
    end

    def redirect_path
        customer_quote_path(self)
    end
end
