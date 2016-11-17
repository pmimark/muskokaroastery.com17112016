module PagesHelper

  def buy_button(name, price)
    button =  "<form target='paypal' action='https://www.paypal.com/cgi-bin/webscr' method='post'>"
    #button += "<input type='image' src='images/add_to_cart.gif' border='0' name='submit' alt='Make payments with PayPal - it's fast, free and secure!'>"
    button += "<input type='submit' name='submit' value='Add to Cart' />"
    button += "<img style='border: none; padding: 0; margin: 0;' alt='' border='0' src='https://www.paypal.com/en_US/i/scr/pixel.gif' width='1' height='1'>"
    button += "<input type='hidden' name='add' value='1'>"
    button += "<input type='hidden' name='cmd' value='_cart'>"
    button += "<input type='hidden' name='business' value='roaster@muskokaroastery.com'>"
    button += "<input type='hidden' name='no_shipping' value='2'>"
    button += "<input type='hidden' name='return' value='http://www.muskokaroastery.com/success.php'>"
    button += "<input type='hidden' name='cancel_return' value='http://www.muskokaroastery.com/cancel.php'>"
    button += "<input type='hidden' name='currency_code' value='CAD'>"
    button += "<input type='hidden' name='lc' value='CA'>"
    button += "<input type='hidden' name='bn' value='PP-ShopCartBF'>"
    button += "<input type='hidden' name='shipping' value='12.00'>"
    button += "<input type='hidden' name='shipping2' value='1.50'>"
    button += "<input type='hidden' name='item_name' value='#{ name }'>"
    button += "<input type='hidden' name='amount' value='#{ price }'>"
    button += "</form>"
    return button
  end

end
