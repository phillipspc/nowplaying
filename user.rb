require "sequel"

Sequel::Model.db = Sequel.sqlite('./nowplaying.db')

class User < Sequel::Model
  def self.find_or_create_by(slack_id:)
    User.first(slack_id:) || User.create(slack_id:, created_at: Time.now)
  end
end