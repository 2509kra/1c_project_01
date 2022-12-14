
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.ЗакрыватьПриВыборе            = Истина;
	Параметры.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Объект = Параметры.Объект;
	Организация = Объект.Организация;
	Параметры.Свойство("ЮрФизЛицо", ЮрФизЛицо);
	ПрочийРасход = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств;
	
	ИНН = Объект.ИННПлательщика;
	КПП = Объект.КПППлательщика;
	ТекстКорреспондента = Объект.ТекстПлательщика;
	
	АвтоЗначенияРеквизитов = ДенежныеСредстваСервер.РеквизитыПлательщика(Объект);
	
	Если ЗначениеЗаполнено(АвтоЗначенияРеквизитов.ИННПлательщика) Тогда
		Элементы.ИНН.СписокВыбора.Добавить(АвтоЗначенияРеквизитов.ИННПлательщика);
	КонецЕсли;
	
	ЗаполнитьКПП();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность И Не Готово Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"), 
			СписокКнопок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Закрыть" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершеноРедактированиеРегистраций" Тогда
		ЗаполнитьКПП();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИННОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПриОкончанииВводаИНН(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура КППОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПриОкончанииВводаКПП(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура КППОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		КПП = ВыбранноеЗначение;
	Иначе
		РегистрацияВНалоговомОргане = ВыбранноеЗначение;
		Регистрация = СписокКПП.НайтиПоЗначению(ВыбранноеЗначение);
		Если Регистрация <> Неопределено Тогда
			КПП = Регистрация.Представление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	РегистрацияВНалоговомОргане = Неопределено;
	Для каждого ЭлементСписка Из СписокКПП Цикл
		Если ЭлементСписка.Представление = КПП Тогда
			РегистрацияВНалоговомОргане = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияВНалоговомОрганеСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("ОсновнаяРегистрация", Неопределено);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаНастройкиРегистраций", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если Не Модифицированность Или ТолькоПросмотр Тогда
		Закрыть();
	Иначе
		СтруктураОбъекта = Новый Структура;
		СтруктураОбъекта.Вставить("ИННПлательщика",               ИНН);
		СтруктураОбъекта.Вставить("КПППлательщика",               КПП);
		СтруктураОбъекта.Вставить("ТекстПлательщика",             ТекстКорреспондента);
		СтруктураОбъекта.Вставить("РегистрацияВНалоговомОргане",  РегистрацияВНалоговомОргане);
		
		Готово = Истина;
		ОповеститьОВыборе(СтруктураОбъекта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКПП()
	
	СписокКПП.Очистить();
	
	СписокВыбораКПП = Элементы.КПП.СписокВыбора;
	СписокВыбораКПП.Очистить();
	
	СписокКППОрганизации = ДенежныеСредстваСервер.СписокКППОрганизации(Организация);
	Для каждого КППОрганизации Из СписокКППОрганизации Цикл
		Представление = КППОрганизации.КПП + ?(ЗначениеЗаполнено(КППОрганизации.Подразделение), " (" + СокрЛП(КППОрганизации.Подразделение) + ")", "");
		СписокВыбораКПП.Добавить(КППОрганизации.Ссылка, Представление);
		СписокКПП.Добавить(КППОрганизации.Ссылка, КППОрганизации.КПП);
	КонецЦикла;
	
	Элементы.КПП.КнопкаСоздания = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииВводаИНН(ТекстРедактирования)
	
	Перем ТекстСообщения;
	
	Если ПрочийРасход Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоЮрЛицо = ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		Или ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
	ОчиститьСообщения();
	
	Если Не ПустаяСтрока(ТекстРедактирования) 
		И Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ТекстРедактирования, 
			ЭтоЮрЛицо,
			ТекстСообщения) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ИНН",,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииВводаКПП(ТекстРедактирования)
	
	Перем ТекстСообщения;
	ОчиститьСообщения();
	
	Если Не ПустаяСтрока(ТекстРедактирования)
		И ТекстРедактирования <> "0"
		И Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(ТекстРедактирования, ТекстСообщения) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"КПП",,);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
