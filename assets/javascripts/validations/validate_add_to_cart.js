$(document).ready(function() {
  var validator = $("#add-to-cart-form").validate({
    rules: {
      option_whole_quantity: {
        number: true
      },
      option_ground_quantity: {
        number: true
      },
      option_whole_decaf_quantity: {
        number: true
      },
      option_ground_decaf_quantity: {
        number: true
      },
      option_coffee_pods_quantity: {
        number: true
      }
    },
    messages: {
      option_whole_quantity: "",
      option_ground_quantity: "",
      option_whole_decaf_quantity: "",
      option_ground_decaf_quantity: "",
      option_coffee_pods_quantity: ""
    },
    submitHandler: function(form) {
      $("#add-to-cart-button").hide();
      $(".loading").show();
      $.post($("#add-to-cart-form").attr("action"), $("#add-to-cart-form").serialize(), null, "script");
      return false;
    }
  });
});
