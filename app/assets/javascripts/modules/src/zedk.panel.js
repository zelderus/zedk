
this.zedk = this.zedk || {};
this.zedk.data = this.zedk.data || {};
this.zedk.panel = this.zedk.panel || {};


/***************************************************************************
*
*	Работа с Панелью сайта.
*
*
****************************************************************************/


zedk.panel.About = function() {
	zedk.ConsoleGreen("ZEDK Panel");
};


// Авторизация. С шифровкой от дурака
zedk.panel.UserLoginFromForm = function(btn) {
	//! Dont work, just do form
	//return true;
	//! Dont work, just do form

	var $btn = $(btn);
	var $form = $btn.parents(".upanel-from-login");
	// datas
	var ub = Math.floor((Math.random() * 100) + 1);
	var un = zedk.panel._piu($form.find("input[name='un']").val(), ub);
	var up = zedk.panel._piu($form.find("input[name='up']").val(), ub);
	// place
	$form.find("input[name='un2']").val(un);
	$form.find("input[name='up2']").val(up);
	$form.find("input[name='ub']").val(ub);
	// clear
	$form.find("input[name='up']").val("");
	// do form
	return true;

	//var url = $btn.data("url");
	// by GET
	//var fullPath = url + "?un=" + un + "&up=" + up + "&ub=" + ub;
	//window.location.href = fullPath;

	// by POST (некоторые браузеры ругаются, мол не безопасно)
	/*$.ajax({
		type: 'POST',
		url: url,
		data: { un: un, up: up, ub: ub },
		async:false
	});*/
	//return false;
};
// Шифровка на дурака
zedk.panel._piu = function(v, b) {
	// TODO: шифрование
	//return encrypt(v, b);
	return v;
};

/*
*	Поиск по сайту
*/
zedk.panel.Search = function(btn) {
	var $btn = $(btn);

	var link = $btn.data("link");
	var txt = $btn.val();

	var minSymb = 3;
	if (txt.length < minSymb){
		zedk.Debug("Запрос слишком короткий. Необходимо минимум символов в строке поиска: " + minSymb);
		zedk.ui.Message("Слишком короткий запрос", true);
		// анимация инпута
		var bgc = $btn.css("background-color");
		$btn
			.animate({ backgroundColor: "#aa0000"}, 500 )
			.animate({ backgroundColor: bgc }, 500 );

		return false;
	}

	var fullPath = link + "?txt=" + txt;
	window.location.href = fullPath;

};

