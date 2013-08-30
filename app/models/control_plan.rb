class ControlPlan < ActiveRecord::Base
  attr_accessible :plan_active, :plan_created_id, :plan_description, :plan_name, :plan_notes, :plan_updated_id
end
