class Event < ApplicationRecord
  enum :mode, %i[login logout]
end
