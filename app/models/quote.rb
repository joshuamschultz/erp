class Quote < ActiveRecord::Base
    include Rails.application.routes.url_helpers

    has_many :quote_vendors, :dependent => :destroy
    has_many :quote_lines, :dependent => :destroy
    has_many :quote_line_costs, :through => :quote_lines
    has_many :attachments, :as => :attachable, :dependent => :destroy
    has_many :comments, :as => :commentable, :dependent => :destroy

    attr_accessible :quote_active, :quote_created_id, :quote_description, :quote_identifier, 
    :quote_notes, :quote_status, :quote_total, :quote_updated_id, :organization_id, :po_header_id,
    :quote_po_type, :item_quantity, :customer_id, :group_id, :attachment_public

    attr_accessor :quote_po_type

    belongs_to :group
    belongs_to :organization
    # has_many :organizations, :through => :quotes_organizations
    # has_many :quotes_organizations

    belongs_to :customer, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id], 
        :foreign_key => "customer_id", :class_name => "Organization"


    belongs_to :po_header
    has_many :po_headers, :through => :quotes_po_headers
    has_many :quotes_po_headers

    validates_presence_of :quote_description, :customer_id

    def self.process_quote_associations(quote, params)
    if quote
        if params[:vendor_type] == "Group"
            quote.group.organizations.each do |vendor|
                quote_vendor = quote.quote_vendors.new(:organization_id => vendor.id)
                if quote_vendor.save
                    quote_vendor.process_quote_line_costs
                end
            end
        else
            vendors = params[:vendors] || []
            quote.quote_vendors.where(:organization_id != vendors).destroy_all

            if vendors
                vendors.each do |vendor_id|
                  unless quote.quote_vendors.find_by_organization_id(vendor_id)
                    quote_vendor = quote.quote_vendors.new(:organization_id => vendor_id)
                        if quote_vendor.save
                            quote_vendor.process_quote_line_costs
                        end
                  end
                end
            end
        end
    end
    end

    validate :check_quote_vendor, on: :update

    def check_quote_vendor
    unless self.quote_po_type.nil?
        errors.add(:organization_id, "can't be blank") unless self.organization

        if self.quote_po_type == "existing_po"
            errors.add(:po_header_id, "can't be blank") unless self.po_header
        else            
            self.po_header = nil
        end
    end
    end

    def vendors
        Organization.where(:id => self.quote_vendors.map(&:organization_id))
    end

    before_create :process_before_create

    def process_before_create
    # self.quote_identifier = CommonActions.get_new_identifier(Quote, :quote_identifier)
    self.quote_identifier =  new_quote_identifier
    end


    def new_quote_identifier
    quote_identifier = Time.now.strftime("%m%y") + ("%03d" % (Quote.where("month(created_at) = ?", Date.today.month).count + 1))
    quote_identifier.slice!(2)
    "Q" + quote_identifier
    end

    after_create :after_create_process

    def after_create_process
    self.quote_identifier = new_quote_identifier
    self.save
    end

    before_save :process_before_save

    def process_before_save
    if self.organization.present?
        po_header = self.po_header
        unless po_header.present?
            po_header = PoHeader.new(po_type_id: MasterType.po_types.first.id, organization_id: self.organization_id)
            if po_header.save
                self.po_header = po_header
            end
        end

        if po_header.present?
            self.quote_lines.each do |line|
                quote_vendor = self.quote_vendors.find_by_organization_id(self.organization_id)
                if line.po_line.nil? && quote_vendor.present?
                    quote_line_cost = quote_vendor.quote_line_costs.find_by_quote_line_id(line.id)
                    po_line = po_header.po_lines.new
                    po_line.item_alt_name = line.item_alt_name
                    po_line.po_line_quantity = line.quote_line_quantity
                    po_line.po_line_cost = quote_line_cost.present? ? quote_line_cost.quote_line_cost : 0
                    po_line.organization = line.organization
                    po_line.po_line_customer_po = line.quote_line_description
                    if po_line.save
                        line.update_attributes(po_line_id: po_line.id)
                    else
                        puts po_line.errors.to_yaml
                    end
                end
            end
            # self.quote_active = true
        end
    end    
    end

    def process_quotes(quote_po_type, organization_id, po_header_id, item_quantity)
    self.quote_po_type = quote_po_type
    self.organization_id = organization_id
    self.po_header_id = po_header_id
    unless self.quote_po_type.nil?
        errors.add(:organization_id, "can't be blank") unless self.organization

        if self.quote_po_type == "existing_po"
            errors.add(:po_header_id, "can't be blank") unless self.po_header
            return false
        else            
            self.po_header = nil
        end            
    end

    if (self.quote_lines.first.quote_line_quantity.to_i >= item_quantity.to_i)  && item_quantity.present? 
        if self.organization.present?
            po_header = self.po_header
            unless po_header.present?
                po_header = PoHeader.new(po_type_id: MasterType.po_types.first.id, organization_id: self.organization_id)
                if po_header.save
                    self.po_header = po_header
                    QuotesPoHeader.create(:quote_id => self.id, :po_header_id => po_header.id)
                end                 
            end

            if po_header.present?
                self.quote_lines.each do |line|
                    quote_vendor = self.quote_vendors.find_by_organization_id(self.organization_id)
                    if line.po_line.nil? && quote_vendor.present?
                        quote_line_cost = quote_vendor.quote_line_costs.find_by_quote_line_id(line.id)
                        po_line = po_header.po_lines.new
                        po_line.item_alt_name = line.item_alt_name
                        po_line.po_line_quantity = item_quantity
                        po_line.po_line_cost = quote_line_cost.present? ? quote_line_cost.quote_line_cost : 0
                        po_line.organization = line.organization
                        po_line.po_line_customer_po = line.quote_line_description
                        if po_line.save                            
                            line.update_attributes(po_line_id: po_line.id)
                        else
                            puts po_line.errors.to_yaml
                        end
                    end
                    line.quote_line_quantity = (line.quote_line_quantity.to_i - item_quantity.to_i)
                    line.save(:validate => false)
                end
                
            end
        end
    else
        errors.add(:item_quantity, "can't be blank")
        return false
    end
    self.save(:validate => false)
    end

    def redirect_path
        quote_path(self)
    end

    def self.get_quote_item_prices(quote, item_id)        
        line_vendor_cost = []
        quote_costs = quote.quote_lines.where("item_id = ?", item_id)
        quote_costs.each do |quote_cost|
            line_vendor_cost << quote_cost.quote_line_costs.collect{|quote_line_cos| quote_line_cos.quote_line_cost}.join(',')            
        end
        line_vendor_cost.join(",")        
    end

    def self.get_item_prices(quote_id, item_id)
        item_detail = Hash.new
        quote = Quote.find(quote_id)
        quote_line = quote.quote_lines.find(item_id)
        price = quote_line.quote_line_costs.collect{ |quote_line_cost_item| quote_line_cost_item.quote_line_cost.to_f }
        price.delete(0.0)
        price = price.join(' ,')
        item_detail["price"] = price
        if quote_line.item_alt_name.present?
            item_detail["alt_name"] = quote_line.item_alt_name.present? ? quote_line.item_alt_name.item_alt_identifier : "" 
            item_detail["item_id"] = item_id
            item_detail["alt_name_id"] = quote_line.item_alt_name.id
        else
            item_detail["alt_name"] = quote_line.item_name_sub
        end
        item_detail["quantity"] = quote_line.quote_line_quantity
        item_detail["description"] = quote_line.quote_line_description
        item_detail["revision"] = ""

        item_detail

        # a = QuoteLine.where("item_id = ? and organization_id = ?", item_id, org_id).collect(&:id)
        # tes = QuoteLineCost.where("quote_line_id in (?)",a).collect{|quote_line| quote_line.quote_line_cost.to_f}
        # tes.delete(0.0)
        # # tes = tes.split(',')
        # # tes.delete("0.0")
        # tes.join(',')
    end
end