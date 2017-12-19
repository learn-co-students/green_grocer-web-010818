require "pry"

def consolidate_cart(cart)
  # code here

  item_array = []
  cart.each do |cart_item|
    cart_item.each do |item, info|
      item_array << item
    end
    item_array
  end
# binding.pry

consolidated_cart = {}


item_array.each do |item|
  cart.each do |cart_item|
      cart_item.each do |item, info|
        if consolidated_cart.has_key?(item) == false
          consolidated_cart[item] = {}
          info.each do |key, value|
            # binding.pry
            consolidated_cart[item][key] = value
            consolidated_cart[item][:count] = item_array.count(item)
          end
        end
      end
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  # code here
  # binding.pry
  if coupons.size == 0 || coupons == nil
    return cart
  end
  uniq_coupons = coupons.uniq
  cart_with_coupons = {}

  coupon_items = []

  uniq_coupons.each do |coupon|
    coupon.each do |key, value|
      if key == :item
        coupon_items << value
      end
    end
  end

  cart.each do |item, info_hash|
    uniq_coupons.each do |coupon|
      coupon.each do |key, value|
        if key == :item && value == item
          # if cart.keys.include?(coupon[:item])
          # if info_hash[:count] % coupon[:num] == 0
          #   coupons_applied_to << item
          #   coupons_perfectly_applied = true
          #   cart_with_coupons["#{item} W/COUPON"] = {}
          #   info_hash.each do |key, value|
          #     cart_with_coupons["#{item} W/COUPON"][key] = value
          #   end
          #   cart_with_coupons["#{item} W/COUPON"][:price] = coupon[:cost]
          #   cart_with_coupons["#{item} W/COUPON"][:count] = info_hash[:count] / coupon[:num]
          #    binding.pry
          # elsif info_hash[:count] % coupon[:num] != 0
            cart_with_coupons["#{item} W/COUPON"] = {}
            cart_with_coupons[item] = {}
            info_hash.each do |key, value|
              cart_with_coupons["#{item} W/COUPON"][key] = value
              cart_with_coupons[item][key] = value
            end
            cart_with_coupons["#{item} W/COUPON"][:price] = coupon[:cost]
            cart_with_coupons["#{item} W/COUPON"][:count] = (cart[item][:count] / coupon[:num]).floor
            cart_with_coupons[item][:count] = cart[item][:count] % coupon[:num]
            #  binding.pry
          # end
        elsif coupon_items.include?(item) == false
          cart_with_coupons[item] = {}
          info_hash.each do |key, value|
            cart_with_coupons[item][key] = value
          end
          # binding.pry
        end
      end
    end
  end
  cart_with_coupons
end

def apply_clearance(cart)

  cart.each do |item, info_hash|
    info_hash.each do |key, value|
      if key == :clearance && value == true
        cart[item][:price] = (cart[item][:price] * 0.8).round(1)
      end
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)

  item_totals = []
  clearance_cart.each do |item, info_hash|
    item_totals << info_hash[:price] * info_hash[:count]
  end

  cart_total = 0
  item_totals.each do |totals|
    cart_total += totals
  end

  if cart_total > 100
    cart_total = cart_total * 0.9
  end

  cart_total

end
