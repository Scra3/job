class PaymentAction
  PAYMENT_TYPE = {credit: 'credit', debit: 'debit'}
  ACTOR = {driver: 'driver', owner: 'owner', insurance: 'insurance', assistance: 'assistance', drivy: 'drivy'}

  def initialize(rental)
    @rental = rental
  end

  def as_json
    [{
         "who": ACTOR[:driver],
         "type": PAYMENT_TYPE[:debit],
         "amount": @rental.price,
     },
     {
         "who": ACTOR[:owner],
         "type": PAYMENT_TYPE[:credit],
         "amount": @rental.price - @rental.total_fee,
     },
     {
         "who": ACTOR[:insurance],
         "type": PAYMENT_TYPE[:credit],
         "amount": @rental.insurance_fee,
     },
     {
         "who": ACTOR[:assistance],
         "type": PAYMENT_TYPE[:credit],
         "amount": @rental.assistance_fee,
     },
     {
         "who": ACTOR[:drivy],
         "type": PAYMENT_TYPE[:credit],
         "amount": @rental.drivy_fee,
     }
    ]
  end
end
