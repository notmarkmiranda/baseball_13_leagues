class AddAsyncStartsToLeague < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :async_starts, :boolean, default: false
  end
end
