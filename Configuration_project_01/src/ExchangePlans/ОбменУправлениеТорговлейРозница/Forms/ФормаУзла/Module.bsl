
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ЭтотУзел Тогда
		Элементы.ПравилаОтправкиДанных.Видимость = Ложь;
		Элементы.ПравилаПолученияДанных.Видимость = Ложь;
		Элементы.СтраницыФормы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
			
	Элементы.Кассы.Видимость 		= Объект.ИспользоватьОтборПоКассам;
	Элементы.ВидыЦен.Видимость		= Объект.ИспользоватьОтборПоВидамЦен;
	Элементы.Организации.Видимость	= Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.Соглашение.Видимость 	= ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
