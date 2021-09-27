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
         "amount": owner_amount
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
         "amount": @rental.drivy_fee + @rental.additional_insurance_option_price,
     }
    ]
  end

  private

  def owner_amount
    @rental.price_without_options - @rental.total_fee + @rental.gps_option_price + @rental.baby_seat_option_price
  end
end
