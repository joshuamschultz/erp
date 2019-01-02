# == Schema Information
#
# Table name: items
#
#  id                     :integer          not null, primary key
#  item_part_no           :string(255)
#  item_quantity_on_order :integer
#  item_quantity_in_hand  :integer
#  item_active            :boolean
#  item_created_id        :integer
#  item_updated_id        :integer
#  created_at             :datetime
#  updated_at             :datetime
#  lot_count              :integer
#  item_alt_part_no       :string(255)
#

class Item < ActiveRecord::Base

  has_many :item_revisions, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy
  has_many :quotes , :through => :quote_lines
  has_many :customer_quote_lines, :dependent => :destroy
  has_many :customer_quotes, :through => :customer_quote_lines
  has_many :item_part_dimensions, :through => :item_revisions
  has_many :po_lines, :dependent => :destroy
  has_many :po_shipments, :through => :po_lines
  has_many :quality_lots, :through => :po_lines
  has_many :so_lines, :dependent => :destroy
  has_many :so_shipments, :through => :so_lines
  has_many :item_alt_names, :dependent => :destroy
  has_many :quality_actions, :dependent => :destroy
  has_many :inventory_adjustments, :dependent => :destroy
  has_many :item_lots
  accepts_nested_attributes_for :item_revisions, :allow_destroy => true

  (validates_uniqueness_of :item_part_no if validates_length_of :item_part_no, :minimum => 2, :maximum => 50) if validates_presence_of :item_part_no

  # TODO: this isn't working, so fix and then uncomment the item model call for the index view in controller#index
  scope :item_with_recent_revisions, -> { joins(:item_revisions).where('item_revisions.latest_revision = ?', true) }

  after_initialize :default_values
  after_create :create_alt_name
  after_update :update_alt_name

  def default_values
    self.item_active = true if self.attributes.has_key?("item_active") && self.item_active.nil?
  end

  def create_alt_name
      self.item_alt_names.new(:item_alt_identifier => self.item_part_no).save(:validate => false)

      quotes_lines = QuoteLine.where("item_name_sub = ?",self.item_part_no)
      customer_quote_lines = CustomerQuoteLine.where("item_name_sub = ?", self.item_part_no)
      item_alt_name = ItemAltName.find_by_item_alt_identifier(self.item_part_no)
      quotes_lines.each do |quote_line|
        quote_line.item_id = self.id
        quote_line.item_revision_id = self.current_revision.id
        quote_line.item_alt_name_id = item_alt_name.id
        quote_line.item_name_sub = ""
        quote_line.save(:validate => false)
      end

      customer_quote_lines.each do |customer_quote_line|
        customer_quote_line.item_id = self.id
        customer_quote_line.item_revision_id = self.current_revision.id
        customer_quote_line.item_alt_name_id = item_alt_name.id
        customer_quote_line.item_name_sub = ""
        customer_quote_line.save(:validate => false)
      end
      unless self.item_alt_part_no == ""
        self.item_alt_names.new(:item_alt_identifier => self.item_alt_part_no).save(:validate => false)
      end

  end

  def update_alt_name
      alt_names = self.item_alt_names.where("organization_id is NULL")
      alt_names.each do |alt_name|
          alt_name.item_alt_identifier = self.item_part_no
          alt_name.save(:validate => false)
      end
  end

  def current_revision
      # self.item_revisions.find_by_latest_revision(true)
      self.item_revisions.order("item_revision_date desc").first
  end
  
  def customer_alt_names
      alt_names = []
      self.item_alt_names.each do |alt_name|
        if alt_name.item_alt_identifier != self.item_part_no
          alt_names << alt_name
        end
      end
      alt_names
  end

  def purchase_orders
      PoHeader.joins(:po_lines).where("po_lines.item_id = ?", self.id).order('created_at desc')
  end

  def sales_orders
      SoHeader.joins(:so_lines).where("so_lines.item_id = ?", self.id).order('created_at desc')
  end

  def qty_on_order(revision)
    # self.po_lines.sum(:po_line_quantity)
    # self.last.po_lines.joins(:po_header).where(po_headers: {po_status: "open"}).sum(:po_line_quantity)

    item_revision = ItemRevision.where(:id => revision).first
    item_revision.po_lines.where(:po_line_status => "open").includes(:po_header).where(po_headers: {po_status: "open"}).sum("po_line_quantity - po_line_shipped")

  end

  def qty_on_order_item
    # self.po_lines.sum(:po_line_quantity)

    self.po_lines.where(:po_line_status => "open").includes(:po_header).where(po_headers: {po_status: "open"}).sum("po_line_quantity - po_line_shipped")

  end

  def qty_on_committed(revision)

   item_revision = ItemRevision.find(revision)
   item_revision.so_lines.where(:so_line_status => "open").includes(:so_header).where(so_headers: {so_status: "open"}).sum("so_line_quantity - so_line_shipped")
  end

  def qty_on_hand
      self.quality_lots.sum(:quantity_on_hand).to_f
  end
  def weighted_cost
    total = qty_on_hand
    cost =0
    if total == 0
      cost
    else
      process_cost = 0

      self.quality_lots.each do |quality_lot|
        if quality_lot.po_line.quality_lot_id.present?
         process_cost = QualityLot.find(quality_lot.po_line.quality_lot_id).po_line.po_line_cost.to_f
        end
        cost += (quality_lot.quantity_on_hand.to_f/total)*(quality_lot.po_line.po_line_cost.to_f  + process_cost.to_f)
        process_cost = 0
      end

      cost.round(5)
    end
  end

  # def item_sell_price
  # end
  def current_location
      po_shipment = self.po_shipments.order(:created_at).last
      po_shipment.nil? ? "-" : po_shipment.po_shipped_unit.to_s + " - " + po_shipment.po_shipped_shelf
  end

  def stock(item_revision)
     item_revision.quality_lots.sum(:quantity_on_hand) if item_revision.quality_lots.present?
  end

  def time_stock(item_revision)
    (item_revision.item_revision_weekly_usage != nil && item_revision.item_revision_weekly_usage != 0) ? item_revision.item.stock(item_revision) / item_revision.item_revision_weekly_usage.to_f : 0
  end

  def run_out(item_revision)
    (item_revision.item_revision_lead_time != nil && item_revision.item_revision_lead_time != 0) ?  item_revision.item.time_stock(item_revision).to_f / item_revision.item_revision_lead_time.to_f : 0
  end

  def usage(item_revision)
     item_revision.so_lines.includes(:so_shipments).where("so_shipments.so_shipped_status =? AND so_shipments.created_at >= ? AND so_shipments.created_at >= ? ",'shipped',Date.today, Date.today - 12.month).sum("so_shipments.so_shipped_count").to_f
  end

  def a_time_stock(item_revision)
    (item_revision.item.usage(item_revision) !=0 && item_revision.item.stock(item_revision) !=0) ? item_revision.item.stock(item_revision).to_f / (item_revision.item.usage(item_revision).to_f / 52).to_f : 0
  end

  def a_run_out(item_revision)
    (item_revision.item_revision_lead_time !=0 && item_revision.item_revision_lead_time != nil ) ? item_revision.item.a_time_stock(item_revision).to_f / item_revision.item_revision_lead_time.to_f : 0
  end

  def absolute_value(item_revision)
    stock(item_revision).to_f + qty_on_order(item_revision).to_f + qty_on_committed(item_revision).to_f
  end

  def self.inventory_report_data
    items =  Item.order('item_part_no asc')
    len = items.length
    i,j,flag = 1,1,1

    content = ''
    items.select{|item|
      item.item_revisions.each_with_index do |item_revision, index|

        if item_revision.item.absolute_value(item_revision) > 0

          temp = '<tr><td align="center" valign="middle">'+item_revision.item.item_part_no+'</td><td align="center" valign="middle">'+item_revision.item_revision_name+'</td><td align="center" valign="middle">'+item_revision.item.stock(item_revision).to_s+'</td><td align="center" valign="middle">'+item_revision.item.qty_on_order(item_revision).to_s+'</td><td align="center" valign="middle">'+item_revision.item.qty_on_committed(item_revision).to_s+'</td><td align="center" valign="middle">'+item_revision.item.time_stock(item_revision).to_s+'</td><td align="center" valign="middle">'+(item_revision.item.run_out(item_revision).to_f - 1) .to_s+'</td><td align="center" valign="middle">'+item_revision.item.usage(item_revision).to_s+'</td><td align="center" valign="middle">'+item_revision.item.a_time_stock(item_revision).to_s+'</td><td align="center" valign="middle">'+item_revision.item.a_run_out(item_revision).to_s+'</td></tr>'

          if flag ==1
            content = '<div class="wrapper"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr align="left" valign="top"><td align="center"><img class="logo" alt=Smallest  src=http://erp.chessgroupinc.com/'+CompanyInfo.first.image.image.url(:original)+' /></td></tr></table></div>'
            flag = 0
          end

          if i == 1
            content += '<div id="main-wrapper">'
            content += '<div class="wrapper-1"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><th align="center" valign="middle">Part No</th><th align="center" valign="middle">Revision</th><th align="center" valign="middle">Stock</th><th align="center" valign="middle">In Process</th><th align="center" valign="middle">Committed</th><th align="center" valign="middle">Time Stock</th><th align="center" valign="middle">Run Out</th><th align="center" valign="middle">Usage</th><th align="center" valign="middle">TS</th><th align="center" valign="middle">RO</th></tr>'
          end

          if j <= 20
            content += temp
          end

          j+=1

          if i==20
            content += '</tbody></table></div></div>'
            content +='<div style="page-break-after: always; "> &nbsp;  </div>'
          end

          if len == index+1
          end

          i+=1

          if i==21
            i= 1
            j = 1
            content
          end
        end
      end
    }
    html = '<!DOCTYPE html><title>Inventory_Report</title><!--[if lt IE 9]><script src="html5.js"></script><![endif]--><style type="text/css">@charset "utf-8";body {font-family: Arial, Helvetica, sans-serif;font-size: 12px;background-color: #FFF;margin-left: 0px;margin-top: 0px;margin-right: 0px;margin-bottom: 0px;}/* New Style */.clear {clear: both;}#main-wrapper {float: left;height: auto;width: 640px;border:1px solid #000;}table {border-collapse: collapse;}.logo {width: 180px;}.wrapper-1 td {border: 1px solid #000;padding: 6px;}.wrapper-1 th {border: 1px solid #000;font-size: 12px;padding: 6px;} .wrapper {width: 640px;</style>
            '+content+'
        '
    html
  end
end
