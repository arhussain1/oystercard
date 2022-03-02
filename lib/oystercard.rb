class Oystercard
  attr_reader :balance, :entry_station, :journeys

  MAX_BALANCE = 90
  MIN_FARE = 1

  def initialize
    @balance = 0
    @journey_number = 1
    @journeys = []
  end

  def top_up(amount)
    raise ("Exceeded max balance") if exceeded_balance?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise("You have already touched in") if in_journey?
    raise("Please top up, not enough money") if balance_too_low?
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    raise("You have not touched in") unless in_journey?
    @exit_station = exit_station
    save_journey
    deduct && @entry_station = nil
  end

  def in_journey?
    @entry_station
  end


  private
  def deduct
    @balance -= MIN_FARE
  end

  def save_journey
    @journeys << { @journey_number => [@entry_station, @exit_station] }
    @journey_number += 1
  end
  
  def balance_too_low?
    @balance < MIN_FARE
  end

  def exceeded_balance?(amount)
    total_amount = balance + amount
    total_amount > MAX_BALANCE
  end
  
end