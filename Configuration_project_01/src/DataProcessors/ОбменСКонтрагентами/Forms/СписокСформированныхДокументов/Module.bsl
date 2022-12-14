#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
	ДокументОснование = Неопределено;
		
	Если Параметры.Свойство("ДокументОснование", ДокументОснование) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Документы, "ДокументОснование", ДокументОснование, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		Иначе
			Отказ = Истина
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТекущиеДелаЭДО" Тогда
		Элементы.Документы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	ОбменСКонтрагентамиСлужебныйКлиент.ОтправитьПечатнуюФормуПоЭДО(ДокументОснование);
КонецПроцедуры

&НаКлиенте
Процедура Посмотреть(Команда)
	ТекущиеДанные = Элементы.Документы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти
