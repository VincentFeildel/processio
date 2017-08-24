class Event < ApplicationRecord
  belongs_to :lease
  has_many :comments
  STATUSES = ["owner_to_contact", "owner_contacted", "tenant_to_notify", "tenant_notified"]
  validates :status, presence: true, inclusion: {in: STATUSES}
end
