class Event < ApplicationRecord
  belongs_to :lease
  STATUSES = %w(owner_to_contact owner_contacted tenant_to_notify tenant_notified)
  validates :status, presence: true, inclusion: {in: STATUSES}
end
