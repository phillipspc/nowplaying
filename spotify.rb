require "slack-notifier"

class Spotify
  def self.send_authorization_action(slack_id:, response_url:)
    query = URI.encode_www_form({
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      response_type: "code",
      redirect_uri: ENV['SPOTIFY_REDIRECT_URI'],
      scope: 'user-read-playback-state',
      state: slack_id
    })

    authorize_url = URI::HTTP.build(host: "accounts.spotify.com", path: "/authorize", query: query)

    notifier = Slack::Notifier.new(response_url)
    notifier.post({
      text: "Looks like its your first time using this command. You'll need to authorize Spotify to access your account.",
      attachments: [{
        fallback: "Authorize with Spotify at #{authorize_url}",
        actions: [{
          type: "button",
          text: "Authorize with Spotify",
          url: authorize_url,
				  style: "primary"
        }]
      }]
    })
  end
end