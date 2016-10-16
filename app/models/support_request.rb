class SupportRequest < ActiveRecord::Base

  AVALIABLE_STATUSES = %w(open closed canceled)

  belongs_to :user, inverse_of: :support_requests

  validates :status, inclusion: { in: AVALIABLE_STATUSES }
  validates :subject, :user, :status, presence: true
  validates :subject, uniqueness: { scope: :user_id, case_sensitive: false }
  scope :closed, -> { where(status: 'closed') }
  scope :closed_after, ->(last_closed_time) do
    where(arel_table[:closed_at].gt(last_closed_time))
  end

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
