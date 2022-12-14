///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции GetExchangeFeatures
Функция ПолучитьПланыОбменаКонфигурации()
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common", "ExchangeFeatures"));
	ТипExchangeFeature = ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common", "ExchangeFeature");
	
	Для Каждого ИмяПланаОбмена Из ОбменДаннымиВМоделиСервисаПовтИсп.ПланыОбменаСинхронизацииДанных() Цикл
		
		ExchangeFeature = ФабрикаXDTO.Создать(ТипExchangeFeature);
		ExchangeFeature.ExchangePlan = ИмяПланаОбмена;
		
		ExchangeFeature.ExchangeRole = СокрЛП(ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ИмяКонфигурацииИсточника"));
		
		Если ПустаяСтрока(ExchangeFeature.ExchangeRole) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не задано значение свойства ИмяКонфигурацииИсточника в процедуре ПриПолученииНастроек()
				|модуля менеджера плана обмена %1.'"),
				ИмяПланаОбмена);
		КонецЕсли;
		
		Результат.Feature.Добавить(ExchangeFeature);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Соответствует операции PrepareExchangeExecution
Функция ЗапланироватьВыполнениеОбменаДанными(ОбластиДляОбменаДаннымиXDTO)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат "";
	КонецЕсли;
		
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	
	ОбластиДляОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(ОбластиДляОбменаДаннымиXDTO);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Элемент Из ОбластиДляОбменаДанными Цикл
		
		ЗначениеРазделителя = Элемент.Ключ;
		СценарийОбменаДанными = Элемент.Значение;
		
		Параметры = Новый Массив;
		Параметры.Добавить(СценарийОбменаДанными);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВМоделиСервиса.ВыполнитьОбменДанными");
		ПараметрыЗадания.Вставить("Параметры"    , Параметры);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", ЗначениеРазделителя);
		
		Попытка
			МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> МодульОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInFirstDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат "";
	КонецЕсли;
		
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		
		УстановитьПривилегированныйРежим(Истина);
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
		УстановитьПривилегированныйРежим(Ложь);
		
		РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(
			"ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе",
			Параметры,
			Ключ);
			
		УстановитьПривилегированныйРежим(Истина);
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
		УстановитьПривилегированныйРежим(Ложь);
		
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> МодульОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный режим обмена данными %1'"), Строка(РежимОбмена));
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInSecondDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат "";
	КонецЕсли;
		
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		
		УстановитьПривилегированныйРежим(Истина);
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
		УстановитьПривилегированныйРежим(Ложь);
		
		РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(
			"ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе",
			Параметры,
			Ключ);
			
		УстановитьПривилегированныйРежим(Истина);
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
		УстановитьПривилегированныйРежим(Ложь);
		
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> МодульОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный режим обмена данными %1'"), Строка(РежимОбмена));
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции TestConnection
Функция ПроверитьПодключение(СтруктураНастроекXDTO, ВидТранспортаСтрокой, СообщениеОбОшибке)
	
	Отказ = Ложь;
	
	// Проверяем подключение обработки транспорта сообщений обмена
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ,
			СериализаторXDTO.ПрочитатьXDTO(СтруктураНастроекXDTO),
			Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой],
			СообщениеОбОшибке);
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Соответствует операции Ping
Функция Ping()
	
	Возврат "";
	
КонецФункции

//

Функция РежимОбменаДанными(СценарийОбменаДанными)
	
	Результат = "Ручной";
	
	Если СценарийОбменаДанными.Колонки.Найти("Режим") <> Неопределено Тогда
		Результат = СценарийОбменаДанными[0].Режим;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
