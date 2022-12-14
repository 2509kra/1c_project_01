///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость =
			РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована();
		
		Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость =
			Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Иначе
		Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость = Ложь;
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами") Тогда
		Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь()
			И Не ОбщегоНазначения.РазделениеВключено();
	Иначе
		Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь(, Истина)
			И Не ОбщегоНазначения.РазделениеВключено()
			И Не ОбщегоНазначения.КлиентПодключенЧерезВебСервер()
			И ОбщегоНазначения.ЭтоWindowsКлиент();
		
		ОбновитьНастройкиРезервногоКопирования();
	Иначе
		Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		Элементы.ГруппаОценкаПроизводительности.Видимость =
			Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Иначе
		Элементы.ГруппаОценкаПроизводительности.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость =
			Пользователи.ЭтоПолноправныйПользователь();
	Иначе
		Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПоискИУдалениеДублей") Тогда
		Элементы.ГруппаПоискИУдалениеДублей.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость =
			НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Иначе
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");
		Элементы.ГруппаУстановкаОбновлений.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь(, Истина)
			И Не ОбщегоНазначения.ЭтоАвтономноеРабочееМесто()
			И Не ОбщегоНазначения.РазделениеВключено()
			И Не ОбщегоНазначения.КлиентПодключенЧерезВебСервер()
			И ОбщегоНазначения.ЭтоWindowsКлиент();
		
		Элементы.ГруппаУстановленныеИсправления.Видимость =
			Пользователи.ЭтоПолноправныйПользователь();
			
		Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
			И Не СтандартныеПодсистемыСервер.ДоступнаУстановкаПодписанныхРасширенийВБазовойВерсии() Тогда
			Элементы.УстановкаОбновлений.Заголовок = НСтр("ru = 'Установка обновлений'");
			Элементы.УстановкаОбновлений.РасширеннаяПодсказка.Заголовок =
				НСтр("ru = 'Обновление программы из файла на локальном диске или в сетевой папке.'");
		КонецЕсли;
	Иначе
		Элементы.ГруппаУстановкаОбновлений.Видимость = Ложь;
		Элементы.ГруппаУстановленныеИсправления.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		МодульОблачныйАрхив.ПанельАдминистрированияБСП_ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Если Элементы.Найти("ПравилПроверкиУчета") <> Неопределено Тогда
			Элементы.ПравилаПроверкиУчета.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Или ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаНастройкаПриоритетаОбновления.Видимость = Ложь;
	Иначе
		КоличествоПотоковОбновления = ОбновлениеИнформационнойБазы.КоличествоПотоковОбновления();
		ПриоритетОбработкиДанных    = ОбновлениеИнформационнойБазы.ПриоритетОтложеннойОбработки();
		Элементы.КоличествоПотоковОбновления.Видимость = ОбновлениеИнформационнойБазы.РазрешеноМногопоточноеОбновление();
		НастроитьИспользованиеКоличестваПотоковОбновления(ПриоритетОбработкиДанных);
	КонецЕсли;
	
	//++ Локализация
	//-- Локализация
		
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.ОбслуживаниеПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ПриОткрытии(ЭтотОбъект);
	КонецЕсли;
	
	УправлениеЭлементамиФормыОбновленияЧерезКопию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования"
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		ОбновитьНастройкиРезервногоКопирования();
	ИначеЕсли ИмяСобытия = "РазрешенаРаботаСВнешнимиРесурсами" Тогда
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПриоритетОтложеннойОбработкиДанныхПриИзменении(Элемент)
	УстановитьПриоритетОтложеннойОбработки(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПотоковОбновленияИнформационнойБазыПриИзменении(Элемент)
	УстановитьКоличествоПотоковОбновления();
КонецПроцедуры

#Область ОбновлениеЧерезКопию

&НаКлиенте
Процедура ОбновлениеЧерезКопированиеПриИзменении(Элемент)
	
	ВключитьОтключитьОбновлениеЧерезКопию();
	УправлениеЭлементамиФормыОбновленияЧерезКопию();
	
КонецПроцедуры

#КонецОбласти

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура ОблачныйАрхивОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Истина;

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
			ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка, Новый Структура);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СпособРезервногоКопированияПриИзменении(Элемент)

	// В зависимости от состояния, вывести правильную страницу.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_СпособРезервногоКопированияПриИзменении(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазблокироватьРаботуСВнешнимиРесурсами(Команда)
	РазблокироватьРаботуСВнешнимиРесурсамиНаСервере();
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
	Оповестить("РазрешенаРаботаСВнешнимиРесурсами");
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ", ПараметрыФормы);
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура ПодключитьСервисОблачныйАрхив(Команда)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПодключитьСервисОблачныйАрхив();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОблачныйАрхивВосстановлениеИзРезервнойКопииНажатие(Элемент)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ВосстановлениеИзРезервнойКопии();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОблачныйАрхивНастройкаРезервногоКопированияНажатие(Элемент)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.НастройкаРезервногоКопирования();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеЭлементамиФормыОбновленияЧерезКопию()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновлениеЧерезКопию", "Доступность", НЕ ОбновлениеЧерезКопиюВключено);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновлениеЧерезКопиюВыгрузка", "Доступность", ОбновлениеЧерезКопиюВключено);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновлениеЧерезКопиюЗагрузка", "Доступность", ДоступенПомощникЗагрузки);
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура УстановитьПриоритетОтложеннойОбработки(ИмяЭлемента)
	ОбновлениеИнформационнойБазы.УстановитьПриоритетОтложеннойОбработки(ПриоритетОбработкиДанных);
	НастроитьИспользованиеКоличестваПотоковОбновления(ПриоритетОбработкиДанных);
КонецПроцедуры

&НаСервере
Процедура НастроитьИспользованиеКоличестваПотоковОбновления(Приоритет)
	Элементы.КоличествоПотоковОбновления.Доступность = (Приоритет = "ОбработкаДанных");
КонецПроцедуры

&НаСервере
Процедура УстановитьКоличествоПотоковОбновления()
	ОбновлениеИнформационнойБазы.УстановитьКоличествоПотоковОбновления(КоличествоПотоковОбновления);
КонецПроцедуры

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности")
		И (РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности"
		Или РеквизитПутьКДанным = "") Тогда
			ЭлементОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности = Элементы.Найти("ОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности");
			ЭлементОбработкаОценкаПроизводительностиЭкспортДанных = Элементы.Найти("ОбработкаОценкаПроизводительностиЭкспортДанных");
			ЭлементСправочникПрофилиКлючевыхОперацийОткрытьСписок = Элементы.Найти("СправочникПрофилиКлючевыхОперацийОткрытьСписок");
			ЭлементОбработкаНастройкиОценкиПроизводительности = Элементы.Найти("ОбработкаНастройкиОценкиПроизводительности");
			Если (ЭлементОбработкаНастройкиОценкиПроизводительности <> Неопределено
				И ЭлементОбработкаОценкаПроизводительностиЭкспортДанных <> Неопределено				
				И ЭлементСправочникПрофилиКлючевыхОперацийОткрытьСписок <> Неопределено
				И ЭлементОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности <> Неопределено
				И НаборКонстант.Свойство("ВыполнятьЗамерыПроизводительности")) Тогда
				ЭлементОбработкаНастройкиОценкиПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
				ЭлементОбработкаОценкаПроизводительностиЭкспортДанных.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
				ЭлементСправочникПрофилиКлючевыхОперацийОткрытьСписок.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
				ЭлементОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
			КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	Если Не ОбщегоНазначения.РазделениеВключено()
	   И Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		МодульРезервноеКопированиеИБСервер = ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеИБСервер");
		Элементы.НастройкаРезервногоКопированияИБ.РасширеннаяПодсказка.Заголовок = МодульРезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьРаботуСВнешнимиРесурсамиНаСервере()
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	МодульРегламентныеЗаданияСервер = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСервер");
	МодульРегламентныеЗаданияСервер.РазблокироватьРаботуСВнешнимиРесурсами();
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьОбновлениеЧерезКопию()
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеЧерезКопиюВыгрузка(Команда)
	
	//++ Локализация
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеЧерезКопиюЗагрузка(Команда)
	
	//++ Локализация
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура Подключаемый_ПроверитьСостояниеОблачногоАрхива()

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ПроверитьСостояниеОблачногоАрхива(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти