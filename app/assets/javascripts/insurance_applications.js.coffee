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
        "<div class='custom-column'><a title='Edit Pdf' href='/insurance_services/#{data.id}/edit?admin_edit=true'><i aria-hidden='true' class='fa fa-pencil-square-o'></i></a><a target='_blank' title='Download PDF' href='/insurance_services/#{data.id}/download_pdf'><i aria-hidden='true' class='fa fa-arrow-circle-o-down'></i></a><a target='_blank' title='View form fields XML content' href='/insurance_services/#{data.id}/form_xml_content.xml'><i aria-hidden='true' class='fa fa-file-excel-o'></i></a><a href='#' onclick='return false' data-behavior='InsuranceService.Behaviors.AdminGearPopover' data-container='body' data-app_id='#{data.id}' data-placement='left' data-toggle='popover' data-original-title='' title='Settings'><i aria-hidden='true' class='fa fa-cog'></i></a></div>"
    }]
    "aaSorting": [[4, "desc"]]
    "drawCallback": (setting) ->
      InsuranceService.applyBehaviors($('#example'));
  return