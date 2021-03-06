# == Schema Information
#
# Table name: quote_lines
#
#  id                     :integer          not null, primary key
#  quote_id               :integer
#  item_id                :integer
#  item_revision_id       :integer
#  item_alt_name_id       :integer
#  po_line_id             :integer
#  organization_id        :integer
#  quote_line_description :string(255)
#  quote_line_identifier  :string(255)
#  quote_line_quantity    :integer
#  quote_line_cost        :decimal(25, 10)  default(0.0)
#  quote_line_total       :decimal(25, 10)  default(0.0)
#  quote_line_status      :string(255)
#  quote_line_notes       :text(65535)
#  quote_line_active      :boolean          default(FALSE)
#  quote_line_created_id  :integer
#  quote_line_updated_id  :integer
#  created_at             :datetime
#  updated_at             :datetime
#  item_name_sub          :string(255)
#

class QuoteLine < ActiveRecord::Base
  belongs_to :quote
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  belongs_to :po_line
  belongs_to :organization

  has_many :quote_line_costs, :dependent => :destroy


  validates_numericality_of :quote_line_quantity
  validates_presence_of :quote, :quote_line_quantity#, :item_alt_name
  # validates :item_alt_name_id, :uniqueness => { :scope => :quote_id, :message => "duplicate item entry!" }, :if => :item_alt_name_id?



  # validate :check_quote_line
  # def check_quote_line
  #     errors.add(:item_id, "can add only after vendors selected!") unless self.quote.quote_vendors.any?
  # end

  before_create :process_before_create

  def process_before_create
    if self.item_alt_name_id.present?
      self.item_name_sub = ""
      self.quote_line_active = false
      self.quote_line_status = "open"
      self.item = self.item_alt_name.item
      self.item_revision = self.item_alt_name.current_revision
      self.organization_id = self.quote.customer_id
    else
      self.quote_line_active = false
      self.quote_line_status = "open"
      # self.item = self.item_alt_name.item
      # self.item_revision = self.item_alt_name.current_revision
    end

  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  after_destroy :process_after_destroy

  def process_after_destroy
      # self.po_line.destroy
      self.update_quote_total
  end

  before_save :process_before_save

  def process_before_save
      self.quote_line_total = self.quote_line_cost * self.quote_line_quantity
  end

  after_save :process_after_save

  def process_after_save
      self.update_quote_total
  end

  def update_quote_total
      Quote.skip_callback("save", :before, :process_before_save, raise: false)
      self.quote.update_attributes(:quote_total => self.quote.quote_lines.sum(:quote_line_total))
      Quote.set_callback("save", :before, :process_before_save)
  end

end
