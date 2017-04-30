// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

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
