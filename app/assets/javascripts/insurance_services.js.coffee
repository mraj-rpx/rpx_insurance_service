jQuery ->
  $('#web-viewer-frame').load( ->
    windowHeight = $(window).height() - 100;
    $('#web-viewer-frame').css({'height': windowHeight + 'px'});
  )
