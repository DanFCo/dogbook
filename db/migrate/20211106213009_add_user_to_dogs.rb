class AddUserToDogs < ActiveRecord::Migration[5.2]
  def change
    # leaving user_id as `can be nil`; dog could be added by admin or dog can be adopted?
    add_reference :dogs, :user, foreign_key: true, nil: true
  end
end
