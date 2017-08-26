class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name,  null: false
      t.string :cuit
      t.string :address,  null: false
      t.string :city,  null: false
      t.string :province,  null: false
      t.integer :number,  null: false
      t.string  :activity
      t.integer :surface,  null: false, default:1
      t.integer :workers_count,  null: false, default:1
      t.integer :institutions_count,  null: false, default:1
      t.integer :phone_number

      t.timestamps
    end
  end
end
