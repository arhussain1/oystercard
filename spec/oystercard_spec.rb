require 'oystercard'

describe Oystercard do
  min_fare = Oystercard::MIN_FARE
  max_balance = Oystercard::MAX_BALANCE
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  describe "initialize" do
    it "should produce an empty journey list when first created" do
      expect(subject.journeys).to be_empty
    end
  end

  describe "testing the :top_up method" do
    it 'has a balance of 0 on the card' do
      expect(subject.balance).to eq(0)
    end

    it "should return 5 when passed an argument of #{min_fare}" do
      expect(subject.top_up(min_fare)).to eq(min_fare)
    end

    it "should top up the card balance by #{min_fare}" do
      subject.top_up(min_fare)
      expect(subject.balance).to eq(min_fare)
    end

    it "should raise an error when top_up result in balance above #{max_balance}" do
      expect do
        subject.top_up(max_balance + min_fare)
      end.to raise_error("Exceeded max balance")
    end

    it "should not raise and error when top_up results in less than #{max_balance} balance" do
      expect do
        subject.top_up(max_balance)
      end.not_to raise_error
    end

  end

  describe "testing :touch_in method" do

    it "should raise an error if min balance hasn't been met" do
      expect{ subject.touch_in(entry_station) }.to raise_error("Please top up, not enough money")
    end

    it "should not raise an error if balance is above minimum balance" do
      subject.top_up(1)
      expect{ subject.touch_in(entry_station) }.not_to raise_error
    end

    it "should not be able to :touch_in if in_journey?" do
      subject.top_up(5)
      subject.touch_in(entry_station)
      expect{ subject.touch_in(entry_station) }.to raise_error("You have already touched in")
    end

    it "should remember the entry entry_station" do
      subject.top_up(5)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end

  end

  describe "testing :touch_out method" do
    before do
      subject.top_up(min_fare)
    end

    it "should deduct the fare of £1 from the balance when calling :touch_out" do
      subject.touch_in(entry_station)
      expect{ subject.touch_out(exit_station) }.to change{subject.balance}.by(-1)
    end

    it "should raise an error if :touch_out is called before :touch_in" do
      expect{ subject.touch_out(exit_station) }.to raise_error("You have not touched in")
    end

    it "should make entry_station return nil after touch_out" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to be_nil
    end

  end

  describe "testing the :in_journey? method" do

    it "should not be in a journey when a new card is created" do
      expect(subject).not_to be_in_journey
    end

    it "should be in a journey when a card is touched in" do
      subject.top_up(min_fare)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it "should revert to not being in a journey once touched out" do
      subject.top_up(min_fare)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

  end

  describe "Are journeys being saved" do
    it "should return a single journey" do
      subject.top_up(min_fare)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to eq( [{1 => [entry_station, exit_station]}] )
    end
    it "should return the array length for @journeys as #{max_balance}, when #{max_balance} journeys are completed" do
      subject.top_up(max_balance)
      max_balance.times do
        subject.touch_in(entry_station) 
        subject.touch_out(exit_station)
      end
      expect(subject.journeys.length).to eq(max_balance)
    end
  end
    
end