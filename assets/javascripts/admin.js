//= require lib/jquery-ui-1.8.11/jquery.ui.core
//= require lib/jquery-ui-1.8.11/jquery.ui.widget
//= require lib/jquery-ui-1.8.11/jquery.ui.mouse
//= require lib/jquery-ui-1.8.11/jquery.ui.sortable
//= require tinymce
//= require_self

jQuery(document).ready(function() {
  // Page sorting function
  $("ul.sortable-pages").sortable({
    axis: 'y',
    dropOnEmpty: false,
    handle: '.handle',
    cursor: 'move',
    items: 'li',
    opacity: 0.4,
    scroll: true,
    start: function(e, ui) {
    },
    stop: function(e, ui) {
      $.ajax({
        url:  "/pages/" + String(ui.item.attr("data-page")) +
              "/sort/" + String(ui.item.index() + 1),
        context: document.body,
        success: function() {
          //alert("done");
        }
      });
    }
  });

  $("ul.sortable-blog-categories").sortable({
    axis: 'y',
    dropOnEmpty: false,
    handle: '.handle',
    cursor: 'move',
    items: 'li',
    opacity: 0.4,
    scroll: true,
    start: function(e, ui) {
    },
    stop: function(e, ui) {
      $.ajax({
        url:  "/blog_categories/" + String(ui.item.attr("data-blog-category")) +
              "/sort/" + String(ui.item.index() + 1),
        context: document.body,
        success: function() {
          // finished
        }
      });
    }
  });

  $("ul.sortable-products").sortable({
    axis: 'y',
    dropOnEmpty: false,
    handle: '.handle',
    cursor: 'move',
    items: 'li',
    opacity: 0.4,
    scroll: true,
    start: function(e, ui) {
    },
    stop: function(e, ui) {
      $.ajax({
        url:  "/products/" + String(ui.item.attr("data-product")) +
              "/sort/" + String(ui.item.index() + 1),
        context: document.body,
        success: function() {
          $("ul.sortable-products").effect("highlight", {}, 1500);
        }
      });
    }
  });

  $("ul.sortable-flavours").sortable({
    axis: 'y',
    dropOnEmpty: false,
    handle: '.handle',
    cursor: 'move',
    items: 'li',
    opacity: 0.4,
    scroll: true,
    start: function(e, ui) {
    },
    stop: function(e, ui) {
      $.ajax({
        url:  "/products/" + String(ui.item.parent().attr("data-product")) +
              "/product_flavours/" + String(ui.item.attr("data-flavour")) +
              "/sort/" + String(ui.item.index() + 1),
        context: document.body,
        success: function() {
          // finished
        }
      });
    }
  });

});

