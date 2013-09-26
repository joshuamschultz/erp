class QualityLotGauge < ActiveRecord::Base
  has_many :quality_lot_gauge_results, :dependent => :destroy
  has_many :quality_lot_gauge_dimensions, :dependent => :destroy

  belongs_to :quality_lot

  attr_accessible :lot_gauge_active, :lot_gauge_created_id, :lot_gauge_notes, :lot_gauge_status, 
  :lot_gauge_updated_id, :quality_lot_id

  def self.process_gauge_dimensions(gauge, params)
 	if gauge
 		dimensions = params[:dimensions] || []
  		gauge.quality_lot_gauge_dimensions.where("item_part_dimension_id not in (?)", dimensions).destroy_all
  		gauge.quality_lot_gauge_results.where("item_part_dimension_id not in (?)", dimensions).destroy_all

  		if dimensions
	      	dimensions.each do |dimension_id|
				unless gauge.quality_lot_gauge_dimensions.find_by_item_part_dimension_id(dimension_id)
				  	gauge.quality_lot_gauge_dimensions.new(:item_part_dimension_id => dimension_id).save
				end
	      	end
	    end
 	end
  end

  def process_quality_lot_gauges(params)
  		self.quality_lot_gauge_results.where(:lot_gauge_result_appraiser => params["appraiser"]).destroy_all
  		params[:gauge_field_data] ||= []
  		params[:gauge_field_data].each do |row_index, row_data|
  			row_data.each do |field_index, field_data|
  				puts self.id
  				puts params[:gauge_header_data][field_index]
  				puts field_data
  				puts params["appraiser"]
  				QualityLotGaugeResult.create(quality_lot_gauge_id: self.id, 
				item_part_dimension_id: params[:gauge_header_data][field_index], 
				lot_gauge_result_value: field_data, lot_gauge_result_appraiser: params["appraiser"])
  			end
  		end
  	end

end
