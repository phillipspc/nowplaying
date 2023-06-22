require "sequel"

DB = Sequel.sqlite('./nowplaying.db')

DB.create_table? :users do
  primary_key :id
  column :slack_id, String, { unique: true }
  column :spotify_token, String
  column :created_at, DateTime
end
