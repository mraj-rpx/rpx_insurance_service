$(document).ready ->
  $('#example').DataTable
    'processing': true
    'serverSide': true
    'ajax': {
      'url': '/admin/insurance_applications'
      'type': 'GET'
      'data': (data) ->
        additional_data = search: {
          application_number: $("#search_application_number").val()
          company_name: $("#search_company_name").val()
          insurance_application_form_id: $("#search_application_type").val()
          status: $("#search_status").val()
        }
        $.extend {}, data, additional_data
    }
    "searching": false
    "lengthChange": false
    "pageLength": 10
    "initComplete": ->
      api = this.api()
      debounced = _.debounce(api.draw, 1000)
      api.columns().every ->
        that = this
        column_name = _.map($(this.header()).html().split(" "), _.lowerCase).join("_")
        elm = $("#search_" + column_name)
        if elm.length > 0
          if elm.is("input")
            elm.on 'keyup', ->
              if $(this).data("old") != @value
                $(this).data("old", @value)
                debounced();
          else if elm.is("select")
            elm.on 'change', ->
              if $(this).data("old") != @value
                $(this).data("old", @value)
                debounced();
          return
      return
    'columns': [
      { 'data': 'application_number' }
      { 'data': 'company_name' }
      { 'data': 'application_type' }
      { 'data': 'modified_by' }
      { 'data': 'updated_at' }
      { 'data': 'status' }
      { "orderable": false }
    ]
    "columnDefs": [ {
      'targets': -1
      'data': null
      'render': (data, type, full, meta) ->
        "<div class='custom-column'><a data-turbolinks='false' title='Edit Pdf' href='/insurance_services/#{data.id}/edit?admin_edit=true'><i aria-hidden='true' class='fa fa-pencil-square-o'></i></a><a target='_blank' title='Download PDF' href='/insurance_services/#{data.id}/download_pdf'><i aria-hidden='true' class='fa fa-arrow-circle-o-down'></i></a><a target='_blank' title='View form fields XML content' href='/insurance_services/#{data.id}/form_xml_content.xml'><i aria-hidden='true' class='fa fa-file-excel-o'></i></a><a href='#' onclick='return false' data-behavior='InsuranceService.Behaviors.AdminGearPopover' data-container='body' data-app_id='#{data.id}' data-placement='left' data-toggle='popover' data-original-title='' title='Settings'><i aria-hidden='true' class='fa fa-cog'></i></a></div>"
    }]
    "aaSorting": [[4, "desc"]]
    "drawCallback": (setting) ->
      InsuranceService.applyBehaviors($('#example'));
  return
  
  $('#example thead th').each ->
    title = $(this).text()
    debugger;
    # $(this).append '<input type="text" placeholder="Search ' + title + '" />'
  return