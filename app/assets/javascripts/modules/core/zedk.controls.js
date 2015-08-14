
this.zedk = this.zedk || {};
this.zedk.data = this.zedk.data || {};
this.zedk.api = this.zedk.api || {};
this.zedk.controls = this.zedk.controls || {};


zedk.controls.About = function() {
	zedk.ConsoleGreen("ZEDK Controls");
};


/*
*	Инициализация контролов на странице при загрузке.
*/
zedk.controls.InitOnPage = function() {
	zedk.controls._initButtons();

};



// инициализация кнопок
zedk.controls._initButtons = function() {
	$(".ctrl-btn").on("click", function(e) { 
		var $btn = $(this);
		var runMethod = $btn.data("run");
		if (!runMethod) return;
		return zedk.api.Execute(runMethod, window, this);
	});
};