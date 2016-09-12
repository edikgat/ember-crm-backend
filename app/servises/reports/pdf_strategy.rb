class Reports::PdfStrategy < Prawn::Document
  TABLE_ROW_COLORS = ["FFFFFF","DDDDDD"]

  def initialize(template)
    super({})
    text template.organization, size: 18, style: :bold, align: :center
    text template.title, size: 14, style: :bold_italic, align: :center
    font_size font_size
    table template.table_data,
        column_widths: template.table_widths,
        row_colors: TABLE_ROW_COLORS
  end


end
