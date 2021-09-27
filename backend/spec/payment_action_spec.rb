require 'driver'
require 'rental'
require 'car'
require 'payment_action'
require 'date'

RSpec.describe PaymentAction do
  let(:three_days_period) {Date.today..Date.today + 2}
  let(:driver) {Driver.new(three_days_period, 20)}
  let(:car) {Car.new(1, 10, 15)}
  let(:rental) {Rental.new(1, car, driver)}

  describe '#as_json' do
    context 'without options' do
      it "returns the json reports of the driver" do
        expected = {who: PaymentAction::ACTOR[:driver], type: PaymentAction::PAYMENT_TYPE[:debit], amount: rental.price}
        expect(PaymentAction.new(rental).as_json[0]).to eq(expected)
      end

      it "returns the json reports of the owner" do
        expected = {who: PaymentAction::ACTOR[:owner], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.price - rental.total_fee}
        expect(PaymentAction.new(rental).as_json[1]).to eq(expected)
      end

      it "returns the json reports of the insurance" do
        expected = {who: PaymentAction::ACTOR[:insurance], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.insurance_fee}
        expect(PaymentAction.new(rental).as_json[2]).to eq(expected)
      end

      it "returns the json reports of the assistance" do
        expected = {who: PaymentAction::ACTOR[:assistance], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.assistance_fee}
        expect(PaymentAction.new(rental).as_json[3]).to eq(expected)
      end

      it "returns the json reports of the driyy" do
        expected = {who: PaymentAction::ACTOR[:drivy], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.drivy_fee}
        expect(PaymentAction.new(rental).as_json[4]).to eq(expected)
      end
    end

    context 'with options' do
      let(:driver) {Driver.new(three_days_period, 20, %w[gps additional_insurance baby_seat])}

      it "returns the json reports of the driver" do
        expected = {who: PaymentAction::ACTOR[:driver], type: PaymentAction::PAYMENT_TYPE[:debit], amount: rental.price}
        expect(PaymentAction.new(rental).as_json[0]).to eq(expected)
      end

      it "returns the json reports of the owner" do
        expected = {
            who: PaymentAction::ACTOR[:owner],
            type: PaymentAction::PAYMENT_TYPE[:credit],
            amount: rental.price_without_options - rental.total_fee + rental.gps_option_price + rental.baby_seat_option_price
        }
        expect(PaymentAction.new(rental).as_json[1]).to eq(expected)
      end

      it "returns the json reports of the insurance" do
        expected = {who: PaymentAction::ACTOR[:insurance], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.insurance_fee}
        expect(PaymentAction.new(rental).as_json[2]).to eq(expected)
      end

      it "returns the json reports of the assistance" do
        expected = {who: PaymentAction::ACTOR[:assistance], type: PaymentAction::PAYMENT_TYPE[:credit], amount: rental.assistance_fee}
        expect(PaymentAction.new(rental).as_json[3]).to eq(expected)
      end

      it "returns the json reports of the driyy" do
        expected = {
            who: PaymentAction::ACTOR[:drivy],
            type: PaymentAction::PAYMENT_TYPE[:credit],
            amount: rental.drivy_fee + rental.additional_insurance_option_price
        }
        expect(PaymentAction.new(rental).as_json[4]).to eq(expected)
      end
    end
  end
end
