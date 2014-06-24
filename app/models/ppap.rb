class Ppap < ActiveRecord::Base
  belongs_to :quality_lot
  attr_accessible :Change_in_mfg_source, :Other, :appearance_report, :camo_pattern_new_to_part, 
  :change_to_materials_used, :comment, :commited_weekly_capacity, :component_review_meeting, 
  :control_plan, :date, :dfmea_desing, :fai_dimensional_inspection, :fai_material_test_result, 
  :first_article_parts, :guage_review, :hour_run, :initial_submission, :lathe_cnc, :level1, 
  :level2, :level3, :level4, :level5, :maximum_weekly_capacity, :measurement_analysis, :packaging_shipping, 
  :part_submission_warrant, :past_hour, :pfmea_analysis, :process_capabilty_study, :process_change, 
  :process_flow_diagram, :production_run_rate, :purchasing_agreement, :re_submission, :result_meeting_no, 
  :result_meeting_yes, :revision_change, :tooling_replacement, :quality_lot_id

  validate :quality_lot_id

  def self.process_ppap(params, type)    
    if type == "new"
      if params["reason_for_submission"].present?    
        params["reason_for_submission"].each do |t|
          params["ppap"][t] = true
        end
      end
      params["ppap"]
    elsif params["reason_for_submission"].present?  && type == "update"
      ppap_default= Ppap.new
      ppap_default = ppap_default.attributes
      ppap_default.delete("created_at")
      ppap_default.delete("updated_at")
      if params["reason_for_submission"].present?    
        params["reason_for_submission"].each do |t|
          params["ppap"][t] = true
        end
      end
      ppap_default.merge(params["ppap"])
    end
  end

  def self.set_levels(field, psw, value, type)
    if type == "level"
      if field == "result_meeting_no"
        ppap = Ppap.find(psw).update_attributes(:result_meeting_yes => false)
      else
        ppap = Ppap.find(psw)
        ppap[:level1] = false
        ppap[:level2] = false
        ppap[:level3] = false
        ppap[:level4] = false
        ppap[:level5] = false
        ppap[field.to_sym] = true
        ppap.save
      end
    else
        ppap = Ppap.find(psw).update_attributes(field.to_sym => value)
    end
  end
end
