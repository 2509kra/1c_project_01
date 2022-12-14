
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	УправлениеЭлементамиФормы();
	
	Элементы.ОрганизацияПродавец.ТолькоПросмотр = ЗначениеЗаполнено(Запись.ОрганизацияПродавец);
	Элементы.ОрганизацияВладелец.ТолькоПросмотр = ЗначениеЗаполнено(Запись.ОрганизацияВладелец);
	Элементы.ТипЗапасов.ТолькоПросмотр          = ЗначениеЗаполнено(Запись.ТипЗапасов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Запись);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОписаниеОповещенияОЗакрытии = Неопределено;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособПередачиТоваровПриИзменении(Элемент)
	
	СпособПередачиТоваровПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.СпособПередачиТоваровПередачаНаКомиссию.Видимость = (Запись.ТипЗапасов <> Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи);
	
	Элементы.Валюта.ТолькоПросмотр 			  = (Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию);
	Элементы.Валюта.ОтметкаНезаполненного 	  = (Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию);
	Элементы.Валюта.АвтоОтметкаНезаполненного = (Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию);
	
	Элементы.ВидЦены.ТолькоПросмотр = (Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается);
	Элементы.Договор.ТолькоПросмотр = (Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается);
	
	Если Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.НеПередается Тогда
		МассивПараметров = Новый Массив;
		
		Если Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию Тогда
			ПараметрВыбораДоговора = Новый ПараметрВыбора("Отбор.ТипДоговора", Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный);
		Иначе
			ПараметрВыбораДоговора = Новый ПараметрВыбора("Отбор.ТипДоговора", Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа);
		КонецЕсли;
		МассивПараметров.Добавить(ПараметрВыбораДоговора);
		
		ПараметрВыбораДоговора = Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь);
		МассивПараметров.Добавить(ПараметрВыбораДоговора);
		
		ПараметрВыбораДоговора = Новый ПараметрВыбора("Отбор.Статус", ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует"));
		МассивПараметров.Добавить(ПараметрВыбораДоговора);
		
		Элементы.Договор.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров); 
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура СпособПередачиТоваровПриИзмененииСервер()
	
	Если Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию Тогда
		Запись.Валюта = Неопределено;
	КонецЕсли;
	
	Если Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается Тогда
		Запись.ВидЦены = Неопределено;
	КонецЕсли;
	
	Запись.Договор = Неопределено;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
