var InsuranceService = {
    "Behaviors": {}
}

InsuranceService.Behaviors.LoadAjaxSelect2 = function(element) {
    element.select2({
        width: "100%",
        placeholder: element.data('placeholder'),
        minimumInputLength: 3,
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

InsuranceService.Behaviors.LoadSelect2 = function(element) {
    element.select2({
        width: "100%",
        placeholder: element.data('placeholder')
    });
}

InsuranceService.Behaviors.SubmitForm = function(element) {
    element.click(function(e) {
        var form = $("#" + element.data("formid"))
        var update = $("#insurance_application_filled_form_id").val() ? true : false
        var action_url = update ? (form.attr('action') + "/" + $("#insurance_application_filled_form_id").val()) : form.attr('action')
        var valuesToSubmit = form.serialize();
        element.prop('disabled', true);
        $.ajax({
            type: update ? "PUT" : "POST",
            url: action_url,
            data: valuesToSubmit,
            dataType: "JSON"
        }).success(function(json) {
            $("#insurance-application-form").select2("val", " ");
            $("#insurance-company").select2("val", " ");
            $('#insurance-app-create').modal('toggle');
            $("#insurance-form-submit").prop('disabled', false);
            $("#insurance_application_filled_form_id").val(null);
            $("#insurance-form-submit").html("Create");
            table = $('#example').DataTable()
            table.ajax.reload();
        });
    })
}

InsuranceService.Behaviors.UpdatePopUp = function(element) {
    element.click(function(e) {
        e.preventDefault();
        $("#insurance-application-form").val($(this).data("insurance_application_form_id")).trigger('change');
        $("#insurance-company").empty().append('<option selected value="' + $(this).data("company_id") + '">' + $(this).data("company_name") + '</option>').trigger('change');
        $("#insurance_application_filled_form_id").val($(this).data("app_id"));
        $("#insurance-form-submit").html("Update");
        $("#insurance-app-create").modal("show");
    })
}

InsuranceService.Behaviors.AdminGearPopover = function(element) {
    $(element).popover({
        trigger: "manual",
        html: true,
        animation: false,
        content: function() {
            var app_id = $(this).data("app_id")
            var company_id = $(this).data("company_id")
            var company_name = $(this).data("company_name")
            var insurance_application_form_id = $(this).data("insurance_application_form_id")
            return "<div class='list-group'><a class='list-group-item' onclick='return false' href='#'>Email</a><a class='list-group-item' data-behavior='InsuranceService.Behaviors.UpdatePopUp' data-company_name='" + company_name + "' data-company_id='" + company_id + "' data-app_id='" + app_id + "' data-insurance_application_form_id='" + insurance_application_form_id + "' onclick='return false' href='#'>Configure</a><a class='list-group-item' onclick='return false' href='#'>Delete</a></div>"
        }
    }).on('shown.bs.popover', function(shownEvent) {
        InsuranceService.applyBehaviors($('.popover-content'));
    }).on("mouseenter", function() {
        var _this = this;
        $(this).popover("show");
        $(".popover").on("mouseleave", function() {
            $(_this).popover('hide');
        });
    }).on("mouseleave", function() {
        var _this = this;
        setTimeout(function() {
            if (!$(".popover:hover").length) {
                $(_this).popover("hide");
            }
        }, 300);
    });
}

InsuranceService.applyBehaviors = function(scope) {
    $("[data-behavior]", scope).andSelf('[data-behavior]').each(function() {
        var $el = $(this);
        var behaviorsToApply = $el.attr('data-behavior').split(' ');
        $.each(behaviorsToApply, function(i, behaviorName) {
            name = behaviorName.split('.')[behaviorName.split('.').length - 1]
            if (!InsuranceService.Behaviors[name]) {
                throw name + " does not exist in InsuranceService.Behaviors";
            }
            InsuranceService.Behaviors[name]($el);
        });
    });
}