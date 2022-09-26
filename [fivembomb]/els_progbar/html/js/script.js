var cancelledTimer = null;

$('document').ready(function() {
    PWProgBar = {};

    PWProgBar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label);

        $(".progress-container").fadeIn('fast', function() {
            $("#progress-bar").stop().css({"width": 0, "background-color": "rgba(0, 0, 0, 0.75)"}).animate({
              width: '100%'
            }, {
              duration: parseInt(data.duration),
              complete: function() {
                $(".progress-container").fadeOut('fast', function() {
                    $('#progress-bar').removeClass('cancellable');
                    $("#progress-bar").css("width", 0);
                    $.post('http://els_progbar/actionFinish', JSON.stringify({
                        })
                    );
                })
              }
            });
        });
    };

    PWProgBar.ProgressCancel = function() {
        $("#progress-label").text("CANCELLED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "rgba(71, 0, 0, 0.8)"});
        $('#progress-bar').removeClass('cancellable');

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
                $.post('http://els_progbar/actionCancel', JSON.stringify({
                    })
                );
            });
        }, 1000);
    };

    PWProgBar.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'pw_progress':
                PWProgBar.Progress(event.data);
                break;
            case 'pw_progress_cancel':
                PWProgBar.ProgressCancel();
                break;
        }
    });
});