$(document).ready ->
  $('#example').DataTable
    'processing': true
    'serverSide': true
    'ajax': '/admin/insurance_applications'
    "searching": false
    "lengthChange": false
    "pageLength": 10
    'columns': [
      { 'data': 'application_number' }
      { 'data': 'company_name' }
      { 'data': 'status' }
      { 'data': 'updated_at' }
      { 'data': 'application_type' }
      { "orderable": false }
    ]
    "columnDefs": [ {
      'targets': -1
      'data': null
      'render': (data, type, full, meta) ->
        "<div class='custom-column'><a class='btn btn-sm btn-primary' href='/insurance_services/#{data.id}/edit?admin_edit=true'>Edit</a><a target='_blank' title='Download PDF' href='/insurance_services/#{data.id}/download_pdf'><span aria-hidden='true' class='glyphicon glyphicon-download'></span></a><a target='_blank' title='View form fields XML content' href='/insurance_services/#{data.id}/form_xml_content.xml'><span aria-hidden='true' class='glyphicon glyphicon-share'></span></a></div>"
    }]
    "aaSorting": [[3, "desc"]]
  return