require "roda"
require_relative "user"

class App < Roda
  route do |r|
    r.root do
      User.first.slack_id.to_s
    end
  end
end
