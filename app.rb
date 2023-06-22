require "dotenv"
require "json"
require "roda"
require_relative "handle_slash_command_request_job"

Dotenv.load

class App < Roda
  route do |r|
    r.root do
      "Hello!"
    end

    r.post "nowplaying" do
      slack_id = "#{r['user_id']}-#{r['team_id']}"
      response_url = r['response_url']

      HandleSlashCommandRequestJob.perform_async(slack_id:, response_url:)

      response['Content-Type'] = 'application/json'
      response.status = 200
      { response_type: "in_channel", text: "" }.to_json
    end

    r.get "spotify-callback" do
      slack_id = r['state']
      code = r['code']

      refresh_token = Spotify.fetch_refresh_token_from_code(code)
      puts refresh_token
      puts slack_id

      user = User.first(slack_id:)
      user.spotify_token = refresh_token
      user.refreshed_at = Time.now
      user.save

      response['Content-Type'] = 'application/json'
      response.status = 200
      JSON.generate({ message: "Authorization successful. You are now ready to use the /nowplaying command!" })
    end
  end
end
