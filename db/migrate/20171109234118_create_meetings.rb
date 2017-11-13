class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.string :title
      t.string :subject
      t.datetime :meetingTime
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
