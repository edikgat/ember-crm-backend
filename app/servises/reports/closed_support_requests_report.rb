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

  def scope
    SupportRequest.closed_after(Time.now - 1.month).order(closed_at: :asc).includes(:user)
  end

  private

  def current_time
    @current_time ||= Time.zone.now
  end

end
