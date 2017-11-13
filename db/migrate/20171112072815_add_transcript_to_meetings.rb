class AddTranscriptToMeetings < ActiveRecord::Migration[5.1]
  def change
    add_column :meetings, :transcript, :text
  end
end
