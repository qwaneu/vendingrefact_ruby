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
    expect(machine.deliver(Choice.cola)).to eq(Can.none)
    expect(machine.deliver(Choice.fanta)).to eq(Can.none)
  end

  it "delivers can of choice" do
    machine.configure(Choice.cola, Can.cola, 10)
    machine.configure(Choice.fanta, Can.fanta, 10)
    machine.configure(Choice.sprite, Can.sprite, 10)
    expect(machine.deliver(Choice.cola)).to eq(Can.cola)
    expect(machine.deliver(Choice.fanta)).to eq(Can.fanta)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
  end
  
  it "delivers nothing when making invalid choice" do
    machine.configure(Choice.cola, Can.cola, 10)
    machine.configure(Choice.fanta, Can.fanta, 10)
    machine.configure(Choice.sprite, Can.sprite, 10)
    expect(machine.deliver(Choice.beer)).to eq(Can.none)
  end

  it "delivers nothing when not paid" do
    machine.configure(Choice.fanta, Can.fanta, 10, 2)
    machine.configure(Choice.sprite, Can.sprite, 10, 1)

    expect(machine.deliver(Choice.fanta)).to eq(Can.none)
  end

  it "delivers fanta when paid" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(2)
    expect(machine.deliver(Choice.fanta)).to eq(Can.fanta)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
  end

  it "delivers sprite when paid" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(2)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
  end

  it "add payments" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.configure(Choice.fanta, Can.fanta, 10, 2)

    machine.set_value(1)
    machine.set_value(1)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
  end

  it "returns change" do
    machine.configure(Choice.sprite, Can.sprite, 10, 1)
    machine.set_value(2)
    expect(machine.get_change()).to eq(2)
    expect(machine.get_change()).to eq(0)
  end

  it "stock" do
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
  end

  it "add stock" do
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    machine.configure(Choice.sprite, Can.sprite, 1, 0)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
  end

  it "checkout chip if chipknip inserted" do
    machine.configure(Choice.sprite, Can.sprite, 1, 1)
    chip = Chipknip.new(10)
    machine.insert_chip(chip)
    expect(machine.deliver(Choice.sprite)).to eq(Can.sprite)
    expect(chip.credits).to eq(9)
  end
  
  it "checkout chip empty" do
    machine.configure(Choice.sprite, Can.sprite, 1, 1)
    chip = Chipknip.new(0)
    machine.insert_chip(chip)
    expect(machine.deliver(Choice.sprite)).to eq(Can.none)
    expect(chip.credits).to eq(0)
  end
end
