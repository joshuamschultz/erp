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

    # def process_quality_lot_gauges(params)
    #     self.quality_lot_gauge_results.where(:lot_gauge_result_appraiser => params["appraiser"]).destroy_all
    #     params[:gauge_field_data] ||= []
    #     params[:gauge_field_data].each do |row_index, row_data|
    #       row_data.each do |field_index, field_data|
    #         # puts self.id
    #         # puts params[:gauge_header_data][field_index]
    #         # puts field_data
    #         # puts params["appraiser"]

    #         trials = field_data.split(",")
    #         # trials[0] = 0 unless trials[0].present?
    #         # trials[1] = 0 unless trials[1].present?
    #         # trials[2] = 0 unless trials[2].present?

    #         puts trials.to_s

    #         QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
    #         item_part_dimension_id: params[:gauge_header_data][field_index],
    #         lot_gauge_result_value: trials[0].to_f, lot_gauge_result_trial: 1,
    #         lot_gauge_result_row: row_index, lot_gauge_result_appraiser: params["appraiser"])

    #         QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
    #         item_part_dimension_id: params[:gauge_header_data][field_index],
    #         lot_gauge_result_value: trials[1].to_f, lot_gauge_result_trial: 2,
    #         lot_gauge_result_row: row_index, lot_gauge_result_appraiser: params["appraiser"])

    #         QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
    #         item_part_dimension_id: params[:gauge_header_data][field_index],
    #         lot_gauge_result_value: trials[2].to_f, lot_gauge_result_trial: 3,
    #         lot_gauge_result_row: row_index, lot_gauge_result_appraiser: params["appraiser"])
    #       end
    #     end
    # end










    def process_quality_lot_gauges(params)
        self.quality_lot_gauge_results.where(:lot_gauge_result_appraiser => params["appraiser"]).destroy_all
        gauge_dimensions =self.quality_lot_gauge_dimensions.collect(&:item_part_dimension_id)
        params[:gauge_field_data] ||= []

        gauge_dimensions.each do |dimension|
            for i_int in 0..9
                QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
                                                                         item_part_dimension_id: dimension,
                                                                         lot_gauge_result_value: params[:gauge_field_data]["#{dimension}"]["#{i_int}"]["1"].to_f, lot_gauge_result_trial: 1,
                                                                         lot_gauge_result_row: i_int, lot_gauge_result_appraiser: params["appraiser"])

                QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
                                                                         item_part_dimension_id: dimension,
                                                                         lot_gauge_result_value: params[:gauge_field_data]["#{dimension}"]["#{i_int}"]["2"].to_f, lot_gauge_result_trial: 2,
                                                                         lot_gauge_result_row: i_int, lot_gauge_result_appraiser: params["appraiser"])

                QualityLotGaugeResult.create(quality_lot_gauge_id: self.id,
                                                                         item_part_dimension_id: dimension,
                                                                         lot_gauge_result_value: params[:gauge_field_data]["#{dimension}"]["#{i_int}"]["3"].to_f, lot_gauge_result_trial: 3,
                                                                         lot_gauge_result_row: i_int, lot_gauge_result_appraiser: params["appraiser"])
            end
        end
    end

    def get_selected_list
        dimensions = []
        self.quality_lot_gauge_dimensions.each do |quality_lot_gauge_dimension|
            if quality_lot_gauge_dimension.item_part_dimension.present? && quality_lot_gauge_dimension.item_part_dimension.go_non_go == false
                dimensions << quality_lot_gauge_dimension.item_part_dimension_id
            end
        end
        dimensions
    end

end
