require "sequel"

DB = Sequel.sqlite('./nowplaying.db')

DB.drop_table? :users

DB.create_table? :users do
  primary_key :id
  column :slack_id, String, { unique: true }
  column :spotify_token, String
  column :created_at, DateTime
  column :refreshed_at, DateTime
end
