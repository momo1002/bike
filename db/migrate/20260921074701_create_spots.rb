class CreateSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :address

      t.timestamps
    end
  end
end
