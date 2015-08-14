
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
	var $btn = $(btn);
	var url = $btn.data("url");
	var $form = $btn.parents(".upanel-from-login");

	var ub = 6;
	var un = zedk.panel._piu($form.find("input[name='un']").val(), ub);
	var up = zedk.panel._piu($form.find("input[name='up']").val(), ub);


	var fullPath = url + "?un=" + un + "&up=" + up + "&ub=" + ub;
	window.location.href = fullPath;
	return false;
};
// Шифровка на дурака
zedk.panel._piu = function(v, b) {
	// TODO: шифрование
	//return v << b;
	//return encrypt(v, b);
	return v;
};