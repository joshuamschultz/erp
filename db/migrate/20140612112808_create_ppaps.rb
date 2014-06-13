class CreatePpaps < ActiveRecord::Migration
  def change
    create_table :ppaps do |t|
      t.references :quality_lot
      t.boolean :initial_submission, :default => false
      t.boolean :re_submission, :default => false
      t.boolean :change_to_materials_used, :default => false
      t.boolean :revision_change, :default => false
      t.boolean :camo_pattern_new_to_part, :default => false
      t.boolean :tooling_replacement, :default => false
      t.boolean :process_change, :default => false
      t.boolean :Change_in_mfg_source, :default => false
      t.boolean :level1, :default => false
      t.boolean :level2, :default => false
      t.boolean :level3, :default => false
      t.boolean :level4, :default => false
      t.boolean :level5, :default => false
      t.boolean :purchasing_agreement, :default => false
      t.boolean :first_article_parts, :default => false
      t.boolean :part_submission_warrant, :default => false
      t.boolean :fai_dimensional_inspection, :default => false
      t.boolean :packaging_shipping, :default => false
      t.boolean :fai_material_test_result, :default => false
      t.boolean :component_review_meeting, :default => false
      t.boolean :guage_review, :default => false
      t.boolean :dfmea_desing, :default => false
      t.boolean :measurement_analysis, :default => false
      t.boolean :process_flow_diagram, :default => false
      t.boolean :process_capabilty_study, :default => false
      t.boolean :pfmea_analysis, :default => false
      t.boolean :production_run_rate, :default => false
      t.boolean :control_plan, :default => false
      t.boolean :appearance_report, :default => false
      t.boolean :Other, :default => false
      t.boolean :result_meeting_yes, :default => false
      t.boolean :result_meeting_no, :default => false
      t.integer :past_hour
      t.integer :hour_run
      t.integer :date
      t.integer :commited_weekly_capacity
      t.integer :maximum_weekly_capacity
      t.string :lathe_cnc
      t.text :comment

      t.timestamps
    end
    add_index :ppaps, :quality_lot_id
  end
end
