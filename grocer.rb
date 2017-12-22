def consolidate_cart(cart)
  hsh = {}
  cart.each do |item_hsh|
    item_hsh.each do |item, info|
      if hsh.include?(item)
        hsh[item][:count] += 1
      else
        hsh[item] = info
        hsh[item][:count] = 1
      end
    end
  end
  hsh
end

def consolidate_cart(cart)
  hsh = {}
  cart.each do |item_hsh|
    item_hsh.each do |item, info|
      if hsh.include?(item)
        hsh[item][:count] += 1
      else
        hsh[item] = info
        hsh[item][:count] = 1
      end
    end
  end
  hsh
end

# items2 = consolidate_cart(items)

def apply_coupons(cart, coupons)
  if coupons.length == 0
    return cart
  end
  hsh = {}
  coupon_counts = {}
  coupons.each do |coupon|
    cart.each do |item, info|
      if coupon[:item] == item && info[:count] >= coupon[:num]  #apply coupon
        hsh[item] = info
        hsh[item][:count] -= coupon[:num]
        if hsh.include?(hsh["#{item} W/COUPON"])  #add item_with_coupon hash
          hsh["#{item} W/COUPON"][:count] += 1
        else
          hsh["#{item} W/COUPON"] = {}
          info.each do |key, val|
            hsh["#{item} W/COUPON"][key] = val
          end
          hsh["#{item} W/COUPON"][:price] = coupon[:cost]
        end

        if coupon_counts.include?(coupon[:item])  #count the number of coupons used
          coupon_counts[coupon[:item]] += 1
        else
          coupon_counts[coupon[:item]] = 1
        end
      else
        hsh[item] = info  #add hash without coupon
      end
    end
  end

  coupon_counts.each do |item, count| #insert coupon counts into final hash
    if hsh.include? (item)
      hsh["#{item} W/COUPON"][:count] = count
    end
  end
  hsh
end

def apply_clearance (cart)
  cart.each do |item, info|
    if info[:clearance]
      info[:price] -= info[:price]*0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated = consolidate_cart(cart)
  discounted = apply_coupons(consolidated, coupons)
  cleared = apply_clearance(discounted)

  cleared.each do |item, info|
    if info[:count] > 0
      subtotal = info[:price] * info[:count]
      total += subtotal
    end
  end
  if total > 100
    total -= total * 0.1
  end
  total
end
