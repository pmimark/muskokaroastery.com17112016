//= require jquery.select_skin
//= require validations/validate_add_to_cart
//= require_self

jQuery(document).ready(function() {
  // $("#other-products").hide();
  //$("#other-products-caption").hide();
  // $("#other-products-toggle").click(function() {
  //   $("#other-products").slideToggle("fast");
  //   $("#other-products-caption h3").html("");
  //   $("#other-products-caption div.roast").html("");
  //   $("#other-products-caption").toggle();
  //   return false;
  // });

  // Clear other products option
  $("#other-products-caption h3").html("");
  $("#other-products-caption div.roast").html("");

  $("#other-products a").hover(
    function() {
      $("#other-products-caption h3").html($(this).attr("data-name"));
      $("#other-products-caption div.roast").html($(this).attr("data-roast"));
    },
    function() {
      $("#other-products-caption h3").html("");
      $("#other-products-caption div.roast").html("");
    }
  );
  $("select.product-flavour-select-button").select_skin();
});
