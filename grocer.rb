def consolidate_cart(cart)
  result = {}
  cart.each do |hash|
    hash.each do |item, info_hash|
      if !result.keys.include?(item)
        result[item] = info_hash
        result[item][:count] = 1
      else
        result[item][:count] += 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  result = cart
  coupon_count_hash = {}

  coupons.each do |coupon_hash|

    if !coupon_count_hash.keys.include?(coupon_hash[:item])
      coupon_count_hash[(coupon_hash[:item])] = 0
    end

    if result.keys.include?(coupon_hash[:item])
      if result[(coupon_hash[:item])][:count] >= (coupon_hash[:num])
        coupon_count_hash[(coupon_hash[:item])] += 1
        result[(coupon_hash[:item])][:count] -= (coupon_hash[:num])
        result["#{(coupon_hash[:item])} W/COUPON"] = {}
        result["#{(coupon_hash[:item])} W/COUPON"][:price] = (coupon_hash[:cost])
        result["#{(coupon_hash[:item])} W/COUPON"][:clearance] = result[(coupon_hash[:item])][:clearance]
        result["#{(coupon_hash[:item])} W/COUPON"][:count] = coupon_count_hash[(coupon_hash[:item])]
      end
    end
  end
  result
end

def apply_clearance(cart)
  cart.each do |item, hash|
    if hash[:clearance] == true
      hash[:price] = ((hash[:price]*0.8)*100).round / 100.0
    end
  end
end

def checkout(cart, coupons)
  total = 0
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  cleared = apply_clearance(couponed)

  cleared.each do |item, hash|
    this_item_total = hash[:price] * hash[:count]
    total += this_item_total
  end

  if total >= 100
    total *= 0.9
  end
  total
end
