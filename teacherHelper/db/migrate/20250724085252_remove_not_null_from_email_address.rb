class RemoveNotNullFromEmailAddress < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :email_address, true
  end
end
