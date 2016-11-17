jQuery(document).ready(function() {
  // Focus on username field when on login page.
  $("#user_session_username").focus();

  // var check = document.createElement('div');
  // var box_shadow = !!(0 + check.style['box-shadow']);
  // if (box_shadow) {
  //   alert("box-shadow supported");
  // }
  // var webkit_box_shadow = !!(0 + check.style['WebkitBoxShadow']);
  // if (webkit_box_shadow) {
  //   alert("webkit-box-shadow supported");
  // }

  $('#flash div').delay(6000).fadeOut(1000);

  function isAnEmailAddress(value) {
    return true;
  }

  var newsletterSignupValidator = $('#newsletter-signup-form').validate({
    rules: {
      "email_address": {
        required: true,
        email: true
      }
    },

    messages: {
      "email_address": {
        required: "Please provide a valid email address",
        email: "Please provide a valid email address"
      }
    },

    submitHandler: function(form) {
      formURL = $('#newsletter-signup-form').attr('action');
      formData = $('#newsletter-signup-form').serialize();
      $('#newsletter-signup-label').hide();
      $('#newsletter-signup-form').hide();
      $('#newsletter-signup-loading').show();
      $.ajax({
        type: 'POST',
        url: formURL,
        data: formData,
        // dataType: 'JSON',

        success: function(response) {
          // display success message
          $('#newsletter-signup-loading').hide();
          $('#newsletter-signup-confirmed').show();
        },

        error: function(errorMessage) {
          // reset
          $('#newsletter-signup-loading').hide();
          $('#newsletter-signup-label').show();
          $('#newsletter-signup-form').show();
        }
      });
    }
  });

  // $('#newsletter-signup-submit').click(function(e) {
  //   e.preventDefault();

  //   // // Check that email address looks like an email address.
  //   // if (isAnEmailAddress($('#newsletter-signup-input').val())) {
  //   //   formURL = $('#newsletter-signup-form').attr('action');
  //   //   formData = $('#newsletter-signup-form').serialize();
  //   //   $.ajax({
  //   //     type: 'POST',
  //   //     url: formURL,
  //   //     data: formData,
  //   //     // dataType: 'JSON',

  //   //     success: function(response) {
  //   //       // display success message
  //   //     },

  //   //     error: function(errorMessage) {
  //   //       // do nothing
  //   //     }
  //   //   });
  //   // } else { // email doesn't look like an email address

  //   // }

  //   return false;
  // });
  
});
