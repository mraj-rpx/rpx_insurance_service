jQuery ->
  $(document).ready ->
    $('#web-viewer-frame').load( ->
      windowHeight = $(window).height()
      $('#web-viewer-frame').css({'height': windowHeight + 'px'})
      window.iframeWindow = $('iframe')[0].contentWindow

      docViewerId = 'docViewer';
      optionsParams = 
        isShowBlink: false
      window.iframeWindow.WebPDF.ready(docViewerId, optionsParams).then((data) ->
        window.iframeWindow.WebPDF.ViewerInstance.on window.iframeWindow.WebPDF.EventList.PAGE_TEXT_LOADED, (event, data) ->
          $(window.iframeWindow.document).find("#btnOffline").hide()
          xmlContent = $('.xml-content-field').val()
          if xmlContent
            parsedXMLContent = $.parseXML(xmlContent)
            window.iframeWindow.WebPDF.FormPlugin.importFromXML(parsedXMLContent)
    ))

    $('.selectpicker').selectpicker()

    $('.form-save, .form-submit').on 'click', (event) ->
      iframeWindow = $('iframe')[0].contentWindow
      iframeWindow.WebPDF.ViewerInstance.saveAnnots();
      xml = iframeWindow.WebPDF.FormPlugin.getFormXML()
      status = $(event.currentTarget).data('status')
      $('.xml-content-field').val(xml)
      $('.status-field').val(status)
      $('.xml-content-field').closest('form').submit()
