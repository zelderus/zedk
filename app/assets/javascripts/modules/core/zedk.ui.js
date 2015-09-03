
this.zedk = this.zedk || {};
this.zedk.data = this.zedk.data || {};
this.zedk.api = this.zedk.api || {};
this.zedk.ui = this.zedk.ui || {};


zedk.ui.About = function() {
	zedk.ConsoleGreen("ZEDK UI");
};


/*
*	Инициализация контролов на странице при загрузке.
*/
zedk.ui.InitOnPage = function() {
	zedk.ui._initMessage();
	zedk.ui._initButtons();

};

// инициализация кнопок
zedk.ui._initButtons = function() {
	$(".ctrl-btn").on("click", function(e) { 
		var $btn = $(this);
		return zedk.ui.BtnClick($btn);
	});
};

/*
*	Кнопки
*/
zedk.ui.BtnDisable = function(btn) {
	var $btn = $(btn);
	$btn.data("ui_disabled", 1);
	$btn.addClass("Disabled");
};
zedk.ui.BtnEnable = function(btn) {
	var $btn = $(btn);
	$btn.data("ui_disabled", 0);
	$btn.removeClass("Disabled");
};
zedk.ui.BtnIsEnable = function(btn) {
	var $btn = $(btn);
	var dis = $btn.data("ui_disabled");
	if (dis && dis == 1) return false;
	return true;
};
zedk.ui.BtnClick = function(btn) {
	var $btn = $(btn);
	//- если выключена, то не работаем
	if (!zedk.ui.BtnIsEnable($btn)) return;
	//- функция запуска
	var runMethod = $btn.data("run");
	if (!runMethod) return;
	//- выполняем
	return zedk.api.Execute(runMethod, window, $btn);
};

/*
*	Глобальное сообщение
*/
//zedk.ui.$_msg = null;
zedk.ui._initMessage = function() {
	//zedk.ui.$_msg = $(".gl-msg");
	//if (zedk.ui.$_msg.length == 0) zedk.ui.$_msg = null;
};

/**
*   SayAnimate
*   анимация мегафона
*/
if (!zedk.ui.SayAnimate) {
    zedk.ui.SayAnimate = function ($sayka, message, opacity) {
        $sayka.queue("say", function () { $(this).stop(true, true); });
        $sayka.queue("say", function () { $(this).empty().html(message).fadeTo(200, opacity); });
        $sayka.queue("say", function () { $(this).delay(2000); $sayka.dequeue("say"); });
        $sayka.queue("say", function () { $(this).fadeOut(200); });
        $sayka.dequeue("say").dequeue("say").dequeue("say");
    }
};
/**
*   Say
*   мегафон
*/
if (!zedk.ui.Say) {
    zedk.ui.Say = function (message, isError) {
        if (message == null || undefined || "") return false;
        var $sayHolder = null;
        /*var sayIsSlide = $(document).scrollTop() > 60;
        if (sayIsSlide) {
            $sayHolder = $(".gl-msg-slider"); //zedk.ui.$_msg;
        }
        else {
            $sayHolder = $(".gl-msg"); //zedk.ui.$_msg;
        }*/
        $sayHolder = $(".gl-msg-slider");

        if (isError) $sayHolder.addClass("Error");
        else $sayHolder.removeClass("Error");
        zedk.ui.SayAnimate($sayHolder, message, 0.8);
        return false;
    }
};
// отображение сообщения
zedk.ui.Message = function(msg, isError) {
	//if (zedk.ui.$_msg == null) return;
	zedk.ui.Say(msg, isError);
};