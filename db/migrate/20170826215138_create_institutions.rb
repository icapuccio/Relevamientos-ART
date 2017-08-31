class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name,  null: false
      t.string :cuit, null: false
      t.string :address,  null: false
      t.string :city,  null: false
      t.string :province,  null: false
      t.integer :number,  null: false
      t.string  :activity, null: false
      t.string  :contract, null:false
      t.string  :postal_code, null:false
      t.integer :surface,  null: false, default:1
      t.integer :workers_count,  null: false, default:1
      t.integer :institutions_count,  null: false, default:1
      t.integer :phone_number, null:false

      t.timestamps
    end
  end
end
