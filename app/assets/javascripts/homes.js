// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  $('.heart-art').on('click', function(event) {
    let homeId = $(this).data('home-id');
    let favorited = $(this).hasClass('glyphicon-heart');
    console.log(`clicked on ${homeId}`);
    $(this).toggleClass('glyphicon-heart-empty');
    $(this).toggleClass('glyphicon-heart');

    if (favorited) {
      $.ajax({
        method: 'POST',
        url: `/homes/${homeId}/unfavorite`,
        // success: function(){
        // }
      });
      // .done(function( msg ) {
      //   alert( "Data Saved: " + msg );
      // }).fail(function(msg) {
      //   alert( "error" +msg);
      //   // window.location = ""
      // });
    } else {
      $.ajax({
        method: 'POST',
        url: `/homes/${homeId}/favorite`
      })
    }

  })

  $('#search').on('input', function(event) {
    let searchValue = $(this).val()

    console.log(`You are searching for ${searchValue}`)
    $.ajax({
      url: '/homes',
      data: { search: searchValue},
      dataType: 'script'
    })
  })
})
