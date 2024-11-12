# db/migrate/20241112134613_add_user_id_to_events.rb
class AddUserIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :user, foreign_key: true, null: true # Cambia null: false a null: true
  end
end
