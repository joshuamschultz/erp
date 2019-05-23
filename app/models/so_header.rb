# frozen_string_literal: true

# == Schema Information
#
# Table name: so_headers
#
#  id                    :integer          not null, primary key
#  organization_id       :integer
#  so_identifier         :string(255)
#  so_bill_to_id         :integer
#  so_ship_to_id         :integer
#  so_cofc               :boolean
#  so_squality           :boolean
#  so_total              :decimal(25, 10)  default(0.0)
#  so_notes              :text(65535)
#  so_comments           :text(65535)
#  so_status             :string(255)
#  so_created_id         :integer
#  so_updated_id         :integer
#  created_at            :datetime
#  updated_at            :datetime
#  so_header_customer_po :string(255)
#  so_due_date           :date
#

class SoHeader < ActiveRecord::Base
  belongs_to :organization
  belongs_to :bill_to_address, -> { where("addressable_type = ?", "Organization") },
             :class_name => "Address", :foreign_key => "so_bill_to_id"
  belongs_to :ship_to_address, -> { where("addressable_type = ?", "Organization") },
             :class_name => "Address", :foreign_key => "so_ship_to_id"

  has_one :po_header

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :so_lines, dependent: :destroy
  has_many :receivables, dependent: :destroy

  default_scope { order("created_at DESC") }
  scope :status_based_sos, lambda { |status| where(:so_status => status) }

  before_create :set_defaults

  def set_defaults
    self.so_status = "open"
    self.so_identifier = "Unassigned"
  end

  def self.new_so_identifier(i)
    so_identifier = Time.now.strftime("%m%y") + ("%03d" % (SoHeader.where("month(created_at) = ?", Date.today.month).count + i))
    so_identifier.slice!(2)
    "S" + so_identifier
  end

  def self.process_receivable_so_lines(params)
    so_shipment = SoShipment.find_by_id(params[:shipments][0]) if params[:shipments].present? && params[:shipments].any?
    so_header = so_shipment.so_line.so_header if so_shipment && so_shipment.so_line
    if so_header
      receivable = so_header.receivables.build
      receivable.receivable_invoice = "Invoice"
      receivable.organization = so_header.organization
      params[:shipments].each { |shipment_id|
        so_shipment = SoShipment.find_by_id(shipment_id)
        receivable.so_shipments << so_shipment if so_shipment && so_shipment.so_line && so_shipment.so_line.so_header == so_header
      }
      receivable
    else
      Receivable.new
    end
  end

  def so_report
    CommonActions.sales_report(id).html_safe
  end
end
