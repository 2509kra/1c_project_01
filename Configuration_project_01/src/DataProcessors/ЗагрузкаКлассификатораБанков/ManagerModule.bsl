///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов
// 
// Параметры:
//  Классификаторы - см. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.Классификаторы
//  Описатель - см. РаботаСКлассификаторами.ОписаниеКлассификатора
//
Процедура ПриДобавленииКлассификаторов(Классификаторы, Описатель) Экспорт
	
	Описатель.Идентификатор = ИдентификаторКлассификатора();
	Описатель.Наименование = НСтр("ru = 'Справочник БИК'");
	Описатель.ОбновлятьАвтоматически = Истина;
	Описатель.ОбщиеДанные = Истина;
	Описатель.ОбработкаРазделенныхДанных = Ложь;
	Описатель.СохранятьФайлВКэш = Истина;
	
	Классификаторы.Добавить(Описатель);
	
КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
	Если Идентификатор <> ИдентификаторКлассификатора() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("zip");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес); // ДвоичныеДанные
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ЗагрузитьДанныеИзФайла(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайла);
	
	Обработан = Истина;
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоступнаЗагрузкаКлассификатора() Экспорт
	
	Результат = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		Результат = МодульРаботаСКлассификаторами.ИнтерактивнаяЗагрузкаКлассификаторовДоступна();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриПолученииДанныхКлассификатора(Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Истина;
	
КонецПроцедуры

Процедура ЗагрузитьДанные(Параметры)
	
	АктуальныеЗаписи = Новый Массив;
	
	Для Каждого ДанныеОрганизации Из ПрочитатьСправочникБИК(Параметры) Цикл 
		АктуальныеЗаписи.Добавить(ЗаписатьЭлементКлассификатораБанковРФ(ДанныеОрганизации));
	КонецЦикла;
	
	ОтметитьНеактуальныеЗаписи(АктуальныеЗаписи);
	
КонецПроцедуры

Функция ПрочитатьСправочникБИК(Параметры)
	
	ЧтениеТекста = Новый ЧтениеТекста(Параметры.ПутьКФайлуБИК, КодировкаТекста.UTF8);
	ТекстКлассификатора = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	СправочникБИК = JSONВЗначение(ТекстКлассификатора, "dateIn,dateOut");
	Результат = Новый Массив;
	
	Для Каждого Элемент Из СправочникБИК.bics Цикл 
		ДанныеОрганизации = ДанныеОрганизации(Элемент);
		Если ЗначениеЗаполнено(ДанныеОрганизации.Счета) Тогда
			Для Каждого ОписаниеСчета Из ДанныеОрганизации.Счета Цикл
				ДанныеОрганизации.КоррСчет = ОписаниеСчета.КоррСчет;
				Если ОписаниеСчета.Свойство("БИКРКЦ") Тогда
					ДанныеОрганизации.БИКРКЦ = ОписаниеСчета.БИКРКЦ;
					Результат.Добавить(ОбщегоНазначения.СкопироватьРекурсивно(ДанныеОрганизации));
				Иначе
					Результат.Вставить(0, ОбщегоНазначения.СкопироватьРекурсивно(ДанныеОрганизации));
				КонецЕсли;
			КонецЦикла;
		Иначе
			ДанныеОрганизации.КоррСчет = "";
			ДанныеОрганизации.БИКРКЦ = Справочники.КлассификаторБанков.ПустаяСсылка();
			Результат.Вставить(0, ДанныеОрганизации);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеОрганизации(Знач Элемент)
	
	ДанныеОрганизации = СтруктураДанныхОрганизации();
	ЗаполнитьЗначенияСвойств(ДанныеОрганизации, Элемент);
	ЗаполнитьЗначенияСвойств(ДанныеОрганизации, Элемент.participantInfo);
	
	Если Элемент.Свойство("SWIFTs") Тогда
		ДанныеОрганизации.SWIFT = Элемент.SWIFTs[0].SWIFT;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Результат.Вставить("ВнутреннийКодЦБ", ДанныеОрганизации.UID);
	Результат.Вставить("Наименование", ДанныеОрганизации.Name);
	Результат.Вставить("БИК", ДанныеОрганизации.BIC);
	Результат.Вставить("Счета", Новый Массив);
	Результат.Вставить("КоррСчет", "");
	Результат.Вставить("БИКРКЦ", Справочники.КлассификаторБанков.ПустаяСсылка());
	Результат.Вставить("СВИФТБИК", ДанныеОрганизации.SWIFT);
	Результат.Вставить("ИНН", ДанныеОрганизации.INN);
	Результат.Вставить("ОГРН", ДанныеОрганизации.OGRN);
	
	Результат.Вставить("Город", СокрЛП(Строка(ДанныеОрганизации.LocalityType) + " " + ДанныеОрганизации.Locality));
	Результат.Вставить("Адрес", ДанныеОрганизации.Address);
	Результат.Вставить("Телефоны", ДанныеОрганизации.Phones);
	
	Результат.Вставить("МеждународноеНаименование", ДанныеОрганизации.NameEnglish);
	Результат.Вставить("ГородМеждународный", СтроковыеФункции.СтрокаЛатиницей(Результат.Город));
	Результат.Вставить("АдресМеждународный", СтроковыеФункции.СтрокаЛатиницей(Результат.Адрес));
	
	КодРегиона = ДанныеОрганизации.RegionCode;
	Регион = ДанныеОрганизации.RegionName;
	Если Не ЗначениеЗаполнено(Регион) Тогда
		Регион = НСтр("ru = 'Другие территории'");
		КодРегиона = "";
	КонецЕсли;
	
	Результат.Вставить("КодРегиона", КодРегиона);
	Результат.Вставить("Регион", Регион);
	
	Счета = Новый Массив;
	Если Элемент.Свойство("Accounts") Тогда
		Счета= Элемент.Accounts;
	КонецЕсли;
	
	Для Каждого ОписаниеСчета Из Счета Цикл
		ДанныеСчета = СтруктураДанныхСчета();
		ЗаполнитьЗначенияСвойств(ДанныеСчета, ОписаниеСчета);
		Если ВРег(ДанныеСчета.Status) = "ACTIVE" Тогда
			Счет = Новый Структура;
			Счет.Вставить("КоррСчет", ДанныеСчета.account);
			Если ЗначениеЗаполнено(ДанныеСчета.cbrUnitBic) Тогда
				БИКРКЦ = Справочники.КлассификаторБанков.НайтиПоКоду(ДанныеСчета.cbrUnitBic);
				Если ЗначениеЗаполнено(БИКРКЦ) Тогда
					Счет.Вставить("БИКРКЦ", БИКРКЦ);
				КонецЕсли;
			КонецЕсли;
			Результат.Счета.Добавить(Счет);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураДанныхОрганизации()
	
	Результат = Новый Структура;
	Результат.Вставить("name");
	Результат.Вставить("nameEnglish");
	Результат.Вставить("registrationNumber");
	Результат.Вставить("parentBic");
	Результат.Вставить("ogrn");
	Результат.Вставить("inn");
	Результат.Вставить("dateIn");
	Результат.Вставить("dateOut");
	Результат.Вставить("type");
	Результат.Вставить("uid");
	Результат.Вставить("status");
	Результат.Вставить("services");
	Результат.Вставить("exchangeType");
	Результат.Вставить("restrictions");
	Результат.Вставить("countryCode");
	Результат.Вставить("regionCode");
	Результат.Вставить("regionName");
	Результат.Вставить("postalCode");
	Результат.Вставить("localityType");
	Результат.Вставить("locality");
	Результат.Вставить("address");
	Результат.Вставить("phones");
	
	Результат.Вставить("swift");
	Результат.Вставить("bic");
	
	Возврат Результат;
	
КонецФункции
	
Функция СтруктураДанныхСчета()
	
	Результат = Новый Структура;
	Результат.Вставить("account");
	Результат.Вставить("type");
	Результат.Вставить("cbrUnitBic");
	Результат.Вставить("openDate");
	Результат.Вставить("status");
	Результат.Вставить("controlKey");
	Результат.Вставить("closeDate");
	Результат.Вставить("restrictions");
	Результат.Вставить("change");
	
	Возврат Результат;
	
КонецФункции

// Выполняет загрузку классификатора банков РФ из файла, полученного с сайта 1С.
Процедура ЗагрузитьДанныеИзФайла(ИмяФайла)
	
	ИмяКаталога = ИзвлечьФайлыИзАрхива(ИмяФайла);
	Если ФайлыКлассификатораПолучены(ИмяКаталога) Тогда
		Параметры = Новый Структура;
		Параметры.Вставить("ПутьКФайлуБИК", ИмяФайлаБИК(ИмяКаталога));
		Параметры.Вставить("ТекстСообщения", "");
		Параметры.Вставить("ЗагрузкаВыполнена", Неопределено);
		
		ЗагрузитьДанные(Параметры);
		УстановитьВерсиюКлассификатора();
	КонецЕсли;
	
КонецПроцедуры

Функция ФайлыКлассификатораПолучены(ИмяКаталога)
	
	Результат = Истина;
	
	ИменаФайловДляПроверки = Новый Массив;
	ИменаФайловДляПроверки.Добавить(ИмяФайлаБИК(ИмяКаталога));
	
	Для Каждого ИмяФайла Из ИменаФайловДляПроверки Цикл
		Файл = Новый Файл(ИмяФайла);
		Если Не Файл.Существует() Тогда
			ЗаписатьОшибкуВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найден файл %1'"), ИмяФайла));
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИзвлечьФайлыИзАрхива(ZipФайл)
	
	ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременногоКаталога);
	
	Попытка
		ЧтениеZipФайла = Новый ЧтениеZipФайла(ZipФайл);
		ЧтениеZipФайла.ИзвлечьВсе(ИмяВременногоКаталога);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		УдалитьФайлы(ИмяВременногоКаталога);
	КонецПопытки;
	
	Возврат ИмяВременногоКаталога;
	
КонецФункции

Функция ИмяФайлаБИК(ИмяКаталога)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталога) + "bic-classifier.json";
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	
КонецПроцедуры

Функция ИмяСобытияВЖурналеРегистрации()
	
	Возврат НСтр("ru = 'Загрузка классификатора банков.ИПП'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура ОтметитьНеактуальныеЗаписи(АктуальныеЗаписи)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Ссылка КАК Ссылка,
	|	КлассификаторБанков.Код КАК Код
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	НЕ КлассификаторБанков.ДеятельностьПрекращена
	|	И НЕ КлассификаторБанков.Ссылка В (&АктуальныеЗаписи)
	|
	|СГРУППИРОВАТЬ ПО
	|	КлассификаторБанков.Ссылка,
	|	КлассификаторБанков.Код";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("АктуальныеЗаписи", АктуальныеЗаписи);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлассификаторБанков");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			БанкОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если БанкОбъект = Неопределено Или БанкОбъект.Код <> Выборка.Код Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			БанкОбъект.ДеятельностьПрекращена = Истина;
			БанкОбъект.Записать();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'Не удалось обновить сведения об участнике расчетов ""%1"" (БИК %2):
					|%3'"),
					Выборка.Ссылка,
					Выборка.Код,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Запись обработанных данных

///  Записывает/перезаписывает в справочник КлассификаторБанков данные банка.
// Параметры:
//	ПараметрыЗагрузкиДанных - Структура:
//	СтруктураБанк			- Структура или СтрокаТаблицыЗначений - данные банка.
//	Загружено				- Число								 - количество новых записей классификатора.
//	Обновлено				- Число								 - количество обновленных записей классификатора.
//
Функция ЗаписатьЭлементКлассификатораБанковРФ(СведенияОБанке)
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлассификаторБанков");
		Блокировка.Заблокировать();
		
		РегионСсылка = Справочники.КлассификаторБанков.НайтиПоКоду(СведенияОБанке.КодРегиона);
		
		Если РегионСсылка.Пустая() Тогда
			Регион = Справочники.КлассификаторБанков.СоздатьГруппу();
		Иначе
			Регион = РегионСсылка.ПолучитьОбъект();
			Если Не РегионСсылка.ЭтоГруппа Тогда 
				Регион.Код = "";
				Регион.Записать();
				Регион = Справочники.КлассификаторБанков.СоздатьГруппу();
			КонецЕсли;
		КонецЕсли;
		
		Если СокрЛП(Регион.Код) <> СокрЛП(СведенияОБанке.КодРегиона) Тогда
			Регион.Код = СокрЛП(СведенияОБанке.КодРегиона);
		КонецЕсли;
		
		Если СокрЛП(Регион.Наименование) <> СокрЛП(СведенияОБанке.Регион) Тогда
			Регион.Наименование = СокрЛП(СведенияОБанке.Регион);
		КонецЕсли;
		
		Если Регион.ПометкаУдаления Тогда
			Регион.ПометкаУдаления = Ложь;
		КонецЕсли;
		
		Если Регион.Модифицированность() Тогда
			Регион.Записать();
		КонецЕсли;
	
		БанкСсылка = НайтиБанк(СведенияОБанке.БИК, СведенияОБанке.КоррСчет);
		
		Если БанкСсылка = Неопределено Тогда
			БанкОбъект = Справочники.КлассификаторБанков.СоздатьЭлемент();
		Иначе
			БанкОбъект = БанкСсылка.ПолучитьОбъект();
			Если БанкОбъект.ЭтоГруппа Тогда
				БанкОбъект.Код = "";
				БанкОбъект.Записать();
				БанкОбъект = Справочники.КлассификаторБанков.СоздатьЭлемент();
			КонецЕсли;
		КонецЕсли;
		
		Если БанкОбъект.ДеятельностьПрекращена Тогда
			БанкОбъект.ДеятельностьПрекращена = Ложь;
		КонецЕсли;

		Если БанкОбъект.Код <> СведенияОБанке.БИК Тогда
			БанкОбъект.Код = СведенияОБанке.БИК;
		КонецЕсли;

		Для Каждого Реквизит Из БанкОбъект.Метаданные().Реквизиты Цикл
			ИмяРеквизита = Реквизит.Имя;
			Если СведенияОБанке.Свойство(ИмяРеквизита) Тогда
				ОбновитьЗначениеРеквизита(БанкОбъект, ИмяРеквизита, Реквизит.Тип.ПривестиЗначение(СведенияОБанке[ИмяРеквизита]));
			КонецЕсли;
		КонецЦикла;

		ОбновитьЗначениеРеквизита(БанкОбъект, "Наименование",
			БанкОбъект.Метаданные().СтандартныеРеквизиты.Наименование.Тип.ПривестиЗначение(СведенияОБанке.Наименование));
		
		Если БанкОбъект.Родитель <> Регион.Ссылка Тогда
			БанкОбъект.Родитель = Регион.Ссылка;
		КонецЕсли;

		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			Страна = "РФ";
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
				МодульРаботаСАдресамиКлиентСервер = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресамиКлиентСервер");
				Страна = МодульРаботаСАдресамиКлиентСервер.ОсновнаяСтрана();
			КонецЕсли;
			ОбновитьЗначениеРеквизита(БанкОбъект, "Страна", Страна);
		КонецЕсли;
		
		Если БанкОбъект.ПометкаУдаления Тогда
			БанкОбъект.ПометкаУдаления = Ложь;
		КонецЕсли;
		
		Если БанкОбъект.Модифицированность() Тогда
			БанкОбъект.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат БанкОбъект.Ссылка;
	
КонецФункции

Функция НайтиБанк(БИК, КоррСчет)
	
	НайденныеБанки = НайтиБанки(БИК, КоррСчет);
	Если НайденныеБанки.Количество() > 0 Тогда
		Возврат НайденныеБанки[0];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция НайтиБанки(Знач БИК, Знач КоррСчет)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Ссылка КАК Ссылка,
	|	КлассификаторБанков.Код КАК БИК,
	|	КлассификаторБанков.КоррСчет КАК КоррСчет
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	КлассификаторБанков.Код = &БИК
	|	И (КлассификаторБанков.КоррСчет = &КоррСчет
	|			ИЛИ КлассификаторБанков.КоррСчет = """")
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоррСчет УБЫВ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БИК", БИК);
	Запрос.УстановитьПараметр("КоррСчет", КоррСчет);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Процедура ОбновитьЗначениеРеквизита(СправочникОбъект, ИмяРеквизита, Знач Значение)
	Если СправочникОбъект[ИмяРеквизита] <> Значение Тогда
		СправочникОбъект[ИмяРеквизита] = Значение;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

// Определяет нужно ли обновление данных классификатора.
//
Функция КлассификаторАктуален() Экспорт
	ПоследнееОбновление = ДатаПоследнейЗагрузки();
	ДопустимаяПросрочка = 30*60*60*24;
	
	Если ТекущаяДатаСеанса() > ПоследнееОбновление + ДопустимаяПросрочка Тогда
		Возврат Ложь; // Пошла просрочка.
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция АктуальностьКлассификатораБанков() Экспорт
	
	ПоследнееОбновление = ДатаПоследнейЗагрузки();
	ДопустимаяПросрочка = 60*60*24;
	
	Результат = Новый Структура;
	Результат.Вставить("КлассификаторУстарел", Ложь);
	Результат.Вставить("КлассификаторПросрочен", Ложь);
	Результат.Вставить("ВеличинаПросрочкиСтрокой", "");
	
	Если ТекущаяДатаСеанса() > ПоследнееОбновление + ДопустимаяПросрочка Тогда
		Результат.ВеличинаПросрочкиСтрокой = ОбщегоНазначения.ИнтервалВремениСтрокой(ПоследнееОбновление, ТекущаяДатаСеанса());
		
		ВеличинаПросрочки = (ТекущаяДатаСеанса() - ПоследнееОбновление);
		ДнейПросрочено = Цел(ВеличинаПросрочки/60/60/24);
		
		Результат.КлассификаторУстарел = ДнейПросрочено >= 1;
		Результат.КлассификаторПросрочен = ДнейПросрочено >= 7;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДатаПоследнейЗагрузки()
	Возврат СведенияОКлассификаторе().ДатаЗагрузки;
КонецФункции

Функция СведенияОКлассификаторе()
	УстановитьПривилегированныйРежим(Истина);
	Результат = Константы.ВерсияКлассификатораБанков.Получить().Получить();
	УстановитьПривилегированныйРежим(Ложь);
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = НовоеОписаниеКлассификатора();
	КонецЕсли;
	Возврат Результат;
КонецФункции

Процедура УстановитьВерсиюКлассификатора(Знач ВерсияКлассификатора = Неопределено)
	Если Не ЗначениеЗаполнено(ВерсияКлассификатора) Тогда
		ВерсияКлассификатора = ТекущаяУниверсальнаяДата();
	КонецЕсли;
	СведенияОКлассификаторе = НовоеОписаниеКлассификатора(ВерсияКлассификатора, ТекущаяДатаСеанса());
	УстановитьПривилегированныйРежим(Истина);
	Константы.ВерсияКлассификатораБанков.Установить(Новый ХранилищеЗначения(СведенияОКлассификаторе));
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция НовоеОписаниеКлассификатора(ДатаМодификации = '00010101', ДатаЗагрузки = '00010101')
	Результат = Новый Структура;
	Результат.Вставить("ДатаМодификации", ДатаМодификации);
	Результат.Вставить("ДатаЗагрузки", ДатаЗагрузки);
	Возврат Результат;
КонецФункции

Функция ИдентификаторКлассификатора()
	
	Возврат "BIC";
	
КонецФункции

Функция JSONВЗначение(Строка, ИменаСвойствСоЗначениямиДата = Неопределено)
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Строка);
	Возврат ПрочитатьJSON(ЧтениеJSON, Ложь, ИменаСвойствСоЗначениямиДата);
КонецФункции

Функция СведенияБИК(Знач БИК, Знач КоррСчет = Неопределено, ТолькоАктуальные = Истина) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СправочникБИК.Ссылка КАК Ссылка,
	|	СправочникБИК.Код КАК БИК,
	|	СправочникБИК.Наименование КАК Наименование,
	|	СправочникБИК.КоррСчет КАК КоррСчет,
	|	СправочникБИК.Город КАК Город,
	|	СправочникБИК.Адрес КАК Адрес,
	|	СправочникБИК.Телефоны КАК Телефоны,
	|	СправочникБИК.ИНН КАК ИНН,
	|	СправочникБИК.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	СправочникБИК.СВИФТБИК КАК СВИФТБИК,
	|	СправочникБИК.МеждународноеНаименование КАК МеждународноеНаименование,
	|	СправочникБИК.ГородМеждународный КАК ГородМеждународный,
	|	СправочникБИК.АдресМеждународный КАК АдресМеждународный,
	|	СправочникБИК.Страна КАК Страна,
	|	СправочникБИКРКЦ.Код КАК БИКРКЦ,
	|	СправочникБИКРКЦ.Наименование КАК НаименованиеРКЦ,
	|	СправочникБИКРКЦ.КоррСчет КАК КоррСчетРКЦ,
	|	СправочникБИКРКЦ.Город КАК ГородРКЦ,
	|	СправочникБИКРКЦ.Адрес КАК АдресРКЦ,
	|	СправочникБИКРКЦ.ИНН КАК ИННРКЦ
	|ИЗ
	|	Справочник.КлассификаторБанков КАК СправочникБИК
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК СправочникБИКРКЦ
	|		ПО СправочникБИК.БИКРКЦ = СправочникБИКРКЦ.Ссылка
	|ГДЕ
	|	СправочникБИК.Код = &БИК
	|	И ВЫБОР
	|			КОГДА &КоррСчет = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ СправочникБИК.КоррСчет = &КоррСчет
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ТолькоАктуальные
	|				ТОГДА НЕ СправочникБИК.ДеятельностьПрекращена
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БИК", БИК);
	Запрос.УстановитьПараметр("КоррСчет", КоррСчет);
	Запрос.УстановитьПараметр("ТолькоАктуальные", ТолькоАктуальные);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли