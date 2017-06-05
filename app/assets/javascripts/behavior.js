LoadAjaxSelect2 = function(element) {
    element.select2({
        width: "100%",
        placeholder: element.data('placeholder'),
        ajax: {
            url: "/companies",
            dataType: 'json',
            delay: 250,
            data: function(params) {
                return {
                    q: params.term
                };
            },
            cache: true
        }
    });
}

LoadSelect2 = function(element) {
    element.select2({
        width: "100%",
        placeholder: element.data('placeholder')
    });
}

SubmitForm = function(element) {
    element.click(function(e) {
        var form = $("#" + element.data("formid"))
        var valuesToSubmit = form.serialize();
        element.prop('disabled', true);
        $.ajax({
            type: "POST",
            url: form.attr('action'),
            data: valuesToSubmit,
            dataType: "JSON"
        }).success(function(json) {
            $("#insurance-application-form").select2("val", " ");
            $("#insurance-company").select2("val", " ");
            $('#insurance-app-create').modal('toggle');
            $("#insurance-form-submit").prop('disabled', false);
            table = $('#example').DataTable()
            table.ajax.reload();
        });
    })
}