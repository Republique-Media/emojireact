class Reaction < ApplicationRecord
  belongs_to :page, touch: true
end
