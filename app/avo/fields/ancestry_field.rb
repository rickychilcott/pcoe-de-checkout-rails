class AncestryField < Avo::Fields::BaseField
  def initialize(name, **args, &)
    super

    hide_on :edit
  end
end
