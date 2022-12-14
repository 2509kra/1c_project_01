#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипВыражения", ТипВыражения);
	
	Инструкция = "<html>
	|<style type=""text/css"">
	|	body {
	|		overflow:    auto;
	|		margin-top:  12px; 		 
	|		margin-left: 20px; 
	|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif; 
	|		font-size:   8pt;}
	|	table {
	|		width:       270px;  
	|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif; 
	|		font-size:   8pt;}
	|	td {vertical-align: top;}
	|	p {
	|		margin-top: 7px;}
	|</style>
	|<body>";
	
	Если ТипВыражения = "ПравилоВыгрузки"
		Или ТипВыражения = "ПравилоЗагрузки" Тогда
		
		Заголовок = НСтр("ru = 'Выражение на встроенном языке'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru = 'Результат вычисления выражения на встроенном языке 1С:Предприятия
			|должен присваиваться свойству <b>Результат</b> переменной <b>Параметры</b>.'");
			
		Если Параметры.ЭтоТаблица Тогда
			Инструкция = Инструкция + 
				НСтр("ru = 'Для заполнения таблицы результат должен иметь тип <b>ТаблицаЗначений</b>,
				|а имена колонок - совпадать с именами колонок заполняемой таблицы.'");
		ИначеЕсли ТипВыражения = "ПравилоВыгрузки" Тогда
			Инструкция = Инструкция + 
				НСтр("ru = 'Для установки ссылочного значения на стороне 1С:Документооборота
				|свойству <b>РезультатТип</b> следует присвоить строку с названием типа согласно
				|описанию веб-сервиса, а свойству <b>РезультатID</b> - идентификатор ссылки
				|или имя значения перечисления. Свойству <b>Результат</b> в этом случае присваивается
				|пользовательское представление результата.'");
		КонецЕсли;
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриВыгрузке" Тогда
			
		Заголовок = НСтр("ru = 'Условие применимости правила'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru = 'Выражение на встроенном языке 1С:Предприятия определяет
			|применимость правила при создании объекта 1С:Документооборота на основании 
			|объекта этой конфигурации. Результат вычисления должен присваиваться свойству
			|<b>Результат</b>. <b>Истина</b> означает применимость правила, <b>Ложь</b> – неприменимость.
			|Выражение проверяется только для правил, подходящих по значениям ключевых реквизитов.
			|</p><p>Значение по умолчанию: <b>Истина</b>.'") + "<p>";
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		
		Заголовок = НСтр("ru = 'Условие применимости правила'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru = 'Выражение на встроенном языке 1С:Предприятия определяет
			|применимость правила при создании объекта этой конфигурации на основании 
			|объекта 1С:Документооборота. Результат вычисления должен присваиваться свойству
			|<b>Результат</b>. <b>Истина</b> означает применимость правила, <b>Ложь</b> – неприменимость.
			|Выражение проверяется только для правил, подходящих по значениям ключевых реквизитов.
			|</p><p>Значение по умолчанию: <b>Истина</b>.'") + "<p>";
		
	КонецЕсли;
	
	Инструкция = Инструкция + "<p>" + НСтр("ru ='К объекту'") + " ";
	
	Если ТипВыражения = "ПравилоЗагрузки"
		Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		
		Инструкция = Инструкция + НСтр("ru = '1С:Документооборота'");
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаДО(Параметры.ТипОбъектаДО);
		
	Иначе // ПравилоВыгрузки, УсловиеПрименимостиПриВыгрузке
		
		Инструкция = Инструкция + НСтр("ru = 'этой конфигурации'");
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаИС(Параметры.ТипОбъектаИС);
			
	КонецЕсли;
		
	Инструкция = Инструкция + " " + 
		НСтр("ru = 'можно обращаться через свойство <b>Источник</b> переменной <b>Параметры</b>.
		|Реквизиты источника:'") 
		+ "</p><table>";
		
	Если (ТипВыражения = "ПравилоЗагрузки"
		Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
		СоставРеквизитов.Сортировать("ЭтоТаблица, ДопРеквизит, Имя");
	Иначе
		СоставРеквизитов.Сортировать("ЭтоТаблица, ЭтоДополнительныйРеквизитИС, Имя");
	КонецЕсли;
	
	ВыведенЗаголовокДопРеквизитов = Ложь;
	
	Для Каждого СтруктураРеквизита из СоставРеквизитов Цикл
		
		Если ЗначениеЗаполнено(СтруктураРеквизита.Таблица) Тогда
			Продолжить;
		КонецЕсли;
		
		Если (ТипВыражения = "ПравилоЗагрузки"
			Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
			ЭтоДопРеквизит = СтруктураРеквизита.ДопРеквизит;
		Иначе
			ЭтоДопРеквизит = СтруктураРеквизита.ЭтоДополнительныйРеквизитИС;
		КонецЕсли;
		
		Если ЭтоДопРеквизит
			И Не ВыведенЗаголовокДопРеквизитов Тогда
			Инструкция = Инструкция + "<tr><td>";
			Инструкция = Инструкция + "<b>" + НСтр("ru = 'Дополнительные реквизиты:'") + "</b>";
			Инструкция = Инструкция + "</tr></td>";
			ВыведенЗаголовокДопРеквизитов = Истина;
		КонецЕсли;
			
		Если СтруктураРеквизита.ЭтоТаблица Тогда
			Инструкция = Инструкция + "<tr><td>";
			Инструкция = Инструкция + "<b>" + СтруктураРеквизита.Имя + "</b>";
			Инструкция = Инструкция + "</tr></td>";
			РеквизитыТаблицы = СоставРеквизитов.НайтиСтроки(Новый Структура("Таблица", СтруктураРеквизита.Имя));
			Для Каждого РеквизитТаблицы Из РеквизитыТаблицы Цикл
				Инструкция = Инструкция + "<tr><td>" + РеквизитТаблицы.Имя + "</td>";
				Если РеквизитТаблицы.Представление <> РеквизитТаблицы.Имя Тогда
					Инструкция = Инструкция + "<td>" + РеквизитТаблицы.Представление + "</td>";
				КонецЕсли;
				Инструкция = Инструкция + "</tr>";
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		Если ЭтоДопРеквизит Тогда
			Если (ТипВыражения = "ПравилоЗагрузки"
				Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
				ИмяРеквизита = СтрШаблон(НСтр("ru = 'УИД: ""%1""'"), СтруктураРеквизита.ДопРеквизитID);
			Иначе
				ИмяРеквизита = СтрШаблон(НСтр("ru = 'УИД: ""%1""'"), СтруктураРеквизита.Имя);
			КонецЕсли;
		Иначе
			ИмяРеквизита = СтруктураРеквизита.Имя;
		КонецЕсли;
		
		Инструкция = Инструкция + "<tr>";
		Если ТипЗнч(СтруктураРеквизита.Тип) = Тип("СписокЗначений")
			И СтруктураРеквизита.Тип.Количество() > 0
			И Лев(СтруктураРеквизита.Тип[0], 2) = "DM" Тогда
			Инструкция = Инструкция + "<td><a href=""#" + СтруктураРеквизита.Тип[0] + """>" 
				+ ИмяРеквизита + "</a></td>";
		Иначе
			Инструкция = Инструкция + "<td>" + ИмяРеквизита + "</td>";
		КонецЕсли;
		Если СтруктураРеквизита.Представление <> ИмяРеквизита Тогда
			Инструкция = Инструкция + "<td>" + СтруктураРеквизита.Представление + "</td>";
		КонецЕсли;
		Инструкция = Инструкция + "</tr>";
		
	КонецЦикла;
	
	Инструкция = Инструкция + "</table>";
	
	Инструкция = Инструкция + "</body></html>";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОчистить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОчиститьЗавершение", ЭтаФорма);
	ТекстВопроса = НСтр("ru = 'Вы действительно хотите очистить введенное выражение?'");
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(ВычисляемоеВыражение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РеквизитыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.HRef) Тогда
		Возврат;
	КонецЕсли;
	
	Позиция = СтрНайти(ДанныеСобытия.HRef, "#", НаправлениеПоиска.СКонца);
	Ссылка = Сред(ДанныеСобытия.HRef, Позиция + 1);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", Ссылка);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ОписаниеВебСервисов", 
		ПараметрыФормы, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчиститьЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть("");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти