class ChangeStatusToIntegerFromVisits < ActiveRecord::Migration[5.0]
  def up
    change_column_default :visits, :status, nil
    change_column :visits, :status, 'integer USING CAST(status AS integer)'
    change_column_default :visits, :status, 0
  end
  def down
    change_column_default :visits, :status, nil
    change_column :visits, :status, :string
    change_column_default :visits, :status, 0
  end
end
