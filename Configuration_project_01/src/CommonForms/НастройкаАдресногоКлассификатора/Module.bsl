
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.СостояниеРегистра.Заголовок = ПолучитьСостояниеАдресногоКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеАдресногоКлассификатора" Тогда
		Элементы.СостояниеРегистра.Заголовок = ПолучитьСостояниеАдресногоКлассификатора();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьСостояниеАдресногоКлассификатора()
	
	ЧислоЗаполненныхАдресныхОбъектов = АдресныйКлассификатор.КоличествоЗагруженныхРегионов();
	Если ЧислоЗаполненныхАдресныхОбъектов > 0 Тогда
		Заголовок = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Объектов в адресном классификаторе: %1.'"),
							Строка(ЧислоЗаполненныхАдресныхОбъектов));
	Иначе
		Заголовок = НСтр("ru = 'Адресный классификатор не заполнен.'");
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

#КонецОбласти

