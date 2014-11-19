
  $("#add_to_playlist").change( function() {
    console.log("clicked")
    var video_id = $(".showvideo").attr("id")

    $.post( "/videos/" + video_id + "/playlist_add", {playlist_id: $("#add_to_playlist").val()}, function() {
      $('.main').prepend("hello world");
    })

  })

$(document).ready(
  $("#playlists").click(function() {
    console.log("clicked")
    $("#playlists").addClass("active-link");
    $("#featured").removeClass("active-link");
  })

)
