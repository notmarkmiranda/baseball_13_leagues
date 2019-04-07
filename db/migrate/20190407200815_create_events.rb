class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_type

      t.timestamps null: false
    end
  end
end
