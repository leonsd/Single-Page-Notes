class Item < ApplicationRecord
  validates_presence_of :description

  belongs_to :list
end
