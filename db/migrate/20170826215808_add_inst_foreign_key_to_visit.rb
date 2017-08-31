class AddInstForeignKeyToVisit < ActiveRecord::Migration[5.0]
  def change
    add_reference :visits, :institution, foreign_key: true
  end
end
