$(document).ready(function() {
  // Replace form button with loader.
  // $("#billing-button-button").click(function() {
  //   $("#billing-button").hide();
  //   $("#billing-loader").show();
  //   $("#billing-loader .loading").show();
  // });
  // $("#shipping-button-button").click(function() {
  //   $("#shipping-button").hide();
  //   $("#shipping-loader").show();
  //   $("#shipping-loader .loading").show();
  // });
  // $("#checkout-button-button").click(function() {
  //   console.log("Invalids: " + validator.numberOfInvalids());
  //   console.log(validator);
  //   if (validator.numberOfInvalids() == 0) {
  //     $("#checkout-button").hide();
  //     $("#checkout-loader").show();
  //     $("#checkout-loader .loading").show();
  //   }
  // });

  // If javascript is enabled, hide the shipping details by default.
  //$("#shipping-details").hide();
  //$("#billing-button").show();  

  var billing_rules = {
    "order[name]": {
      required: true,
      minlength: 2
    },
    "order[email]": {
      required: true,
      email: true
    },
    "order[address]": {
      required: true,
      minlength: 2
    },
    "order[city]": {
      required: true,
      minlength: 2
    },
    "order[country]": {
      required: true
    },
    "order[postal]": {
      required: true
    },
    "order[phone]": {
      required: true
    },
    "order[shipping_address]": {
      required: false
    },
    "order[shipping_city]": {
      required: false
    },
    "order[shipping_province]": {
      required: false
    },
    "order[shipping_country]": {
      required: false
    },
    "order[shipping_postal]": {
      required: false
    },
    "order[shipping_phone]": {
      required: false
    }
  };

  var billing_messages = {
  };

  var shipping_rules = {
    "order[name]": {
      required: true,
      minlength: 2
    },
    "order[email]": {
      required: true,
      email: true
    },
    "order[address]": {
      required: true,
      minlength: 2
    },
    "order[city]": {
      required: true,
      minlength: 2
    },
    "order[country]": {
      required: true
    },
    "order[postal]": {
      required: true
    },
    "order[phone]": {
      required: true
    },
    "order[shipping_address]": {
      required: true
    },
    "order[shipping_city]": {
      required: true
    },
    "order[shipping_province]": {
      required: true
    },
    "order[shipping_country]": {
      required: true
    },
    "order[shipping_postal]": {
      required: true
    },
    "order[shipping_phone]": {
      required: true
    }
  };

  var shipping_messages = {
  }

  // Validate the form
  var validator = $("#order-form").validate({
    rules: billing_rules,
    messages: billing_messages,
    errorPlacement: function(error, element) {
      if (element.is(":radio"))
        error.appendTo(element.parent().next().next());
      else if (element.is(":checkbox"))
        error.appendTo(element.next());
      else if (element.is("select") && element.parent().hasClass("custom-select-container"))
        error.appendTo(element.parent().parent().next());
      else
        error.appendTo(element.parent().next());
    },
    highlight: function(element, errorClass, validClass) {
      var container;
      if ($(element).is("select"))
        container = $(element).parent().parent().parent();
      else
        container = $(element).parent().parent();
      if (container.hasClass("field-is-valid"))
        container.removeClass("field-is-valid");
      container.addClass("field-with-errors");
    },
    unhighlight: function(element, errorClass, validClass) {
      var container;
      if ($(element).is("select"))
        container = $(element).parent().parent().parent();
      else
        container = $(element).parent().parent();
      if (container.hasClass("field-with-errors"))
        container.removeClass("field-with-errors");
      container.addClass("field-is-valid");
    },
    // Take over the form submission process so the user doesn't get an extra, unneeded step before going to PayPal.
    // submitHandler: function(form) {
    //   $("#checkout-button").hide();
    //   $("#checkout-loader").show();
    //   $("#checkout-loader .loading").show();
    //   //form.submit();
    // }
  });

  // Fix select buttons so they can be customized with CSS
  $("select").select_skin();

  // Fix checkboxes so they can be customized with CSS
  // $("input[type='checkbox']").each(function() {
  //   $(this).wrap(function() {
  //     if ($(this).is(":checked")) { 
  //       return "<div class='custom-checkbox-container selected' />";
  //     } else {
  //       return "<div class='custom-checkbox-container' />";
  //     }
  //   });
  //   $(this).wrap("<div class='custom-checkbox-hitarea'>");
  //   $(this).parent().append("<div class='custom-checkbox-checkmark'></div>");
  // });

  $('#order_billing_same_as_shipping').each(function() {
    if ($(this).is(':checked') || $(this).attr('checked') == 'checked' || $(this).attr('checked') == true) {
      $('#shipping-details').hide();
      removeRules(shipping_rules);
      removeMessages(shipping_messages);
      addRules(billing_rules);
      addMessages(billing_messages);
    } else {
      $('#shipping-details').show();
      removeRules(billing_rules);
      removeMessages(billing_messages);
      addRules(shipping_rules);
      addMessages(shipping_messages);
    }
  });
  
  // Toggle the actual checkbox on and off so it submits with the form
  //$("div.custom-checkbox-container input[type='checkbox']").click(function () {
  $("#order_billing_same_as_shipping").click(function () { // NOTE: This is tied directly to the ID generated by the checkout order form.
    $(this).parent().parent().toggleClass("selected");
    if ($(this).attr("checked") == "checked" || $(this).attr("checked") == true) {
      // Turn shipping details OFF
      $("#shipping-details").slideToggle("fast");
      removeRules(shipping_rules);
      removeMessages(shipping_messages);
      addRules(billing_rules);
      addMessages(billing_messages);
    } else {
      // Turn shipping details ON
      $("#shipping-details").slideToggle("fast");
      removeRules(billing_rules);
      removeMessages(billing_messages);
      addRules(shipping_rules);
      addMessages(shipping_messages);
    }
  });

  $("#order_include_in_mailinglist").click(function() { // Generic on/off for custom checkbox.
    $(this).parent().parent().toggleClass("selected");
  });

  // Helper functions
  function addRules(rulesObj) {
    for (item in rulesObj) {
      $("[name='" + item + "']").rules("add", rulesObj[item]);
    }
  }

  function addMessages(messagesObj) {
    for (item in messagesObj) {
      $("[name='" + item + "']").messages("add", messagesObj[item]);
    }
  }

  function removeRules(rulesObj) {
    for (item in rulesObj) {
      $("[name='" + item + "']").rules("remove");
    }
  }

  function removeMessages(messagesObj) {
    for (item in messagesObj) {
      $("[name='" + item + "']").messages("remove");
    }
  }

});
