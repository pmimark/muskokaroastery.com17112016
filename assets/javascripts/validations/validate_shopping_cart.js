$(document).ready(function() {
  $("#update-totals-link").show();
  $("#update-totals-link").click(function(event) {
    var form = $("#shopping-cart-form");
    event.preventDefault();
    $.post("/shop/update_totals", form.serialize(), null, "script");
    return false;
  });

  var validator = $("#shopping-cart-form").validate({
    rules: {
    },
    messages: {
    }
  });
});
