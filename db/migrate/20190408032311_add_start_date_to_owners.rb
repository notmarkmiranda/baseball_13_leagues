class AddStartDateToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :ownerships, :start_date, :date
  end
end
