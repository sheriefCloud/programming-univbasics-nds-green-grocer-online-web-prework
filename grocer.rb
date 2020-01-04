
def find_item_by_name_in_collection(name, collection)
  cart_index = 0
  while cart_index < collection.size do
    c_item = collection[cart_index][:item]
    if c_item == name
      return collection[cart_index]
    end
    cart_index +=1
  end
end

def consolidate_cart(cart)
  cons_cart = []
  cart_index = 0
  while cart_index < cart.size
    c_item = cart[cart_index]
    find_item = find_item_by_name_in_collection(c_item[:item], cons_cart)

    if find_item #truthy value (ie not nil)
      find_item[:count] += 1
    else
      c_item[:count] = 1
      cons_cart << c_item
    end

  cart_index += 1
end


  cons_cart
end


def apply_coupons(cart, coupons) #--CORRECT --
  counter = 0

  while counter < coupons.size
    cart_item = find_item_by_name_in_collection(coupons[counter][:item],cart)
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name,cart)
    if cart_item && cart_item[:count] >=coupons[counter][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[counter][:num]
        cart_item[:count] -= coupons[counter][:num]
      else
        cart_item_with_coupon = {
        :item => couponed_item_name,
        :price => coupons[counter][:cost] / coupons[counter][:num],
        :count => coupons[counter][:num],
        :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[counter][:num]
      end

    end

    counter += 1
  end
 cart

end

def apply_clearance(cart)
  counter = 0
  while counter < cart.size
    if cart[counter][:clearance]
      cart[counter][:price] = (cart[counter][:price]- (cart[counter][:price]*0.20)).round(2)
    end
    counter +=1
  end
  cart
end

def checkout(cart,coupons)

  consoloditated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consoloditated_cart,coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  counter = 0
  while counter < final_cart.size
    total += final_cart[counter][:price]*final_cart[counter][:count]
    counter += 1
  end
  if total > 100
    total = (total-(total*0.10)).round(2)
  end
  total
end
