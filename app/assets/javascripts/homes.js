// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

  $('#search').on('input', function(event) {
    let queryValue = $(this).val()

  console.log(`You are searching for ${queryValue}`)

  $.ajax({
    url: '/homes',
    data: { search: searchValue },
    dataType: 'script'
  })
})
