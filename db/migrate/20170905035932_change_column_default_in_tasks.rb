class ChangeColumnDefaultInTasks < ActiveRecord::Migration[5.0]
  def up
    change_column_default :tasks, :task_type, nil
  end

  def down
    change_column_default :tasks, :task_type, 0
  end
end
