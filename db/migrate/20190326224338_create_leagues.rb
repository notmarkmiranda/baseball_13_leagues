class CreateLeagues < ActiveRecord::Migration[5.2]
  def change
    create_table :leagues do |t|
      t.string :name
      t.boolean :active, default: true
      t.date :start_date
      t.date :end_date
      t.boolean :privated, default: false
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end
