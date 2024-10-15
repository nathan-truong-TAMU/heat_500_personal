class Announcement < ApplicationRecord
  belongs_to :member, optional: true
end
