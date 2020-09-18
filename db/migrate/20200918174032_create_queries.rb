class CreateQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :queries do |t|
      t.integer :song_id
      t.belongs_to :user, null: false, foreign_key: true
      t.string :query_phrase
      t.string :song_phrase

      t.timestamps
    end
  end
end
