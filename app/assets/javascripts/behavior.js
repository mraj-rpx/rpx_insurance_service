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

InsuranceService.Behaviors.AdminGearPopover = function(element) {
    $(element).popover({
        trigger: "manual",
        html: true,
        animation: false,
        content: function() {
            var app_id = $(this).data("app_id")
            return "<div class='list-group'><a class='list-group-item' href='#'>Email</a><a class='list-group-item' href='#'>Configure</a><a class='list-group-item' href='#'>Delete</a></div>"
        }
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