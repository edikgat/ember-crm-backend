class Reports::SupportRequestsReportTemplate
  TABLE_WIDTHS = [150, 70, 100]
  TABLE_HEADERS = ["Subject", "Date", "User"]

  attr_reader :records

  def initialize(records)
    @records = records
  end

  def table_widths
    TABLE_WIDTHS
  end

  def font_size
    10
  end

  def organization
    'Crossover'
  end

  def title
    'Closed Tickets Report'
  end

  def table_data
    [TABLE_HEADERS] + records_data
  end

  private

  def records_data
    @records_data ||= records.map { |e| [e.subject, e.closed_at.strftime("%m/%d/%y"), e.user.try(:full_name)] }
  end
end
