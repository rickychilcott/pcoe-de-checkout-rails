# Semantic color variants, mapped to Tailwind utility bundles.
# (Name kept from the Bootstrap era; call sites pass BsVariant::Danger etc.)
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

  ALERT_CLASSES = {
    "primary" => "bg-primary-50 border-primary-200",
    "secondary" => "bg-gray-50 border-gray-200",
    "success" => "bg-green-50 border-green-200",
    "danger" => "bg-red-50 border-red-200",
    "warning" => "bg-amber-50 border-amber-200",
    "info" => "bg-sky-50 border-sky-200",
    "white" => "bg-white border-gray-200",
    "light" => "bg-gray-50 border-gray-200",
    "dark" => "bg-gray-800 border-gray-900"
  }.freeze

  BG_CLASSES = {
    "primary" => "bg-primary-100",
    "secondary" => "bg-gray-200",
    "success" => "bg-green-100",
    "danger" => "bg-red-100",
    "warning" => "bg-amber-100",
    "info" => "bg-sky-100",
    "white" => "bg-white",
    "light" => "bg-gray-100",
    "dark" => "bg-gray-800"
  }.freeze

  TEXT_CLASSES = {
    "primary" => "text-primary-700",
    "secondary" => "text-gray-600",
    "success" => "text-green-700",
    "danger" => "text-red-700",
    "warning" => "text-amber-700",
    "info" => "text-sky-700",
    "white" => "text-white",
    "light" => "text-gray-500",
    "dark" => "text-gray-900"
  }.freeze

  def alert_class = ALERT_CLASSES.fetch(value)

  def bg_class = BG_CLASSES.fetch(value)

  def text_class = TEXT_CLASSES.fetch(value)
end
