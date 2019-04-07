class AddConfirmedToWinner < ActiveRecord::Migration[5.2]
  def change
    add_column :winners, :confirmed, :boolean, default: false
    add_reference :winners, :accomplishment, foreign_key: true
  end
end
