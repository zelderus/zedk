


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
*	Статья
*
*/
shcoder.InitArticle = function(opts) {
 	
 	shcoder._codeHightLight();

};




/*
*
*	Подсветка
*
*/
shcoder._codeHightLight = function(opts) {
 	
 	//http://highlightjs.readthedocs.org/en/latest/api.html
	hljs.configure({
		useBR: true,
		tabReplace: '    ' // 4 spaces
	});
	$('pre code').each(function(i, block) {
		hljs.highlightBlock(block);
	});

};



/*
*
*	Редактирование
*
*/
// кастомные стили для редактора
// http://www.wysibb.com/docs/p3.html (https://github.com/wbb/wysibb/blob/master/jquery.wysibb.js)
// 
// При добавлении новых тэгов, также добавить во вьюшку логику к новому тэгу в файле 'views/shcoder/article.html.erb'
//
shcoder._bbcodeButtons = "bold,italic,underline,tt,ttr,|,h1,h2,h3,|,zlink,|,br,|,quote,codemark,|,minimarkbig,minimarksmall,|,back1,back2,|,code_ruby,code_sql,code_js,|,";
//
shcoder._bbcodeCustomTags = {
	h1: {
		hotkey: "ctrl+shift+4", //Add hotkey
      	title: 'large header',
      	buttonText: 'H1',
      	transform: {
        	'<div class="bbc_h1">{SELTEXT}</div>':'[h1]{SELTEXT}[/h1]'
      	}
    },
    h2: {
		title: 'header',
		buttonText: 'H2',
		transform: {
			'<div class="bbc_h2">{SELTEXT}</div>':'[h2]{SELTEXT}[/h2]'
		}
    },
    h3: {
		title: 'small header',
		buttonText: 'H3',
		transform: {
			'<div class="bbc_h3">{SELTEXT}</div>':'[h3]{SELTEXT}[/h3]'
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
		title: 'Text background',
		buttonText: 'tt',
		transform: {
			'<span class="bbc_tt">{SELTEXT}</span>':'[tt]{SELTEXT}[/tt]'
		}
    },
    ttr: {
		title: 'Text background red',
		buttonText: 'ttr',
		transform: {
			'<span class="bbc_ttr">{SELTEXT}</span>':'[ttr]{SELTEXT}[/ttr]'
		}
    },
    br: {
		title: 'new line',
		buttonText: 'BR',
		transform: {
			'<br>':'[_br]'
		}
    },
    zlink: {
		title: 'ancor',
		buttonHTML: '<span class="fonticon ve-tlb-link1">\uE007</span>',
		modal: {
			title: "Link",
			width: "600px",
			tabs: [
				{
					input: [ //List of form fields
						{param: "TITLE",title:"Enter link title", type: "div"},
						{param: "HREF",title:"Enter link URL ",validation: '^http(s)?://.*?\.'}
					]
				}
			],
			onLoad: function() {
				//Callback function that will be called after the display of a modal window
			},
			onSubmit: function() {
				//Callback function that will be called by pressing the "Save"
				//If function return false, it means sending data WysiBB not be made
			}
		},
		transform: {
			'<a href="{HREF}">{TITLE}</a>':'[zlnk={HREF}]{TITLE}[/zlnk]'
		}
    },
    minimarkbig: {
		title: 'Mini mark big',
		buttonText: 'MK"B',
		transform: {
			'<div class="bbc_minimark"><span class="bbc_minimark_block"> </span>{SELTEXT}</div>':'[minimark]{SELTEXT}[/minimark]'
		}
    },
    minimarksmall: {
		title: 'Mini mark small',
		buttonText: 'MK"S',
		transform: {
			'<div class="bbc_minimark_sm"><span class="bbc_minimark_block"> </span>{SELTEXT}</div>':'[minimarksm]{SELTEXT}[/minimarksm]'
		}
    },
    back1: {
		title: 'Background Green',
		buttonText: 'BG"G',
		transform: {
			'<div class="bbc_bg1"><span class="bbc_bg_text">{SELTEXT}</span></div>':'[bg1]{SELTEXT}[/bg1]'
		}
    },
    back2: {
		title: 'Background Yellow',
		buttonText: 'BG"Y',
		transform: {
			'<div class="bbc_bg2"><span class="bbc_bg_text">{SELTEXT}</span></div>':'[bg2]{SELTEXT}[/bg2]'
		}
    },

    code_ruby: {
		title: 'Code Ruby',
		buttonText: 'CODE"RB',
		transform: {
			'<pre><code class="ruby">{SELTEXT}</code></pre>':'[cd_rb]{SELTEXT}[/cd_rb]'
		}
    },
    code_sql: {
		title: 'Code SQL',
		buttonText: 'CODE"SQL',
		transform: {
			'<pre><code class="sql">{SELTEXT}</code></pre>':'[cd_sql]{SELTEXT}[/cd_sql]'
		}
    },
    code_js: {
		title: 'Code JS',
		buttonText: 'CODE"JS',
		transform: {
			'<pre><code class="js">{SELTEXT}</code></pre>':'[cd_js]{SELTEXT}[/cd_js]'
		}
    }

};
shcoder._editOpts = {};
shcoder.$editMain = null;
shcoder.InitEditor = function(opts) {
	shcoder._editOpts  = opts;
	shcoder.$editMain = $(".ShcEdit");
	//! Controls
	shcoder.$saveBtn = shcoder.$editMain.find("div[name='saveArticleBtn']");

	
	//! Events
	// сохранение
	$(window).keydown(function(event) {
		if (!(String.fromCharCode(event.which).toLowerCase() == 's' && event.ctrlKey) && !(event.which == 19)) return true;
		zedk.ui.BtnClick(shcoder.$saveBtn);	// save
		event.preventDefault();
		return false;
	});
	// событие на инпуты, при редактировании снимаем ошибку
	shcoder.$editMain.on("change", ".ShcEditInp", function(){
		shcoder.EditIputErrorMessage($(this), null, false);
	});

	//! Editor
	var wbbOpt = {
			buttons: shcoder._bbcodeButtons,
			allButtons: shcoder._bbcodeCustomTags 
		};
	$(".BodyArea").wysibb(wbbOpt);
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
 	var $inpCategoryTitle = $editMain.find("input[name='categoryTitle']");
 	var $inpCategory = $editMain.find("select[name='category']");

 	// data
 	dataSend = {
 		id: $inpId.val(),
 		title: $inpTitle.val(),
 		teaser: $inpTeaser.val(),
 		category: $inpCategoryTitle.val(),
 		categoryId: $inpCategory.val(),
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
 				$(".ShcEdit_Reader_Link").attr("href", model.href);
 				$(".ShcEdit_Reader_LinkWrapper").show();
 			}
 			// category
 			var newCatId = model.categoryId;
 			var newCatTitle = model.category;
 			shcoder._placeNewCategory(newCatId, newCatTitle, true);
 			$inpCategoryTitle.val("");

 			zedk.ui.BtnEnable(btn);
 		}, 
 		function(msg, model){
 			//console.log(model);
 			var errMsg = model != null ? model.message : "Ошибка запроса";
 			zedk.ui.BtnEnable(btn);
 			zedk.ui.Message(errMsg, true);
 			// show errors
 			shcoder._editShowErrors(model != null ? model.errors : null);
 		}
 	);
};
shcoder._placeNewCategory = function(newCatId, newCatTitle, isSelected) {
 	var $editMain = shcoder.$editMain;
 	var $inpCategory = $editMain.find("select[name='category']");
	var catIsNew = true;
	$inpCategory.find("option").each(function(i, v) {
		if ($(v).val() == newCatId){
			catIsNew = false;
			return false;
		}
	});
	if (catIsNew) {
		var $opt = $("<option>").attr("value", newCatId).html(newCatTitle);
		if (isSelected) $opt.attr("selected", "selected");
		$inpCategory.append($opt);
	}
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







