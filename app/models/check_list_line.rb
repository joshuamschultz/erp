class CheckListLine < ActiveRecord::Base
    belongs_to :checklist
    belongs_to :master_type
    belongs_to :master_type, -> {where type_category: customer_quality_level}
    validate :master_type, :checklist

    def package_detail
        status = false
        package = self.checklist.quality_lot.package if self.checklist.quality_lot.package.present?
        if package.present?
            if package.part.present? && package.container.present? && package.dunnage.present? && package.unit_load.present?
                status = true
            end
        end
    end
    def check_list_line_params
      params.require(:check_list_line).permit(:check_list_status, :checklist_id,  :master_type_id)
    end
end
