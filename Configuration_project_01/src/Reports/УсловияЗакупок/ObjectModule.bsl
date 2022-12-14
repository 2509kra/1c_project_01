#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.ДополнительныеПараметры.Свойство("ИмяКоманды") Тогда 
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "УсловияЗакупокПоПоставщику" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Партнер", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);	
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ЦеныПоставщиков.Запрос;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаКоэффициентУпаковки1",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
																							"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаКоэффициентУпаковки2",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("МаксимальныеЦеныНоменклатурыСрезПоследних.Упаковка",
																							"МаксимальныеЦеныНоменклатурыСрезПоследних.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаКоэффициентУпаковки3",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатуры.Упаковка",
																							"ЦеныНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ЦеныНоменклатуры.Упаковка",
																							"ЦеныНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных.ЦеныПоставщиков.Запрос = ТекстЗапроса;	
	
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	УстановитьЗаголовкиПолей(МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");	
	Если ПараметрВалюта <> Неопределено И Не ПараметрВалюта.Использование Тогда
		ПараметрВалюта.Использование = Истина;
	КонецЕсли;

	НастройкаГруппировкаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Группировка");
	СписокГруппировок = КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(КомпоновщикНастроек);
	Для каждого Группировка Из СписокГруппировок  Цикл
		Если Группировка.Значение.Имя = "ГруппировкаПоВертикали" Тогда
			Группировка.Значение.Использование = НЕ Булево(НастройкаГруппировкаОтчета.Значение);
		ИначеЕсли Группировка.Значение.Имя = "ГруппировкаПоГоризонтали" Тогда
			Группировка.Значение.Использование = Булево(НастройкаГруппировкаОтчета.Значение);
		КонецЕсли;
	КонецЦикла;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Процедура УстановитьЗаголовкиПолей(МакетКомпоновки)
	
	ЕдиницаОбъема = Строка(Константы.ЕдиницаИзмеренияОбъема.Получить());	
	ЕдиницаВеса = Строка(Константы.ЕдиницаИзмеренияВеса.Получить());
	
	Для Каждого ТекМакет Из МакетКомпоновки.Макеты Цикл
		Если ТипЗнч(ТекМакет.Макет) <> Тип("МакетОбластиКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого СтрокаТаблицыКомпоновки Из ТекМакет.Макет Цикл
			Для Каждого ЯчейкаТаблицыОбластиКомпоновки Из СтрокаТаблицыКомпоновки.Ячейки Цикл
				Для Каждого Элемент Из ЯчейкаТаблицыОбластиКомпоновки.Элементы Цикл
					Если СтрНайти(Элемент.Значение, "%ЕдиницаОбъема%") > 0 Тогда
						Элемент.Значение = СтрЗаменить(Элемент.Значение, "%ЕдиницаОбъема%", ЕдиницаОбъема);
					ИначеЕсли СтрНайти(Элемент.Значение, "%ЕдиницаВеса%") > 0 Тогда
						Элемент.Значение = СтрЗаменить(Элемент.Значение, "%ЕдиницаВеса%", ЕдиницаВеса);
					КонецЕсли;							
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("Группировка");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

#КонецОбласти

#КонецЕсли
