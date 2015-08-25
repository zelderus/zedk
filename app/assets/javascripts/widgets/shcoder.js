


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
shcoder.InitEditor = function(opts) {
	shcoder._editOpts  = opts;
	

};


shcoder.Edit = function() {
 	var url = shcoder._editOpts.urlEdit;
 	// TODO:
 	dataSend = {
 		id: $("input[name='id']").val(),
 		title: $("input[name='title']").val(),
 		teaser: $("input[name='teaser']").val(),
 		text: $("textarea[name='text']").val()
 	};


 	// отправляем
 	zedk.api.Post(
 		url, 
 		dataSend, 
 		function(model){
 			console.log(model);
 		}, 
 		function(msg, model){
 			console.log(model);
 		}
 	);

};









