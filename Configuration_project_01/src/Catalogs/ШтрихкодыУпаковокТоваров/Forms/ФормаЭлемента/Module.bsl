&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
		// Обработчик подсистемы запрета редактирования реквизитов объектов
		МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеФормой(ЭтотОбъект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
		// Обработчик подсистемы запрета редактирования реквизитов объектов
		МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтаФорма, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипУпаковкиПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУпаковкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере(КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшЗначений)
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ХарактеристикиИспользуются = Ложь;
		СерииИспользуются = Ложь;
	Иначе
		ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
		СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	КонецЕсли;
	
	Шапка = Новый Структура("Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Упаковка,
		|Количество, КоличествоУпаковок, ХарактеристикиИспользуются, ТипНоменклатуры, МаркируемаяПродукция, ЕдиницаИзмерения");
	ЗаполнитьЗначенияСвойств(Шапка, Объект);
	
	ПараметрыЗаполнения = ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ОбработатьУпаковки = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, Шапка, Неопределено, ПараметрыЗаполнения, ПараметрыУказанияСерий);
	
	ЗаполнитьЗначенияСвойств(Объект, Шапка);
	
	СобытияФормИСПереопределяемый.УстановитьИнформациюОЕдиницеХранения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере(КэшЗначений)
	
	ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшЗначений);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗаблокированныеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.Реквизиты(ЭтотОбъект);
	
	Если ЗаблокированныеРеквизиты.Количество() > 0 Тогда
		
		ОповещениеРазрешения = Новый ОписаниеОповещения(
			"Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение",
			ЭтотОбъект);
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(
			ЭтотОбъект,
			ОповещениеРазрешения);
		
	Иначе
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.ПоказатьПредупреждениеВсеВидимыеРеквизитыРазблокированы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораРеквизитовДляРазблокирования(РезультатРазблокировки, Контекст) Экспорт
	
	Если РезультатРазблокировки <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЗаблокированныеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.Реквизиты(ЭтотОбъект);
	ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(
		ЭтотОбъект,
		ЗаблокированныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьШтрихкод(Команда)
	
	ЗаполнитьКоличествоНаСервере();
	
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("ТипУпаковки",    Объект.ТипУпаковки);
	ПередаваемыеПараметры.Вставить("ТипШтрихкода",   Объект.ТипШтрихкода);
	ПередаваемыеПараметры.Вставить("Номенклатура",   Объект.Номенклатура);
	ПередаваемыеПараметры.Вставить("Характеристика", Объект.Характеристика);
	ПередаваемыеПараметры.Вставить("ДатаМаркировки", Объект.ДатаУпаковки);
	Если ЗначениеЗаполнено(Объект.ЗначениеШтрихкода) Тогда
		ПередаваемыеПараметры.Вставить("Штрихкод",   Объект.ЗначениеШтрихкода);
	КонецЕсли;
	ПередаваемыеПараметры.Вставить("КоличествоВложенныхЕдиниц", Объект.Количество);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаГенерацииШтрихкода", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ГенерацияШтрихкодовУпаковок.Форма", ПередаваемыеПараметры, ЭтотОбъект, УникальныйИдентификатор,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеИСКлиент.ПоказатьВводШтрихкода(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ДанныеШтрихкодов = Новый Массив;
	ДанныеШтрихкодов.Добавить(ДанныеШтрихкода);
	ОбработатьШтрихкоды(ДанныеШтрихкодов);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(
		ЭтаФорма,, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(РазрешениеПолучено, ДополнительныеПараметры) Экспорт
	
	Если РазрешениеПолучено Тогда
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоличествоНаСервере()
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	СправочникОбъект.РассчитатьКоличествоВложенныхШтрихкодов();
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкодыНаКлиенте(ДанныеШтрихкодов, Отказ)
	
	НеСериализуемыйСимвол = ШтрихкодыУпаковокКлиентСервер.СимволОкончанияСтрокиПеременнойДлины();
	
	Для каждого ДанныеШК Из ДанныеШтрихкодов Цикл
		
		Штрихкод = ДанныеШК.Штрихкод;
		Если СтрНайти(Штрихкод, НеСериализуемыйСимвол) <> 0 Тогда
			
			РезультатЧтения = ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкода(Штрихкод);
			
			Если НЕ РезультатЧтения.Результат = Неопределено
				И (РезультатЧтения.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
					ИЛИ РезультатЧтения.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked")) Тогда
				
				ДанныеШК.Штрихкод = ШтрихкодыУпаковокКлиентСервер.ШтрихкодGS1(РезультатЧтения.Результат, Истина);
				
			ИначеЕсли РезультатЧтения.Результат = Неопределено Тогда
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЧтения.ТекстОшибки,,,,Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыНаСервере(ДанныеШтрихкодов, КэшированныеЗначения)
	
	Отказ = Ложь;
	
	Штрихкоды = ОбщегоНазначения.СкопироватьРекурсивно(ДанныеШтрихкодов);
	СписокШтрихкодовУпаковок = Новый Массив;
	Для каждого ЭлементДанных Из Объект.ВложенныеШтрихкоды Цикл
		СписокШтрихкодовУпаковок.Добавить(ЭлементДанных.Штрихкод);
	КонецЦикла;
	
	ПараметрыОбработкиШтрихкода = ШтрихкодированиеИС.ПараметрыСканирования(ЭтотОбъект);
	ПараметрыОбработкиШтрихкода.СоздаватьШтрихкодУпаковки = Истина;
	РезультатЧтенияШтрихкодов = ШтрихкодированиеИС.ДанныеПоШтрихкодам(Штрихкоды, ПараметрыОбработкиШтрихкода, КэшированныеЗначения);
	
	ПрочитанныеШтрихкоды = Новый Соответствие;
	ДобавляемыеШтрихкоды = Новый Массив;
	Для Каждого ЭлементДанных Из ДанныеШтрихкодов Цикл
		
		РазобраннаяСтрока = РезультатЧтенияШтрихкодов.ДанныеКодовМаркировки.Найти(ЭлементДанных.Штрихкод, "Штрихкод");
		Если РазобраннаяСтрока = Неопределено
			И РезультатЧтенияШтрихкодов.ДанныеКодовМаркировки.Количество() > 0
			И РезультатЧтенияШтрихкодов.ДанныеКодовМаркировки[0].Входящий Тогда
			РазобраннаяСтрока = РезультатЧтенияШтрихкодов.ДанныеКодовМаркировки[0];
		КонецЕсли;
		
		Если РазобраннаяСтрока = Неопределено
			Или Не ЗначениеЗаполнено(РазобраннаяСтрока.ШтрихкодУпаковки) Тогда
			ТекстСообщения = НСтр("ru = 'Упаковка или маркированный товар со штрихкодом ""%1"" не найден'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ЭлементДанных.Штрихкод);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		Иначе
			ДобавляемыеШтрихкоды.Добавить(РазобраннаяСтрока.ШтрихкодУпаковки);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из РезультатЧтенияШтрихкодов.ДанныеКодовМаркировки Цикл
		Если ЗначениеЗаполнено(СтрокаДанных.ШтрихкодУпаковки) Тогда
			ПрочитанныеШтрихкоды.Вставить(СтрокаДанных.Штрихкод, СтрокаДанных.ШтрихкодУпаковки);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыСканирования = ШтрихкодированиеИС.ПараметрыСканирования(ЭтотОбъект);
	Результат = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(СписокШтрихкодовУпаковок, ПараметрыСканирования);
	ДеревоУпаковок = Результат.ДеревоУпаковок;
	
	ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(ДеревоУпаковок.Строки, ПрочитанныеШтрихкоды, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ШтрихкодУпаковки Из ДобавляемыеШтрихкоды Цикл
		Объект.ВложенныеШтрихкоды.Добавить().Штрихкод = ШтрихкодУпаковки;
	КонецЦикла;
	
	ПараметрыНоменклатуры = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыНоменклатурыВложенныхШтрихкодов(Объект);
	
	ИзменениеНоменклатуры = Объект.Номенклатура <> ПараметрыНоменклатуры.Номенклатура;
	
	Объект.ТипУпаковки    = ПараметрыНоменклатуры.ТипУпаковки;
	Объект.Номенклатура   = ПараметрыНоменклатуры.Номенклатура;
	Объект.Характеристика = ПараметрыНоменклатуры.Характеристика;
	Объект.Упаковка       = ПараметрыНоменклатуры.Упаковка;
	Объект.Серия          = ПараметрыНоменклатуры.Серия;
	
	Если ИзменениеНоменклатуры Тогда
		ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшированныеЗначения);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(Знач СтрокиДереваУпаковок, ПрочитанныеШтрихкоды, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Если СтрокиДереваУпаковок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаДерева Из СтрокиДереваУпаковок Цикл
		Для каждого КлючИЗначение Из ПрочитанныеШтрихкоды Цикл
			Штрихкод = КлючИЗначение.Ключ;
			
			Если СтрокаДерева.Штрихкод = Штрихкод Тогда
				Отказ = Истина;
				
				НайденныеСтроки = Объект.ВложенныеШтрихкоды.НайтиСтроки(Новый Структура("Штрихкод", СтрокаДерева.ШтрихкодУпаковки));
				Если НайденныеСтроки.Количество() > 0 Тогда
					НайденнаяСтрока = НайденныеСтроки[0];
				КонецЕсли;
				Если НайденнаяСтрока = Неопределено Тогда
					// В табличную часть добавлена паллета, пытаемся добавить вложенный в паллету короб.
					
					РодительСтрокиДерева = СтрокаДерева.Родитель;
					Пока НайденнаяСтрока = Неопределено
					   И НЕ РодительСтрокиДерева = Неопределено Цикл
						НайденныеСтроки = Объект.ВложенныеШтрихкоды.НайтиСтроки(Новый Структура("Штрихкод", РодительСтрокиДерева.ШтрихкодУпаковки));
						Если НайденныеСтроки.Количество() > 0 Тогда
							НайденнаяСтрока = НайденныеСтроки[0];
						КонецЕсли;
						РодительСтрокиДерева = РодительСтрокиДерева.Родитель;
					КонецЦикла;
				КонецЕсли;
				Если НЕ НайденнаяСтрока = Неопределено Тогда
					Поле = "ВложенныеШтрихкоды[" + Формат(Объект.ВложенныеШтрихкоды.Индекс(НайденнаяСтрока), "ЧН=0; ЧГ=0") + "].Штрихкод";
				Иначе
					Поле = "ВложенныеШтрихкоды";
				КонецЕсли;
				ТекстСообщения = НСтр("ru = 'Данный штрихкод ""%1"" уже добавлен в табличную часть или раннее добавленный имеет такой же вложенный штрихкод'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Штрихкод);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле, "Объект", Отказ);
			КонецЕсли;
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Отказ Тогда
			Прервать;
		Иначе
			ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(СтрокаДерева.Строки, ПрочитанныеШтрихкоды, Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Не ПустаяСтрока(Объект.ХешСумма) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ОбработатьШтрихкодыНаКлиенте(ДанныеШтрихкодов, Отказ);
	Если НЕ Отказ Тогда
		ОбработатьШтрихкодыНаСервере(ДанныеШтрихкодов, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.Code128")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked") Тогда
		Элементы.СгенерироватьШтрихкод.Видимость = (Не Элементы.ЗначениеШтрихкода.ТолькоПросмотр);
	Иначе
		Элементы.СгенерироватьШтрихкод.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОсновное;
	Иначе
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	Элементы.Упаковка.Доступность = ЗначениеЗаполнено(Объект.Номенклатура);
	
	Если Форма.ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.Доступность = Истина;
		Элементы.Характеристика.ПодсказкаВвода = "";
	Иначе
		Элементы.Характеристика.Доступность = Ложь;
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
	КонецЕсли;
	
	Если Форма.СерииИспользуются Тогда
		Элементы.Серия.Доступность = Истина;
		Элементы.Серия.ПодсказкаВвода = "";
	Иначе
		Элементы.Серия.Доступность = Ложь;
		Элементы.Серия.ПодсказкаВвода = НСтр("ru = '<серии не используются>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
	СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, Справочники.ШтрихкодыУпаковокТоваров);
	СобытияФормИСПереопределяемый.УстановитьИнформациюОЕдиницеХранения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакИспользованияСерий(Номенклатура)
	
	Возврат ИнтеграцияИС.ПризнакИспользованияСерий(Номенклатура);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаГенерацииШтрихкода(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Объект.ЗначениеШтрихкода = Результат.Штрихкод;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВложенныеШтрихкодыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ВложенныеШтрихкоды.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Объект.ВложенныеШтрихкоды.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Штрихкод);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
