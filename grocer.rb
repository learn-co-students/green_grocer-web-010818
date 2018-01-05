require "pry"

def consolidate_cart(cart)
  # code here
  new_cart = {}
  count = 1
  cart.each do |item|
    item.each do |name, info|
      if new_cart[name] == nil
        new_cart[name] = {}
        count = 1
      elsif new_cart[name] != nil
        count += 1
      end
      info.each do |key, val|
        new_cart[name][key] = val
        new_cart[name][:count] = count
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  # code here
  new_cart = {}
  cart.each do |item, info|
    if coupons.empty? == false
      coupons.each do |coupon|
        if coupon[:item] == item && info[:count] == coupon[:num]
          info[:count] -= coupon[:num]
          new_cart["#{item} W/COUPON"] = {}
          new_cart["#{item} W/COUPON"][:price] = coupon[:cost]
          new_cart["#{item} W/COUPON"][:clearance] = info[:clearance]
          new_cart["#{item} W/COUPON"][:count] = 1
          new_cart[item] = info
        elsif coupon[:item] == item && info[:count] > coupon[:num]
          coupon_count = info[:count]/coupon[:num]
          info[:count] %= coupon[:num]
          if info[:count] > 0
            new_cart[item] = info
          end
          new_cart["#{item} W/COUPON"] = {}
          new_cart["#{item} W/COUPON"][:price] = coupon[:cost]
          new_cart["#{item} W/COUPON"][:clearance] = info[:clearance]
          new_cart["#{item} W/COUPON"][:count] = coupon_count
        else
          new_cart[item] = info
        end
      end
    else
      new_cart[item] = info
    end
  end
  new_cart
end

def apply_clearance(cart)
  # code here
  new_cart = {}
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] *= 0.8
      info[:price] = info[:price].round(2)
      new_cart[item] = info
    else
      new_cart[item] = info
    end
  end
  new_cart
end

def checkout(cart, coupons)
  # code here
  total_cost = 0
  consolidated_cart = consolidate_cart(cart)
  cart2 = apply_coupons(consolidated_cart, coupons)
  cart3 = apply_clearance(cart2)
  cart3.each do |item, info|
    total_item_cost = info[:price] * info[:count]
    total_cost += total_item_cost
  end
  if total_cost > 100
    total_cost *= 0.9
  end
  total_cost
end
