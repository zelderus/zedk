


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
// кастомные стили для редактора
// http://www.wysibb.com/docs/p3.html
shcoder._bbcodeCustomTags = {
	code: {
      hotkey: "ctrl+shift+3", //Add hotkey
      transform: {
        '<div class="mycode"><div class="codetop">Code:</div><div class="codemain">{SELTEXT}</div></div>':'[code]{SELTEXT}[/code]'
      }
    },
    codemark: {
      title: 'Insert codemark',
      buttonText: 'codemark',
      transform: {
        '<div class="bbc_codemark">{SELTEXT}</div>':'[codemark]{SELTEXT}[/codemark]'
      }
    },
    tt: {
      title: 'TT',
      buttonText: 'tt',
      transform: {
        '<span class="bbc_tt">{SELTEXT}</span>':'[tt]{SELTEXT}[/tt]'
      }
    },
    br: {
      title: 'new line',
      buttonText: 'BR',
      transform: {
        '<br>':'[_br][/_br]'
      }
    }
};
shcoder._editOpts = {};
shcoder.$editMain = null;
shcoder.InitEditor = function(opts) {
	shcoder._editOpts  = opts;
	shcoder.$editMain = $(".ShcEdit");

	//! Editor
	var wbbOpt = {
			buttons: "bold,italic,underline,|,img,link,|,quote,codemark,tt,|,br",
			allButtons: shcoder._bbcodeCustomTags 
		};
	$(".BodyArea").wysibb(wbbOpt);

	//! Events
	// событие на инпуты, при редактировании снимаем ошибку
	shcoder.$editMain.on("change", ".ShcEditInp", function(){
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
 		text: $inpText.bbcode()	//$inpText.html()
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







