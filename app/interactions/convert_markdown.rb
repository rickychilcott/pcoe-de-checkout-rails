class ConvertMarkdown < ApplicationInteraction
  string :text

  def execute
    text.gsub!("\u000A", "\n \n")
    text.gsub!("\u000D", "\n \n")
    text.gsub!("\u2028", "\n \n")
    text.gsub!("\u2029", "\n \n")
    text.gsub!("\u0085", "\n \n")
    text.gsub!("\u000C", "\n \n")
    text.gsub!("\u000B", "\n \n")

    Commonmarker.to_html(text)
  end
end
