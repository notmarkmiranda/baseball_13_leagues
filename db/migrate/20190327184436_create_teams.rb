class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :mlb_id

      t.timestamps null: false
    end
  end
end
