require "sucker_punch"

class HandleSlashCommandRequestJob
  include SuckerPunch::Job

  def perform(slack_id:, response_url:)
    puts slack_id
    puts response_url
  end
end
