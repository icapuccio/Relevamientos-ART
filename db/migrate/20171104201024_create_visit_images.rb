class CreateVisitImages < ActiveRecord::Migration[5.0]
  def change
    create_table :visit_images do |t|
      t.string :url_image, null: false
      t.references :visit, foreign_key: true, null: false
      t.timestamps
    end
  end
end
