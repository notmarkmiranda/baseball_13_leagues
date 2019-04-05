class AddTokenToLeague < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :token, :string
    add_index :leagues, :token, unique: true
  end
end
