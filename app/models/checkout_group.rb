class CheckoutGroup
  extend Literal::Properties

  prop :items, _Enumerable(Item), reader: :public
end
