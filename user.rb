require "sequel"

Sequel::Model.db = Sequel.sqlite('./nowplaying.db')

class User < Sequel::Model
  def self.handle_nowplaying(slack_id:, response_url:)
    puts slack_id
    puts response_url
  end
end