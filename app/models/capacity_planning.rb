# == Schema Information
#
# Table name: capacity_plannings
#
#  id                        :integer          not null, primary key
#  capacity_plan_name        :string(255)
#  capacity_plan_description :string(255)
#  capacity_plan_notes       :text(65535)
#  capacity_plan_active      :boolean
#  capacity_plan_created_id  :integer
#  capacity_plan_updated_id  :integer
#  created_at                :datetime
#  updated_at                :datetime
#

class CapacityPlanning < ActiveRecord::Base
        include Rails.application.routes.url_helpers

    after_initialize :default_values

    def default_values
    self.capacity_plan_active = true if self.attributes.has_key?("capacity_plan_active") && self.capacity_plan_active.nil?
    end

    has_one :attachment, :as => :attachable, :dependent => :destroy

    accepts_nested_attributes_for :attachment, :allow_destroy => true


    def redirect_path
      capacity_planning_type_path(self)
    end

    before_save :before_save_values

    def before_save_values
      sel_name = self.attachment.attachment_name
      p sel_name
    end
    def capacity_planning_params
        params.require(:capacity_planning).permit(:capacity_plan_active, :capacity_plan_created_id, :capacity_plan_description,
                :capacity_plan_name, :capacity_plan_notes, :capacity_plan_updated_id, :attachment_attributes)
    end

end
