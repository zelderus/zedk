


this.shcoder = this.shcoder || {};



/*
*
*	Init
*
*/
shcoder.Init = function(opts) {
 	
	
	

};




/*
*
*	Редактирование
*
*/
shcoder._editOpts = {};
shcoder.$editMain = null;
shcoder.InitEditor = function(opts) {
	shcoder._editOpts  = opts;
	shcoder.$editMain = $(".ShcEdit");

	//! Events
	// событие на инпуты, при редактировании снимаем ошибку
	shcoder.$editMain.find(".ShcEditInp").on("change", function(){
		shcoder.EditIputErrorMessage($(this), null, false);
	});
};


shcoder.Edit = function(t, btn) {
 	var url = shcoder._editOpts.urlEdit;
 	//- btn
 	zedk.ui.BtnDisable(btn);
 	//- controls
 	var $editMain = shcoder.$editMain;
 	var $inpId = $editMain.find("input[name='id']");
 	var $inpTitle = $editMain.find("input[name='title']");
 	var $inpTeaser = $editMain.find("input[name='teaser']");
 	var $inpText = $editMain.find("textarea[name='text']");
 	// data
 	dataSend = {
 		id: $inpId.val(),
 		title: $inpTitle.val(),
 		teaser: $inpTeaser.val(),
 		text: $inpText.val()
 	};
 	//! отправляем
 	zedk.api.Post(
 		url, 
 		dataSend, 
 		function(model){
 			zedk.ui.Message(model.message, false);
 			// updates
 			if (model.isnew){
 				$inpId.val(model.id);
 			}
 			zedk.ui.BtnEnable(btn);
 		}, 
 		function(msg, model){
 			var errMsg = model != null ? model.message : "Ошибка запроса";
 			zedk.ui.BtnEnable(btn);
 			zedk.ui.Message(errMsg, true);
 			// show errors
 			shcoder._editShowErrors(model != null ? model.errors : null);
 		}
 	);
};
shcoder._editShowErrors = function(errors) {
	if (!errors || errors == null) return;
 	//- controls
 	var $editMain = shcoder.$editMain;
 	// отображение ошибки у инпутов
 	for (keyname in errors) {
 		var k = keyname;
 		var v = errors[k];
 		var $inp = $editMain.find(".ShcEditInp[name='" +k+ "']");
 		shcoder.EditIputErrorMessage($inp, v, true);
 	}
};
// Отображение/Скрытие ошибки у инпута формы
shcoder.EditIputErrorMessage = function(inp, msg, isShow) {
	var $inp = $(inp);
	if ($inp.length == 0) return;
	var $p = $inp.parents(".ShcEdit_Line");
	if (isShow) $p.addClass("Error"); else $p.removeClass("Error");
	$p.find(".ShcEdit_Line_Error").html(msg?msg:"");
};







