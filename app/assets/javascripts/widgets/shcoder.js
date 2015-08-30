


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

	// TODO: событие на инпуты, при редактировании снимаем ошибку

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
 			console.log(model);
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
 	var $inpId = $editMain.find("input[name='id']");
 	var $inpTitle = $editMain.find("input[name='title']");
 	var $inpTeaser = $editMain.find("input[name='teaser']");
 	var $inpText = $editMain.find("textarea[name='text']");

 	// TODO: отображение ошибки у инпутов
 	console.log(errors);

};








