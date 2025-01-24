class ValueStripper
  extend Literal::Properties

  def self.all_replacements
    [
      new(from: "http://cheqroom.com/qr/")
    ]
  end

  prop :from, _String, reader: :private
  prop :to, _String, default: "".freeze, reader: :private

  def to_h
    {from:, to:}
  end
end
