class CustomerQuote < ActiveRecord::Base
    include Rails.application.routes.url_helpers
    has_many :customer_quote_lines
    belongs_to :organization
    

    belongs_to :organization, -> {where organization_type_id:  MasterType.find_by_type_value("customer").id}
    validates_presence_of :organization

    before_create :process_before_create

    has_many :customer_quote_lines, :dependent => :destroy
    has_many :comments, :as => :commentable, :dependent => :destroy
    has_many :attachments, :as => :attachable, :dependent => :destroy


    def process_before_create
        # self.quote_identifier = CommonActions.get_new_identifier(Quote, :quote_identifier)
        self.customer_quote_identifier =  new_customer_quote_identifier
        self.customer_quote_status = "open"
    end


    def new_customer_quote_identifier
        customer_quote_identifier = Time.now.strftime("%m%y") + ("%03d" % (Quote.where("month(created_at) = ?", Date.today.month).count + 1))
        customer_quote_identifier.slice!(2)
        "B" + customer_quote_identifier
    end

    def redirect_path
        customer_quote_path(self)
    end

    def self.get_qoute_items(customer_quote)
        items = []
        customer_quote.customer_quote_lines.each do |customer_quote_line|
            if customer_quote_line.item_alt_name.present?
                items << '<a href="/items/'+customer_quote_line.item.id.to_s+'">'+customer_quote_line.item_alt_name.item_alt_identifier+'</a>'
            else
                items << customer_quote_line.item_name_sub
            end
        end
        items.join(", ").html_safe      
    end
end
