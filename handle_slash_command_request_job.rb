require "sucker_punch"
require_relative "user"
require_relative "spotify"

class HandleSlashCommandRequestJob
  include SuckerPunch::Job

  def perform(slack_id:, response_url:)
    user = User.find_or_create_by(slack_id:)

    if user.spotify_token
      # use the token
    else
      Spotify.send_authorization_action(slack_id:, response_url:)
    end
  end
end
