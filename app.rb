require "json"
require "roda"
require_relative "handle_slash_command_request_job"

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
  end
end
