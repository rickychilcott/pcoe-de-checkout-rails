class BsVariant < Literal::Enum(String)
  prop :bg_class, String

  Primary = new("primary", bg_class: "bg-primary")
  Secondary = new("secondary", bg_class: "bg-secondary")
  Success = new("success", bg_class: "bg-success")
  Danger = new("danger", bg_class: "bg-danger")
  Warning = new("warning", bg_class: "bg-warning")
  Info = new("info", bg_class: "bg-info")
end
