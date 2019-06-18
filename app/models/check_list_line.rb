# == Schema Information
#
# Table name: check_list_lines
#
#  id                :integer          not null, primary key
#  checklist_id      :integer
#  master_type_id    :integer
#  check_list_status :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

class CheckListLine < ActiveRecord::Base
  belongs_to :checklist
  belongs_to :master_type

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

  def master_type
    if super.type_category == 'customer_quality_level'
      super
    else
      nil
    end
  end
end
