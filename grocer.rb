
def consolidate_cart(item)
  final = Hash.new 0
  count = :count
item.each do |hash|
  hash.each do |food, description|

if final.has_key?(food) == false
  final[food] = description
  final[food][count] = 1
elsif final.has_key?(food)
final[food][:count] +=1
end
end
end
final
end

def apply_coupons(cart, coupon)
  coupon.each do |item|
    name_of_item = item[:item]
    if cart.has_key?(name_of_item) == true && cart[name_of_item][:count] >= item[:num]
      cart[name_of_item][:count] = cart[name_of_item][:count] - item[:num]
      new_item = name_of_item + (" W/COUPON")

      if cart.has_key?(new_item) == false
        cart[new_item] = {:price => item[:cost], :clearance => cart[name_of_item][:clearance], :count => 1}
      else
        cart[new_item][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)


  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] = ((cart[item][:price])-(cart[item][:price]*0.2))

    end
  end
  cart
end

def checkout(cart, coupons)

  total = 0
  cart = consolidate_cart(cart)

  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |item, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end


  if total > 100
    total = total*(0.90)
  end
  total


end
