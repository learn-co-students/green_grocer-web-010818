require 'pry'

def consolidate_cart(cart)
  new_hash = {}

  cart.each do |hash|
    hash.each do |item, item_hash|
      if new_hash[item] == nil
        new_hash[item] = item_hash
        new_hash[item][:count] = 1
      else
        new_hash[item][:count] += 1
      end
    end
  end
  cart = new_hash
  cart
end

=begin
[
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]

{
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}
=end

def apply_coupons(cart, coupons)
  #--CART--
  #{"AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  #  "KALE"   => {:price => 3.0, :clearance => false, :count => 1}}

  #--COUPON--
  #{:item => "AVOCADO", :num => 2, :cost => 5.0}

  #--RETURN--
  #{"AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
  #  "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
  #  "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1}}

  coupons.each do |coupon|

    item_name = coupon[:item]

    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += 1
      else
        cart["#{item_name} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item_name][:clearance], :count => 1}
      end
      cart[item_name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price]*0.8).round(2)
    end
  end
  cart
end

=begin
CART
{
  "PEANUTBUTTER" => {:price => 3.00, :clearance => true,  :count => 2},
  "KALE"         => {:price => 3.00, :clearance => false, :count => 3}
  "SOY MILK"     => {:price => 4.50, :clearance => true,  :count => 1}
}

FUNCTION
Take 20% off of clearance items

RETURN
{
  "PEANUTBUTTER" => {:price => 2.40, :clearance => true,  :count => 2},
  "KALE"         => {:price => 3.00, :clearance => false, :count => 3}
  "SOY MILK"     => {:price => 3.60, :clearance => true,  :count => 1}
}

=end


def checkout(cart, coupons)



  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total_cost = 0

  final_cart.each do |item, item_hash|
    total_cost += (item_hash[:price]*item_hash[:count])
  end

  #Applies 10% discount if total_cost greater than 100
  if total_cost > 100
    total_cost = total_cost * 0.9
  end

  total_cost
end




=begin

=> [{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}]
Create a checkout method that calculates the total cost of the consolidated cart.

When checking out, follow these steps in order:

Apply coupon discounts if the proper number of items are present.

Apply 20% discount if items are on clearance.

If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.
=end
