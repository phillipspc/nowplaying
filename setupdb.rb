require "sequel"

DB = Sequel.sqlite('./nowplaying.db')

DB.drop_table? :users

DB.create_table? :users do
  primary_key :id
  column :slack_id, String, { unique: true }
  column :spotify_token, String
  column :created_at, DateTime
end

### For testing ###
# users = DB[:users]

# begin
#   users.insert(slack_id: 123, spotify_token: "abc", created_at: Time.now)
#   users.insert(slack_id: 123, spotify_token: "abc", created_at: Time.now)
# rescue Sequel::UniqueConstraintViolation => e
#   puts "Hit UniqueConstraintViolation, as expected 👍"
# end

# p "User count: #{users.count}"
# p "First User: #{users.first}"

