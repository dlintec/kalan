$(document).ready(function() {
    var editor = ace.edit("json");
    editor.setTheme("ace/theme/github");
    editor.session.setMode("ace/mode/json");
    editor.setFontSize(14);
    editor.$blockScrolling = Infinity;
    
    $("#submit_json").click(function() {
        try {
            $.ajax({
                method: "POST",
                contentType: 'application/json',
                url: "/" + $("#conn_name").val() + "/" + $("#db_name").val() + "/" + $("#coll_name").val() + "/" + $("#edit_request_type").val(),
                data: editor.getValue()
            })
            .success(function(msg) {
                show_notification(msg,"success");
            })
            .error(function(msg) {
                show_notification(msg.responseText,"danger");
            });
        }
        catch (err) {
            show_notification(err,"danger");
        }
    });
    
    // enable/disable submit button if errors
    editor.getSession().on("changeAnnotation", function(){
        var annot = editor.getSession().getAnnotations();
        if(annot.length > 0){
            $("#submit_json").prop('disabled', true);
            $("#queryDocumentsAction").prop('disabled', true);
        }else{
            $("#submit_json").prop('disabled', false);
            $("#queryDocumentsAction").prop('disabled', false);
        }
    });

    
    // prettify the json
    var jsonString = editor.getValue();
    var jsonPretty = JSON.stringify(JSON.parse(jsonString),null,2);
    editor.setValue(jsonPretty);
});