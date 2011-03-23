require 'enums'
require 'can_container'

class VendingMachine
  CHIP = 1
  CASH = 2

  def initialize
    @cans = {}
  end
  
  def set_value(v)
    @payment_method = CASH
    if (@c != nil)
      @c += v
    else 
      @c = v
    end
  end

  def insert_chip(chipknip)
    @payment_method = CHIP
    @chipknip = chipknip
  end

  # delivers the can if all ok
  def deliver(choice)
    res = nil
    #
    #step 1: check if choice exists
    #
    if @cans.has_key?(choice)
      #
      # step2 : check price
      #
      if @cans[choice].price == 0 
        res = @cans[choice].type
      # or price matches
      else
        case @payment_method
        when CASH
          if @c != nil && @cans[choice].price <= @c
            res = @cans[choice].type
            @c -= @cans[choice].price
          end
        when CHIP
          if (@chipknip.has_value?(@cans[choice].price))
            @chipknip.reduce(@cans[choice].price)
            res = @cans[choice].type
          end
        else
          # unknown payment
        end
      end
    else
      res = Can.none
    end

    #
    # step 3: check stock
    #
    if (res && res != Can.none)
      if (@cans[choice].amount <= 0)
        res = Can.none
      else
        @cans[choice].amount -= 1
      end
    end

    # if can is set then return 
    # otherwise we need to return the none
    if (res == nil)
      return Can.none
    end

    return res
  end

  def get_change()
    to_return = 0
    if (@c > 0)
      to_return = @c
      @c = 0
    end
    return to_return
  end

  def configure(choice, c, n, price = 0)
    @price = price
    if (@cans.has_key?(choice)) 
      @cans[choice].amount += n
      return
    end
    can = CanContainer.new
    can.type = c
    can.amount = n
    can.price = price
    @cans[choice] = can
  end
end

