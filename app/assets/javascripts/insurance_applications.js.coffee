$(document).ready ->
  $('#example').DataTable
    'processing': true
    'serverSide': true
    'ajax': '/admin/insurance_applications'
    "searching": false
    "lengthChange": false
    "pageLength": 25
    'columns': [
      { 'data': 'application_number' }
      { 'data': 'company_name' }
      { 'data': 'status' }
      { 'data': 'updated_at' }
      { 'data': 'application_type' }
      { "orderable": false }
    ]
    "columnDefs": [ {
      "targets": -1
      "data": null
      "defaultContent": "<button>Click!</button>"
    }]
    "aaSorting": [[3, "desc"]]
  return