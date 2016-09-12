class SupportRequest < ActiveRecord::Base

  AVALIABLE_STATUSES = %w(open closed canceled)

  belongs_to :user, inverse_of: :support_requests

  validates :status, inclusion: { in: AVALIABLE_STATUSES }
  validates :subject, :user, :status, presence: true
  scope :closed, -> { where(status: 'closed') }

  before_save :set_closed_at

  private

  def set_closed_at
    if status_changed?
      if status == 'closed'
        self.closed_at = Time.zone.now
      else
        self.closed_at = nil
      end
    end
  end
end
