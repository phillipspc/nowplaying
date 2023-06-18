require "sequel"

Sequel::Model.db = Sequel.sqlite('./nowplaying.db')

class User < Sequel::Model
end