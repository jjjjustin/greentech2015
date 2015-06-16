$(function() {
  var group = $("ol.sortable-lessons").sortable({
    group: 'lessons',
    handle: 'i.icon-move.move-lesson',
    containerSelector: 'ol.sortable-lessons',
    itemSelector: 'li.lesson',
    onDrop: function (item, container, _super) {
      var lessonData = group.sortable("serialize").get();

      $.ajax({
        url: $('#lessons').data('update-lesson-url'),
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify({data: lessonData[0]})
      });

      _super(item, container)
    }
  })
});

$(function() {
  var group = $("ol.sortable-steps").sortable({
    group: 'steps',
    handle: 'i.icon-move.move-step',
    containerSelector: 'ol.sortable-steps',
    itemSelector: 'li.step',
    onDrop: function (item, container, _super) {
      var stepData = group.sortable("serialize").get();
      var droppedLesson = container.el.data('container-lesson-id');
      var movedStep = item.data('id');

      $.ajax({
        url: $('#lessons').data('update-step-url'),
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify({data: stepData, lessonContainer: droppedLesson, draggedStep: movedStep})
      });
      
      _super(item, container)
    }
  })
});

$(function() {
  var group = $("ol.sortable-fields").sortable({
    group: 'fields',
    handle: 'i.icon-move.move-field',
    containerSelector: 'ol.sortable-fields',
    itemSelector: 'li.field',
    onDrop: function (item, container, _super) {
      var fieldData = group.sortable("serialize").get();

      $.ajax({
        url: $('#fields').data('update-field-url'),
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify({data: fieldData[0]})
      });

      _super(item, container)
    }
  })
});

$(document).ready(function() {
  $(".dotdotdot-wrapper").dotdotdot({
    //  configuration goes here
  });

  // card
  $('form').card({
    container: '.card-wrapper',
    numberInput: 'input#card-number',
    expiryInput: 'input#card-month, input#card-year',
    cvcInput: 'input#card-cvc',
    nameInput: 'input#card-name',
  });
});

// stripe
jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
});

function stripeResponseHandler(status, response) {
  var $form = $('#payment-form');

  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  } else {
    // response contains id and card, which contains additional card details
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripe_card_token" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};

// page change alert
$(document).ready(function(){
  var unsaved = false;

  $("form.answer-submit-form input, form.answer-submit-form textarea").change(function(){ //trigers change in all input fields including text type
    unsaved = true;
  });

  function unloadPage(){ 
    if(unsaved){
      return "You have unsaved changes on this page. Do you want to leave this page and discard your changes or stay on this page?";
    }
  }

  $('.save_responses').click(function() {
    unsaved = false;
  });

  window.onbeforeunload = unloadPage;
});