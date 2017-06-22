class AddIdToMaterialElements < ActiveRecord::Migration
    def change
        add_column :material_elements, :id, :primary_key
    end
end
