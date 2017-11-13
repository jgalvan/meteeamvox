class CreateFriendRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_requests do |t|
      t.references :user, foreign_key: true
      t.references :friend

      t.timestamps
    end

    add_foreign_key :friend_requests, :users, column: :friend_id, primary_key: :id
  end
end
