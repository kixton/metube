// <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

  $("#add_to_playlist").change( function() {
    console.log("clicked")
    $.post( "/videos/<%=@video.id%>/playlist_add", {playlist_id: $("#add_to_playlist").val()} );
    alert("added to playlist")
  });

