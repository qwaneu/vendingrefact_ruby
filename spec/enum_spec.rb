#
# (c) Quality Without A Name 2011
#     Refactoring Course material
#
require 'spec_helper'
require 'enum'
class MyEnum < Enum
  values :first, :second
end

describe Enum do
  
  it "enum value is accessible with class method" do
    expect { MyEnum.first }.not_to raise_exception
  end
  
  it "non existing value raises exception" do
    expect { MyEnum.blah }.to raise_exception(Enum::NoEnumValueError)
  end
  
  it "enum values are exactly same" do
      expect(MyEnum.first).to be(MyEnum.first)
  end
  
  it "different enum values are exactly same" do
      expect(MyEnum.first).not_to be(MyEnum.second)
  end
  
  it "inspecting a value returns a readable string" do
      expect(MyEnum.first.inspect).to eq('MyEnum.first')
  end
end
