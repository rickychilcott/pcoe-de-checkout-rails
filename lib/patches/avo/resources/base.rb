module Avo
  module Resources
    class Base
      class << self
        def valid_association_name(record, association_name)
          # TODO: This is a temporary fix for the issue with the association_name being nil
          # for non-associations. This should be fixed in the Avo library itself.
          association_name if record.respond_to?(association_name)
        end
      end
    end
  end
end
