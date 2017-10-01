class CreateRgrlResults < ActiveRecord::Migration[5.0]
  def change
    create_table :rgrl_results do |t|
      t.timestamps
    end
  end
end
