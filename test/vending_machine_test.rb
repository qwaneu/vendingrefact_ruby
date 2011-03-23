require File.join(File.dirname(__FILE__),'test_helper')

require 'vending_machine'


class VendingMachineTest < Test::Unit::TestCase
  attr_reader :machine
  def setup
    @machine = VendingMachine.new
  end
  
  def test_choiceless_machine_delivers_nothing
    assert_equal(Can.none, machine.deliver(Choice.cola))
    assert_equal(Can.none, machine.deliver(Choice.fanta))
  end

  def test_delivers_can_of_choice
    machine.configure(Choice.cola, Can.cola)
    machine.configure(Choice.fanta, Can.fanta)
    machine.configure(Choice.sprite, Can.sprite)
    assert_equal(Can.cola, machine.deliver(Choice.cola))
    assert_equal(Can.fanta, machine.deliver(Choice.fanta))
    assert_equal(Can.sprite, machine.deliver(Choice.sprite))
  end
  
  def test_delivers_nothing_when_making_invalid_choice
    machine.configure(Choice.cola, Can.cola)
    machine.configure(Choice.fanta, Can.fanta)
    machine.configure(Choice.sprite, Can.sprite)
    assert_equal(Can.none, machine.deliver(Choice.beer))
  end

  def test_delivers_nothing_when_not_paid
    machine.configure(Choice.fanta, Can.fanta, 2)
    machine.configure(Choice.sprite, Can.sprite, 1)

    assert_equal(Can.none, machine.deliver(Choice.fanta))
  end

  def test_delivers_fanta_when_paid
    machine.configure(Choice.sprite, Can.sprite, 1)
    machine.configure(Choice.fanta, Can.fanta, 2)

    machine.set_value(2)
    assert_equal(Can.fanta, machine.deliver(Choice.fanta))
    assert_equal(Can.none, machine.deliver(Choice.sprite))
  end

  def test_delivers_sprite_when_paid
    machine.configure(Choice.sprite, Can.sprite, 1)
    machine.configure(Choice.fanta, Can.fanta, 2)

    machine.set_value(2)
    assert_equal(Can.sprite, machine.deliver(Choice.sprite))
    assert_equal(Can.sprite, machine.deliver(Choice.sprite))
    assert_equal(Can.none, machine.deliver(Choice.sprite))
  end
end
