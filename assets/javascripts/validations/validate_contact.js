$(document).ready(function() {

  // Fix checkboxes so they can be customized with CSS
  $("input[type='checkbox']").each(function() {
    $(this).wrap(function() {
      if ($(this).is(":checked")) { 
        return "<div class='custom-checkbox-container selected' />";
      } else {
        return "<div class='custom-checkbox-container' />";
      }
    });
    $(this).wrap("<div class='custom-checkbox-hitarea'>");
    $(this).parent().append("<div class='custom-checkbox-checkmark'></div>");
  });

  $("#feedback_include_in_mailinglist").click(function() { // Generic on/off for custom checkbox.
    $(this).parent().parent().toggleClass("selected");
  });

  var validator = $("#contact-form").validate({
    rules: {
      "feedback[name]": {
        required: true,
        minlength: 2
      },
      "feedback[email]": {
        required: true,
        email: true
      },
      "feedback[comment]": "required"
    },

    messages: {
      "feedback[name]": {
        required: "Enter your name",
        minlength: "Please enter at least 2 characters"
      },
      "feedback[email]": {
        required: "Please enter a valid email address",
        minlength: "Please enter a valid email address"
      },
      "feedback[comment]": "Please enter a message"
    },

    errorPlacement: function(error, element) {
      if (element.is(":radio"))
        error.appendTo(element.parent().next().next());
      else if (element.is(":checkbox"))
        error.appendTo ( element.next() );
      else
        error.appendTo(element.parent().next());
    },

    highlight: function(element, errorClass, validClass) {
      var container = $(element).parent().parent();
      if (container.hasClass("field-is-valid")) {
        container.removeClass("field-is-valid");
      }
      container.addClass("field-with-errors");
    },

    unhighlight: function(element, errorClass, validClass) {
      var container = $(element).parent().parent();
      if (container.hasClass("field-with-errors")) {
        container.removeClass("field-with-errors");
      }
      container.addClass("field-is-valid");
    },

    submitHandler: function(form) {
      $("#contact-form-container").html("");
      $(".loading").show();
      $.post(form.attr("action"), form.serialize(), null, "script");
      return false;
    },

    success: function(label) {
      // set   as text for IE
      label.html(" ").addClass("checked");
      //label.parent().parent().removeClass("field-with-errors");
      //label.parent().parent().addClass("field-is-valid");
    }
  });

});
