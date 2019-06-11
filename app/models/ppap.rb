# == Schema Information
#
# Table name: ppaps
#
#  id                         :integer          not null, primary key
#  quality_lot_id             :integer
#  initial_submission         :boolean          default(FALSE)
#  re_submission              :boolean          default(FALSE)
#  change_to_materials_used   :boolean          default(FALSE)
#  revision_change            :boolean          default(FALSE)
#  camo_pattern_new_to_part   :boolean          default(FALSE)
#  tooling_replacement        :boolean          default(FALSE)
#  process_change             :boolean          default(FALSE)
#  Change_in_mfg_source       :boolean          default(FALSE)
#  level1                     :boolean          default(FALSE)
#  level2                     :boolean          default(FALSE)
#  level3                     :boolean          default(FALSE)
#  level4                     :boolean          default(FALSE)
#  level5                     :boolean          default(FALSE)
#  purchasing_agreement       :boolean          default(FALSE)
#  first_article_parts        :boolean          default(FALSE)
#  part_submission_warrant    :boolean          default(FALSE)
#  fai_dimensional_inspection :boolean          default(FALSE)
#  packaging_shipping         :boolean          default(FALSE)
#  fai_material_test_result   :boolean          default(FALSE)
#  component_review_meeting   :boolean          default(FALSE)
#  guage_review               :boolean          default(FALSE)
#  dfmea_desing               :boolean          default(FALSE)
#  measurement_analysis       :boolean          default(FALSE)
#  process_flow_diagram       :boolean          default(FALSE)
#  process_capabilty_study    :boolean          default(FALSE)
#  pfmea_analysis             :boolean          default(FALSE)
#  production_run_rate        :boolean          default(FALSE)
#  control_plan               :boolean          default(FALSE)
#  appearance_report          :boolean          default(FALSE)
#  Other                      :boolean          default(FALSE)
#  result_meeting_yes         :boolean          default(FALSE)
#  result_meeting_no          :boolean          default(FALSE)
#  past_hour                  :integer
#  hour_run                   :integer
#  date                       :integer
#  commited_weekly_capacity   :integer
#  maximum_weekly_capacity    :integer
#  lathe_cnc                  :string(255)
#  comment                    :text(65535)
#  created_at                 :datetime
#  updated_at                 :datetime
#

class Ppap < ActiveRecord::Base
  belongs_to :quality_lot

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
