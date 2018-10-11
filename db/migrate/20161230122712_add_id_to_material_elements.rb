class AddIdToMaterialElements < ActiveRecord::Migration[5.0]
    def change
        add_column :material_elements, :id, :primary_key
    end
end
