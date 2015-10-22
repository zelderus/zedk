
/*
*  
*  Zelder's Validators
*  2013
*/
this.zelder = this.zelder || {};
this.zelder.validators = this.zelder.validators || {};

/* 
*       about
*/
zelder.validators.about = zelder.validators.about || {
    title: "Validators",
    version: "1.0.1",
    builder: "ZeLDER",
    references: []
};



/*
    Функции:
    zelder.validators.IsNullOrEmpty(str)                            - Строка не содержит ничего.
    zelder.validators.Email(email)                                  - Эл. почта
    zelder.validators.ObjectHasNoEmptyProp(obj, props, invert, log)	- Проверка свойств объекта.
*/


zelder.validators.IsNullOrEmpty = function (/*string*/str) {
    ///	<summary>
    ///		Строка не содержит ничего.
    ///	</summary>
    ///	<returns type="Bool">Если пусто</returns>
    if (!str || str.match(/^ *$/) !== null) return true;
    else return false;
};

zelder.validators.Email = function (/*string*/email) {
    ///	<summary>
    ///		Проверка строки на корректность ввода электронной почты.
    ///	</summary>
    ///	<returns type="Bool">валидно</returns>
    var regex = /\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/;
    return regex.test(email);
};

zelder.validators.ObjectHasNoEmptyProp = function (/*object*/obj, /*string[]?*/props, /*bool?*/invert, /*ref string[]?*/log) {
    ///	<summary>
    ///		Все свойства объекта не пустые.
    ///	</summary>
    /// <param name="obj">Объект для проверки.</param>
    /// <param name="props">Массив строк с именами свойств для проверки. Не обязателен.</param>
    /// <param name="invert">Если false - в 'props' свойства для проверки, иначе в 'props' не обязательные свойства.</param>
    /// <param name="log">Массив строк свойств не прошедших валидацию. Следует передавать пустой массив [].</param>
    ///	<returns type="Bool">Если нет пустых свойств</returns>
    /// <exapmle>
    ///     // проверка всех свойств и запись не прошедших валидацию в массив 'logs'
    ///     var logs = [];
    ///     var succ = zelder.validators.ObjectHasNoEmptyProp(obj, [], true, logs);     // либо (obj, null, null, logs)
    ///     var succ2 = zelder.validators.ObjectHasNoEmptyProp(obj, ["name"]);          // проверка только свойства 'name'
    ///     var succ3 = zelder.validators.ObjectHasNoEmptyProp(obj, ["name"], true);    // проверка всех свойств, кроме 'name'
    /// </exapmle>
    var haveEmpty = false;
    var onlyProps = false;
    if (!invert) invert = false;
    if ($.isArray(props)) onlyProps = true;
    var haveLog = false;
    if (log != null) { haveLog = true; }
    if (!onlyProps) {   // проверка всех свойств
        for (var keyname in obj) {
            if (zelder.validators.IsNullOrEmpty(obj[keyname])) { haveEmpty = true; if (haveLog) log.push(keyname); else break; }
        }
    }
    else {              // проверка определенных свойств
        for (var keyname in obj) {
            if (invert) {
                if ($.inArray(keyname, props) < 0 && zelder.validators.IsNullOrEmpty(obj[keyname]))
                { haveEmpty = true; if (haveLog) log.push(keyname); else break; }
            }
            else {
                if ($.inArray(keyname, props) >= 0 && zelder.validators.IsNullOrEmpty(obj[keyname]))
                { haveEmpty = true; if (haveLog) log.push(keyname); else break; }
            }
        }
    }
    return !haveEmpty;
};
