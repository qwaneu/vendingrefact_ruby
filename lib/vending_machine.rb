require 'enum'

class VendingMachine
  def initialize
    @cans = {}
  end
  
  def set_value(v)
    @c = v
  end

  # delivers the can if all ok
  def deliver(choice)
    res = nil
    if @cans.has_key?(choice)
      # check price
      if @cans[choice].price == 0 
        res = @cans[choice].type
      # or price matches
      elsif @c != nil 
        if  @cans[choice].price <= @c
          res = @cans[choice].type
          @c -= @cans[choice].price
        end
      end
    else
      res = Can.none
    end

    # if can is set then return 
    # otherwise we need to return the none
    if (res == nil)
      return Can.none
    else 
      return res
    end
  end
  
  def configure(choice, c, price = 0)
    @price = price
    can = CanContainer.new
    can.type = c
    can.price = price
    @cans[choice] = can
  end
end

class CanContainer
  def type=(t)
    @the_type = t
  end

  def type
    return @the_type
  end

  def price=(p) 
    @p = p
  end

  def price
    @p
  end
end

class Can < Enum
  values :none, :cola, :fanta, :sprite
end

class Choice < Enum
  values :cola, :fanta, :sprite, :beer
end

