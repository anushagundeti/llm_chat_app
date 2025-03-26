class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.text :prompt
      t.text :response

      t.timestamps
    end
  end
end
