class Reports::ClosedSupportRequestsReport

  def initialize
    report
  end

  def report
    @report ||= Reports::PdfStrategy.new(Reports::SupportRequestsReportTemplate.new(scope))
  end

  def render_report
    report.render
  end

  def file_name
    current_time.strftime("month report for %e %b %Y в %H:%M")
  end

  private

  def current_time
    @current_time ||= Time.zone.now
  end

  def scope
    SupportRequest.where.not(closed_at: nil).where("closed_at > ?", current_time - 1.month).order(:closed_at).includes(:user)
  end
end
