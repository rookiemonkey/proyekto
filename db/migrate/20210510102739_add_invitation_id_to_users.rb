class AddInvitationIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invitation_id, :string, null: true
  end
end
