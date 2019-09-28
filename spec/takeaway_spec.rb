require 'takeaway'
require 'order'

describe TakeAway do
  #RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
  let(:order_mock) { Order }
  let(:order) { order_mock.new }
  let(:dish) { 'Chicken Poke' }
  let(:quantity) { 2 }
  let(:dish2) { 'Salmon Poke' }
  before do
    allow(order_mock).to receive(:new)
    allow(order).to receive(:print_order)
    allow(subject).to receive(:new).with(order_mock)
  end

  describe '#initialize' do
    it 'has an empty basket by dfault' do
      expect(subject.basket).to be_empty
    end
  end

  describe '#order_dish' do
    it "checks if a dish doesn't exist and raise an error" do
      dish3 = 'Chicken'
      expect { subject.order_dish(dish3) }.to raise_error "This dish doesn't exist"
    end

    it 'adds the order to the total' do
      result = 15.98
      allow(order).to receive(:order_price).and_return(result)
      subject.order_dish(dish, quantity)
      expect(subject.total).to eq result
    end

    it 'adds the order to the basket' do
      result = ['Chicken Poke x2 = £15.98']
      allow(order).to receive(:order_price).and_return(15.98)
      subject.order_dish(dish, quantity)
      expect(subject.basket).to eq result
    end
  end

  describe '#read_menu' do
    it 'reads the menu of dishes' do
      subject.menu = [{ name: 'Chicken Poke', price: 7.99 }, { name: 'Salmon Poke', price: 8.99 }]
      result = "Chicken Poke £7.99\nSalmon Poke £8.99\n"
      expect{ subject.read_menu }.to output(result).to_stdout
    end
  end

  describe '#print_basket' do
    it 'prints the basket' do
      allow(order).to receive(:order_price).and_return(15.98)
      subject.order_dish(dish, quantity)
      allow(order).to receive(:order_price).and_return(17.98)
      subject.order_dish(dish2, quantity)
      result = 'Chicken Poke x2 = £15.98, Salmon Poke x2 = £17.98'
      subject.print_basket
      expect(subject.basket_checkout).to eq result
    end
  end

  describe '#check_total' do
    it 'prints the total' do
      allow(order).to receive(:order_price).and_return(15.98)
      subject.order_dish(dish, quantity)
      allow(order).to receive(:order_price).and_return(17.98)
      subject.order_dish(dish2, quantity)
      result = "Total: £33.96\n"
      expect { subject.check_total }.to output(result).to_stdout
    end
  end

  describe '#deliver_order' do
    it 'accept the deliver request and send a text confirmation to the costumer' do
      total = 33.96
      allow(order).to receive(:order_price).and_return(total)
      allow(subject).to receive(:send_text)
      result = "Thank you for your order: £33.96. Your order was placed and will be delivered before 19.00"
      expect(subject).to receive(:send_text).with(result)
      subject.deliver_order(total)
    end
  end

end
