class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :collaborators, dependent: :destroy

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
