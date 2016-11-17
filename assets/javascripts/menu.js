$(function() {
  // Toggling the menu
  var menuIsOpen = false;
  var $clonedHeader = $('#global-header').clone();

  highlightMenu();

  function closeMenuEnd() {
    $('#page-content').removeClass('menu-mode');
    $('#page-content').unbind('transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd');
    $clonedHeader.remove();
  }

  function closeMenu() {
    if (~navigator.userAgent.indexOf('Firefox')) { // TODO: Figure out why transitions (and thus this event listener) aren't working in Firefox
      closeMenuEnd();
    } else {
      $('#page-content').bind('transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd', closeMenuEnd);
    }
    $('body').css('overflow-y', 'auto');
    $('#page-content').removeClass('menu-open');
    $('#menu-collapser').removeClass('on');
    menuIsOpen = false;
  }

  function openMenu() {
    var menuTopOffset = $(window).scrollTop() + "px";

    if ($('body').hasClass('admin-mode')) {
      menuTopOffset = $(window).scrollTop() + 44 + "px";
      // NOTE: 44px is the height of the admin menu (not ideal to be hardcoded here, but it's
      // only for non-public admin mode, so no biggie).
    }

    $clonedHeader.css('top', menuTopOffset).appendTo('#page-content');
    $('#page-content').addClass('menu-mode');
    $('#page-content').addClass('menu-open');
    $('#menu-collapser').addClass('on');
    $('body').css('overflow-y', 'hidden');
    menuIsOpen = true;
  }

  function highlightMenu() {
    var pathParts = window.location.pathname.split('/');
    pathParts.shift(); // Remove empty string because of leading '/'

    var section = pathParts[0];
    var category = '';

    if (pathParts.length === 1 && pathParts[0] === '') {
      $('#mm-home').addClass('selected');
    } else if (pathParts.length > 1) {
      category = pathParts[1];

      // If category is the actual word "category", use the next sring instead.
      if (category === 'category') {
        category = pathParts[2];
      }
    }

    // The following matches URLs and is tightly tied to how those URLs correspond to their respsective sections.
    // Changes to routes will need to be reflected here.
    // TODO: This is very hands-on and fragile. Would be better to make some sort of automated solution.
    switch(section) {
    case 'meet':
      $('#mm-meet').addClass('open');

      switch(category) {
      case 'snapshot':
        $('#mm-snapshot').addClass('selected');
        break;
      case 'what-defines-us':
        $('#mm-what-defines-us').addClass('selected');
        break;
      case 'up-close':
        $('#mm-up-close').addClass('selected');
        break;
      case 'careers':
        $('#mm-careers').addClass('selected');
        break;
      case 'roastery-showroom':
        $('#mm-roastery-showroom').addClass('selected');
        break;
      default:
        $('#mm-snapshot').addClass('selected');
      }

      break;

    case 'shop':
      $('#mm-shop').addClass('open');

      switch(category) {
      case 'portfolio':
        $('#mm-portfolio').addClass('selected');
        break;
      case 'heritage-blends':
        $('#mm-heritage-blends').addClass('selected');
        break;
      case 'flavoured':
        $('#mm-flavoured').addClass('selected');
        break;
      case 'new':
        $('#mm-new').addClass('selected');
        break;
      case 'seasonal':
        $('#mm-seasonal').addClass('selected');
        break;
      case 'checkout':
        $('#mm-checkout').addClass('selected');
        break;
      default:
        $('#mm-portfolio').addClass('selected');
      }

      break;

    case 'sustain':
      $('#mm-sustain').addClass('open');

      switch(category) {
      case '100-certified':
        $('#mm-100-certified').addClass('selected');
        break;
      case 'local-community-involvement':
        $('#mm-local-community-involvement').addClass('selected');
        break;
      case 'environmental-stewardship':
        $('#mm-environmental-stewardship').addClass('selected');
        break;
      case 'grassroots':
        $('#mm-grassroots').addClass('selected');
        break;
      case 'funding-criteria':
        $('#mm-funding-criteria').addClass('selected');
        break;
      case 'organizing-a-fundraiser':
        $('#mm-organizing-a-fundraiser').addClass('selected');
        break;
      default:
        $('#mm-100-certified').addClass('selected');
      }

      break;

    case 'blog':
      $('#mm-blog').addClass('open');

      switch(category) {
      case 'stories':
        $('#mm-stories').addClass('selected');
        break;
      case 'news':
        $('#mm-news').addClass('selected');
        break;
      case 'events':
        $('#mm-events').addClass('selected');
        break;
      case 'testimonials':
        $('#mm-testimonials').addClass('selected');
        break;
      default:
        $('#mm-stories').addClass('selected');
      }

      break;

    case 'learn':
      $('#mm-learn').addClass('open');

      switch(category) {
      case 'the-muskoka-roastery-difference':
        $('#mm-the-muskoka-roastery-difference').addClass('selected');
        break;
      case 'handcrafted-quality':
        $('#mm-handcrafted-quality').addClass('selected');
        break;
      case 'brewing-tips':
        $('#mm-brewing-tips').addClass('selected');
        break;
      case 'single-serve-systems':
        $('#mm-single-serve-systems').addClass('selected');
        break;
      case 'single-origin-products':
        $('#mm-single-origin-products').addClass('selected');
        break;
      case 'coffee-storage':
        $('#mm-coffee-storage').addClass('selected');
        break;
      case 'decaffeination':
        $('#mm-decaffeination').addClass('selected');
        break;
      case 'coffee-and-health':
        $('#mm-coffee-and-health').addClass('selected');
        break;
      case 'caffeine-content':
        $('#mm-caffeine-content').addClass('selected');
        break;
      case 'allergens':
        $('#mm-allergens').addClass('selected');
        break;
      case 'how-to-become-a-retailer':
        $('#mm-how-to-become-a-retailer').addClass('selected');
        break;
      case 'wedding-or-special-event':
        $('#mm-wedding-or-special-event').addClass('selected');
        break;
      default:
        $('#mm-the-muskoka-roastery-difference').addClass('selected');
      }

      break;
    case 'where-to-buy':
      $('#mm-where-to-buy').addClass('selected');
      break;

    case 'company':
      if (category === 'contact-us') {
        $('#mm-contact-us').addClass('selected');
      }
      break;

    default:
    }
  }

  $('#main-menu-button').click(function(e) {
    e.preventDefault();
    if (menuIsOpen) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  $('#menu-collapser, #menu-close-button').click(function() {
    closeMenu();
  });


  // Toggling sub menues
  $('.menu-toggle-button').click(function(e) {
    var $button = $(e.target);
    var $container = $button.parent();

    e.preventDefault();

    $button.siblings('.sub-menu-list').slideToggle(200, function() {
      if ($container.hasClass('open')) {
        $container.removeClass('open');
      } else {
        $container.addClass('open');
      }
    });
  });
});
