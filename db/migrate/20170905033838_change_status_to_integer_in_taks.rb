class ChangeStatusToIntegerInTaks < ActiveRecord::Migration[5.0]
  def up
    # Changes status to integer
    change_column_null :tasks, :status, true
    Task.update_all status: nil
    change_column :tasks, :status, 'integer USING CAST(status AS integer)'
    change_column_default :tasks, :status, 0
    Task.update_all status: :pending
    change_column_null :tasks, :status, false
  end

  def down
    # Changes status to string
    change_column_null :tasks, :status, false
    change_column_default :tasks, :status, nil
    change_column :tasks, :status, :string
  end
end
