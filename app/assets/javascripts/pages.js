// ready = ->

//   $('#tweet-submit').click ->
//     msg = $('#tweet-message').val()
//     $('.load_div').removeClass('.hide')
//     $.post '/pages/tweet', {
//       message: msg
//     }, (data, status) ->
//       $('#file_path').val(data['path'])
//       $('#path_form').submit()


// $(document).ready(ready)
// $(document).on('page:load', ready)


ready = function() {

  return $('#tweet-submit').click(function() {
    var msg;
    msg = $('#tweet-message').val();
    if(msg != "") {
      $('.load_div').removeClass('hide');
      return $.post('/pages/tweet', {
        message: msg
      }, function(data, status) {
        $('#file_path').val(data['path']);
        return $('#path_form').submit();
      });
    } else {
      $('.error-tw').html('Tweet Something!');
    }

    $(".input-group input").keyup(function() {
      $('.error-tw').html('Share A Smile');
      console.log('coming here');
    });
  });


};

$(document).ready(ready);
$(document).on('page:load', ready);
