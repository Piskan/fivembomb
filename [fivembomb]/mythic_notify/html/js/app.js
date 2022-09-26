var persistentNotifs = {};

window.addEventListener('message', function (event) {
    ShowNotif(event.data);
});

function CreateNotification(data) {
    document.getElementById("notifiydiyorum").style.right = "2%";

    var $notification = $(document.createElement('div'));
    $notification.addClass('notification').addClass(data.type);


    if (data.type === "success") {
    var text = "Basarılı"
    } else if (data.type === "inform") {
    var text = "Bilgilendirme"
    } else if (data.type === "error") {
    var text = "Hata"
    } else {
        var text = "Uyari"
    }

    $notification.html('\
    <h3 class="notification-title">' + text + '</h3>\
    <p class="notification-message">' + data.text + '</p>');
    $notification.fadeIn();
    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }


    return $notification;
}

function ShowNotif(data) {
    if (data.persist === undefined) {
        
        var $notification = CreateNotification(data);
        $('.notif-container').append($notification);
        setTimeout(function() {
            $.when($notification.fadeOut()).done(function() {
                $notification.remove()
            });
        }, data.length != null ? data.length : 2500);
    } else {
        if (data.persist.toUpperCase() == 'START') {
            if (persistentNotifs[data.id] === undefined) {
                document.getElementById("notifiydiyorum").style.right = "2%";

                var $notification = CreateNotification(data);
                $('.notif-container').append($notification);
                persistentNotifs[data.id] = $notification;
                setTimeout(function() {
                    document.getElementById("notifiydiyorum").style.right = "-330px";
                }, 4000);
            } else {
                document.getElementById("notifiydiyorum").style.right = "2%";

                let $notification = $(persistentNotifs[data.id])
                $notification.addClass('notification').addClass(data.type);
                $notification.html('\
                <h3 class="notification-title">Bilgilendirme</h3>\
                <p class="notification-message">' + data.text + '</p>');

                if (data.style !== undefined) {
                    Object.keys(data.style).forEach(function(css) {
                        $notification.css(css, data.style[css])
                    });
                }
                setTimeout(function() {
                    document.getElementById("notifiydiyorum").style.right = "-330px";
                }, 4000);
            }
        } else if (data.persist.toUpperCase() == 'END') {
            let $notification = $(persistentNotifs[data.id]);
            $.when($notification.fadeOut()).done(function() {
                $notification.remove();
                delete persistentNotifs[data.id];
            });
        }
    }
}