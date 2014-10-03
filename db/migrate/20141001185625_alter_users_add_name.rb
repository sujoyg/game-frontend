class AlterUsersAddName < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, after: 'id'
  end
end
