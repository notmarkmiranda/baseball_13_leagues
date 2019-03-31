class CreateOwnerships < ActiveRecord::Migration[5.2]
  def change
    create_table :ownerships do |t|
      t.references :user, foreign_key: true
      t.references :league, foreign_key: true
      t.references :team, foreign_key: true
      t.boolean :active, default: true
      t.boolean :paid, default: false

      t.timestamps null: false
    end
  end
end
