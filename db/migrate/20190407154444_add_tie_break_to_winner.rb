class AddTieBreakToWinner < ActiveRecord::Migration[5.2]
  def change
    add_column :winners, :tiebreak, :integer
  end
end
