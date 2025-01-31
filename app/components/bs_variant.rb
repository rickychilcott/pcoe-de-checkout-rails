class BsVariant < Literal::Enum(String)
  Primary = new("primary")
  Secondary = new("secondary")
  Success = new("success")
  Danger = new("danger")
  Warning = new("warning")
  Info = new("info")
  White = new("white")
  Light = new("light")
  Dark = new("dark")

  def alert_class = "alert-#{value}"

  def bg_class = "bg-#{value}"

  def text_class = "text-#{value}"
end
