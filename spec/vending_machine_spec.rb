#
# (c) Quality Without A Name 2011
#     Refactoring Course material
#
require 'spec_helper'

require 'vending_machine'
require 'chipknip'

describe VendingMachine do
  let(:machine) { VendingMachine.new }
  
  it "choiceless machine delivers nothing" do
    machine.deliver(Choice.cola).should == Can.none
    machine.deliver(Choice.fanta).should == Can.none
  end

  it "delivers can of choice" do
    machine.configure(Choice.cola, Can.cola, 10)
    machine.configure(Choice.fanta, Can.fanta, 10)
    machine.configure(Choice.sprite, Can.sprite, 10)
    machine.deliver(Choice.cola).should == Can.cola
    machine.deliver(Choice.fanta).should == Can.fanta
    machine.deliver(Choice.sprite).should == Can.sprite
  end
  
  it "delivers nothing when making invalid choice" do
    machine.configure(Choice.cola, Can.cola, 10)
    machine.configure(Choice.fanta, Can.fanta, 10)
    machine.configure(Choice.sprite, Can.sprite, 10)
    machine.deliver(Choice.beer).should == Can.none
  end

  it "delivers nothing when not paid" do
    machine.configure(Choice.fanta, Can.fanta, 10, 2)
    machine.configure(Choice.sprite, Can.sprite, 10, 1)

    machine.deliver(Choice.fanta).should == Can.none
  end

  it "delivers fanta when paid" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(2)
    machine.deliver(Choice.fanta).should == Can.fanta
    machine.deliver(Choice.sprite).should == Can.none
  end

  it "delivers sprite when paid" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(2)
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.none
  end

  it "add payments" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(1)
    machine.set_value(1)
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.none
  end

  it "returns change" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.set_value(2)
    machine.get_change().should == 2
    machine.get_change().should == 0
  end

  it "stock" do
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.none
  end

  it "add stock" do
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.sprite
    machine.deliver(Choice.sprite).should == Can.none
  end

  it "checkout chip if chipknip inserted" do
    machine.configure(Choice.sprite, Can.sprite, 1, 1)
    chip = Chipknip.new(10)
    machine.insert_chip(chip)
    machine.deliver(Choice.sprite).should == Can.sprite
    chip.credits.should == 9
  end
  
  it "checkout chip empty" do
    machine.configure(Choice.sprite, Can.sprite, 1, 1)
    chip = Chipknip.new(0)
    machine.insert_chip(chip)
    machine.deliver(Choice.sprite).should == Can.none
    chip.credits.should == 0
  end
end
