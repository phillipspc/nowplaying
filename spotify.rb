require "httparty"
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

  def self.fetch_refresh_token_from(code:)
    uri = URI("https://accounts.spotify.com/api/token")
    params = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: ENV['SPOTIFY_REDIRECT_URI'],
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    }
    response = Net::HTTP::post_form(uri, params)
    JSON.parse(response.body)['refresh_token']
  end

  def self.fetch_access_token_from(refresh_token:)
    uri = URI("https://accounts.spotify.com/api/token")
    params = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    }
    response = Net::HTTP::post_form(uri, params)
    JSON.parse(response.body)['access_token']
  end

  def self.show_now_playing(access_token:, response_url:)
    notifier = Slack::Notifier.new(response_url)

    url = 'https://api.spotify.com/v1/me/player'
    headers = {
      "Authorization" => "Bearer #{access_token}"
    }

    response = HTTParty.get(url, headers:)
    if response.code == 204
      return notifier.post(text: "It doesn't look like you're listening to anything.", response_type: "in_channel")
    end

    data = JSON.parse(response.body)

    if data.keys.empty?
      notifier.post(text: "It doesn't look like you're listening to anything.", response_type: "in_channel")
    elsif !data['item']
      if data['device']['is_private_session']
        notifier.post(
          text: "It looks like you're currently in a private session. You'll need to go public to " \
                "share what you're listening to.",
          response_type: "in_channel"
        )
      else
        notifier.post(text: "It doesn't look like you're listening to anything.", response_type: "in_channel")
      end
    else
      notifier.post(
        text: data['item']['external_urls']['spotify'],
        response_type: "in_channel",
        unfurl_links: true
      )
    end
  end
end