class CreateWinners < ActiveRecord::Migration[5.2]
  def change
    create_table :winners do |t|
      t.references :league, foreign_key: true
      t.references :user, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
