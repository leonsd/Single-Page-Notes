class List < ApplicationRecord
  searchkick

  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :collaborators, dependent: :destroy

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  scope :my_notes, -> (current_user) { where(user_id: current_user.id) }
  scope :status, -> (status) { where(status: status) }
  scope :search_import, -> { includes(:items) }

  def search_data
    {
      title: title,
      status: status,
      user: user.id,
      date: created_at,
      description: items.pluck(:description),
      complete: items.pluck(:done)
    }
  end
end