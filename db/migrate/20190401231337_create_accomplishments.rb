class CreateAccomplishments < ActiveRecord::Migration[5.2]
  def change
    create_table :accomplishments do |t|
      t.references :team, foreign_key: true
      t.integer :number
      t.date :date
      t.references :game, foreign_key: true

      t.timestamps null: false
    end
  end
end
