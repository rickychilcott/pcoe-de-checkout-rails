class BsVariant < Literal::Enum(String)
  prop :bg_class, String
  prop :text_class, String

  Primary = new("primary", bg_class: "bg-primary", text_class: "text-primary")
  Secondary = new("secondary", bg_class: "bg-secondary", text_class: "text-secondary")
  Success = new("success", bg_class: "bg-success", text_class: "text-success")
  Danger = new("danger", bg_class: "bg-danger", text_class: "text-danger")
  Warning = new("warning", bg_class: "bg-warning", text_class: "text-warning")
  Info = new("info", bg_class: "bg-info", text_class: "text-info")
  White = new("white", bg_class: "bg-white", text_class: "text-white")
  Light = new("light", bg_class: "bg-light", text_class: "text-light")
  Dark = new("dark", bg_class: "bg-dark", text_class: "text-dark")
end
