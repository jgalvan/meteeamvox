class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :user
      t.references :friend

      t.timestamps
    end

    add_foreign_key :friendships, :users, column: :user_id, primary_key: :id
    add_foreign_key :friendships, :users, column: :friend_id, primary_key: :id
    add_index(:friendships, [:user_id, :friend_id], :unique => true)
    add_index(:friendships, [:friend_id, :user_id], :unique => true)
  end
end
