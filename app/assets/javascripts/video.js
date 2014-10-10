
  $("#add_to_playlist").change( function() {
    console.log("clicked")
    var video_id = $(".showvideo").attr("id")

    $.post( "/videos/" + video_id + "/playlist_add", {playlist_id: $("#add_to_playlist").val()}, function() {
      $('.main').prepend("hello world");
    })

  })

$(document).ready(
  $("#playlists").click(function() {
    $("#playlists").attr("class", "active");
    $("#featured").removeClass("active");
  })
)

// $(document).reasy(function() {
//   $("#search-btn").click(function() {
//     var search_keyword = $("#search-box").val();
//     $.get('/search', {query: search_keyword}, function() {
      
//     })
//   })
// })