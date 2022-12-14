///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОтключитьФормированиеОтчета;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Подготовка временного хранилища для сохранения промежуточных результатов.
	АдресХранилищаДанныеДосье = ПоместитьВоВременноеХранилище(
		Неопределено,
		ЭтотОбъект.УникальныйИдентификатор);
	АдресХранилищаДанныеПроверки = ПоместитьВоВременноеХранилище(
		Неопределено,
		ЭтотОбъект.УникальныйИдентификатор);
	
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		ИННКонтрагента = ЗначениеИННКонтрагента(Параметры.Контрагент);
		Если ЗначениеЗаполнено(ИННКонтрагента) Тогда
			СтрокаПоиска = ИННКонтрагента;
			Контрагент   = Параметры.Контрагент;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ИНН) Тогда
		СтрокаПоиска = Параметры.ИНН;
	КонецЕсли;
	
	ОписаниеДанныхПрограммы = Отчеты.ДосьеКонтрагента.НоваяТаблицаОписаниеДанныхПрограммы();
	РаботаСКонтрагентамиПереопределяемый.ЗаполнитьОписаниеДанныхПрограммы(ОписаниеДанныхПрограммы);
	ПоказатьДанныеПрограммы = ОписаниеДанныхПрограммы.Количество() > 0;
	Элементы.ДекорацияРазделДанныеПрограммы.Видимость = ПоказатьДанныеПрограммы;
	
	ПоискПоИНН = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоиска);
	Если ПоискПоИНН
		И (СтрДлина(СтрокаПоиска) = 10
		ИЛИ СтрДлина(СтрокаПоиска) = 12) Тогда
		ИННПоиска = СтрокаПоиска;
		ЭтоЮридическоеЛицо = СтрДлина(ИННПоиска) = 10;
		СформироватьОтчетНаСервере();
	Иначе
		ЭтоЮридическоеЛицо = Истина;
		УправлениеФормойНаСервере();
	КонецЕсли;
	
	СвойстваСправочниковКонтрагентов = РаботаСКонтрагентами.СвойстваСправочниковКонтрагентов();
	ИспользоватьДобавлениеВСправочник =
		(СвойстваСправочниковКонтрагентов.Найти(Ложь, "ОтключитьСозданиеИзДосьеКонтрагента") <> Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИмяДокумента = ?(ЭтоЮридическоеЛицо, "РезультатГлавное", "РезультатДанныеГосРеестров");
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы[ИмяДокумента], "ФормированиеОтчета");
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
			ПараметрыОжидания);
	ИначеЕсли ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредупреждениеОбОшибке", 0.1, Истина);
	ИначеЕсли ОжиданиеОтвета Тогда
		ПодключитьОбработчикОжидания("Подключаемый_СформироватьОтчет", 3, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы[ИмяДокумента], "ФормированиеОтчета");
	КонецЕсли;
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы["Группа" + ИмяДокумента];
	Если ЗначениеЗаполнено(ИдентификаторЗадания)
		ИЛИ ОжиданиеОтвета 
		ИЛИ ЭтотОбъект[ИмяДокумента].ВысотаТаблицы > 0 Тогда
		ТекущийЭлемент = Элементы[ИмяДокумента];
	Иначе
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	СформироватьОтчетНаКлиенте(СтрокаПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделГлавноеНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатГлавное;
	ТекущийЭлемент = Элементы.РезультатГлавное;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Главное");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделДанныеГосРеестровНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатДанныеГосРеестров;
	ТекущийЭлемент = Элементы.РезультатДанныеГосРеестров;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("ДанныеГосРеестров");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделДанныеПрограммыНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатДанныеПрограммы;
	ТекущийЭлемент = Элементы.РезультатДанныеПрограммы;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("ДанныеПрограммы");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделБухгалтерскаяОтчетностьНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатБухгалтерскаяОтчетность;
	ТекущийЭлемент = Элементы.РезультатБухгалтерскаяОтчетность;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("БухгалтерскаяОтчетность");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделАнализОтчетностиНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатАнализОтчетности;
	ТекущийЭлемент = Элементы.РезультатАнализОтчетности;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("АнализОтчетности");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделФинансовыйАнализНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатФинансовыйАнализ;
	ТекущийЭлемент = Элементы.РезультатФинансовыйАнализ;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("ФинансовыйАнализ");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделПроверкиНажатие(Элемент)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатПроверки;
	ТекущийЭлемент = Элементы.РезультатПроверки;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Проверки");
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатДанныеГосРеестровОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработатьРасшифровкуТабличногоДокумента(Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатДанныеПрограммыОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработатьРасшифровкуТабличногоДокумента(Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатФинансовыйАнализОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработатьРасшифровкуТабличногоДокумента(Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПроверкиОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработатьРасшифровкуТабличногоДокумента(Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Если ОтключитьФормированиеОтчета <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПоиска) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Поле ""ИНН или наименование контрагента"" не заполнено'"), , "СтрокаПоиска");
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетНаКлиенте(СтрокаПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСправочник(Команда)
	
	Если Не ЗначениеЗаполнено(НайденныйИНН) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстЗаполнения"                               , НайденныйИНН);
	ПараметрыФормы.Вставить("РаботаСКонтрагентамиСозданиеИзДосьеКонтрагента", Истина);
	
	ПараметрыИПП = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	СправочникиКонтрагентыМассив = ПараметрыИПП.РаботаСКонтрагентами.СправочникиСозданиеИзДосье;
	СправочникиКонтрагентыСписок = Новый СписокЗначений;
	Для Каждого ОписаниеСправочника Из СправочникиКонтрагентыМассив Цикл
		СправочникиКонтрагентыСписок.Добавить(ОписаниеСправочника, ОписаниеСправочника.Синоним);
	КонецЦикла;
	Если СправочникиКонтрагентыСписок.Количество() = 1 Тогда
		ОткрытьФормуСозданияКонтрагента(СправочникиКонтрагентыСписок[0].Значение, ПараметрыФормы);
	Иначе
		СправочникиКонтрагентыСписок.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения("ПриВыбореСправочникаКонтрагентаСоздания", ЭтотОбъект, ПараметрыФормы),
			НСтр("ru = 'Выбор справочника контрагентов'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриВыбореСправочникаКонтрагентаСоздания(ВыбранныйЭлемент, ПараметрыФормы) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОткрытьФормуСозданияКонтрагента(ВыбранныйЭлемент.Значение, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСозданияКонтрагента(ОписаниеСправочника, ПараметрыФормы)
	
	ОткрытьФорму("Справочник." + ОписаниеСправочника.Имя + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойНаСервере()
	
	Если ЗначениеЗаполнено(НаименованиеКонтрагента) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Досье контрагента: %1'"),
			НаименованиеКонтрагента);
	ИначеЕсли ЗначениеЗаполнено(Контрагент) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Досье контрагента: %1'"),
			Контрагент);
	Иначе
		Заголовок = НСтр("ru='Досье контрагента'");
	КонецЕсли;
	Элементы.ДекорацияРазделДанныеГосРеестров.Заголовок = ?(ЭтоЮридическоеЛицо, 
		НСтр("ru='ЕГРЮЛ'"), 
		НСтр("ru='ЕГРИП'"));
	
	Элементы.ДекорацияРазделГлавное.Видимость = ЭтоЮридическоеЛицо;
	Элементы.ДекорацияРазделБухгалтерскаяОтчетность.Видимость = ЭтоЮридическоеЛицо;
	Элементы.ДекорацияРазделАнализОтчетности.Видимость        = ЭтоЮридическоеЛицо;
	Элементы.ДекорацияРазделФинансовыйАнализ.Видимость        = ЭтоЮридическоеЛицо;
	
	Элементы.КнопкаДобавитьВСправочник.Видимость =
		(ИспользоватьДобавлениеВСправочник
		И Не ЗначениеЗаполнено(Контрагент)
		И ЗначениеЗаполнено(НайденныйИНН));
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = ?(ЭтоЮридическоеЛицо, 
		Элементы.ГруппаРезультатГлавное, 
		Элементы.ГруппаРезультатДанныеГосРеестров);
	ТекущийЭлемент = ?(ЗначениеЗаполнено(ОписаниеОшибки), 
		Элементы.СтрокаПоиска, 
		?(ЭтоЮридическоеЛицо, Элементы.РезультатГлавное, Элементы.РезультатДанныеГосРеестров));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьОбластьДокумента(Расшифровка)
	
	Если НЕ Расшифровка.Свойство("ИмяОбласти") Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("ИмяДокумента,ИмяОбласти", Расшифровка.ИмяДокумента, Расшифровка.ИмяОбласти);
	СтрокиТаблицы = ОбластиРасшифровки.НайтиСтроки(Отбор);
	Если СтрокиТаблицы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СтрокаОбласти = СтрокиТаблицы[0];
	
	НомерСтрокиЕще = СтрокаОбласти.ПерваяСтрока - 1;
	
	ТабличныйДокумент = ЭтотОбъект[Расшифровка.ИмяДокумента];
	Если Расшифровка.Действие = "Показать" Тогда
		ТабличныйДокумент.Область(НомерСтрокиЕще, , НомерСтрокиЕще).Видимость = Ложь;
		ТабличныйДокумент.Область(СтрокаОбласти.ПерваяСтрока, , СтрокаОбласти.ПоследняяСтрока).Видимость = Истина;
		Элементы[Расшифровка.ИмяДокумента].ТекущаяОбласть = ТабличныйДокумент.Область(СтрокаОбласти.ПоследняяСтрока, 3);
	Иначе // "Свернуть"
		ТабличныйДокумент.Область(НомерСтрокиЕще, , НомерСтрокиЕще).Видимость = Истина;
		ТабличныйДокумент.Область(СтрокаОбласти.ПерваяСтрока, , СтрокаОбласти.ПоследняяСтрока).Видимость = Ложь;
		Элементы[Расшифровка.ИмяДокумента].ТекущаяОбласть = ТабличныйДокумент.Область(НомерСтрокиЕще, 3);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СформироватьОтчетНаКлиенте(ТекстПоиска, ЭтоПроверкаРезультата = Ложь)
	
	Если НЕ ЗначениеЗаполнено(ТекстПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	ДлинаТекстПоиска = СтрДлина(ТекстПоиска);
	ПоискПоИНН = (СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ТекстПоиска)
		И (ДлинаТекстПоиска = 10
		Или ДлинаТекстПоиска = 12));
	Если ПоискПоИНН Тогда
		
		ИННПоиска = ТекстПоиска;
		
		ЭтоЮридическоеЛицо = СтрДлина(ИННПоиска) = 10;
		
		ИмяДокумента = ?(ЭтоЮридическоеЛицо, "РезультатГлавное", "РезультатДанныеГосРеестров");
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы[ИмяДокумента], "ФормированиеОтчета");
		
		Результат = СформироватьОтчетНаСервере(ЭтоПроверкаРезультата);
		
		Если Не Результат Тогда
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			ДлительныеОперацииКлиент.ОжидатьЗавершение(
				ДлительнаяОперация,
				Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
				ПараметрыОжидания);
		Иначе
			
			ОбработатьОшибкиФормированияОтчета();
			
			Если ОжиданиеОтвета Тогда
				// Повторный вызов процедуры формирования при асинхронном получении данных от сервиса.
				ПодключитьОбработчикОжидания("Подключаемый_СформироватьОтчет", 3, Истина);
			Иначе
				Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
						Элементы[ИмяДокумента], "НеИспользовать");
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе // Поиск по наименованию
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СтрокаПоиска", ТекстПоиска);
		ПараметрыФормы.Вставить("Заголовок",    НСтр("ru='Поиск контрагента'"));
		ДопПараметры = Новый Структура;
		ОписаниеОповещения = Новый ОписаниеОповещения("НайтиПоНаименованиюЗавершение", ЭтотОбъект, ДопПараметры);
		ОткрытьФорму("ОбщаяФорма.ЗаполнениеРеквизитовКонтрагента", 
			ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
	ОтключитьФормированиеОтчета = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ВключитьФормированиеОтчета", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере(ЭтоПроверкаРезультата = Ложь)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	ОписаниеОшибки       = "";
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не ЭтоПроверкаРезультата Тогда
		// Очистка результата при формировании нового отчета.
		ОжиданиеОтвета = Ложь;
		СостояниеФормированияОтчета = Новый Структура;
		СостояниеФормированияОтчета.Вставить("СостояниеДосье"             , "");
		СостояниеФормированияОтчета.Вставить("СостояниеПроверки"          , "");
		СостояниеФормированияОтчета.Вставить("ОчищеноСодержимоеДокументов", Ложь);
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ИНН"                  , ИННПоиска);
	ПараметрыОтчета.Вставить("СостояниеДосье"       , СостояниеФормированияОтчета.СостояниеДосье);
	ПараметрыОтчета.Вставить("СостояниеПроверки"    , СостояниеФормированияОтчета.СостояниеПроверки);
	
	Если ЗначениеЗаполнено(Контрагент) И ЗначениеИННКонтрагента(Контрагент) <> ИННПоиска Тогда
		Контрагент = Неопределено;
	КонецЕсли;
	ПараметрыОтчета.Вставить("Контрагент", Контрагент);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Формирование отчета: Досье контрагента: %1'"),
		ИННПоиска);
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне("Отчеты.ДосьеКонтрагента.СформироватьОтчет",
		ПараметрыОтчета,
		ПараметрыВыполнения);
	АдресХранилища = ДлительнаяОперация.АдресРезультата;
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
		Возврат Ложь;
	Иначе
		ИдентификаторЗадания = Неопределено;
		Если ДлительнаяОперация.Статус = "Выполнено" Тогда
			ЗагрузитьПодготовленныеДанные();
			Возврат Истина;
		ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
			ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
		Иначе
			ВызватьИсключение НСтр("ru = 'Задание отменено.'");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПоказатьПредупреждениеОбОшибке()
	
	ОбработатьОшибкиФормированияОтчета();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьФормированиеОтчета()

	ОтключитьФормированиеОтчета = Неопределено;

КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_СформироватьОтчет()

	СформироватьОтчетНаКлиенте(ИННПоиска, Истина);

КонецПроцедуры 

&НаКлиенте
Процедура ПриЗавершенииЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	ЗагрузитьПодготовленныеДанные();
	
	ОписаниеОшибки = Результат.КраткоеПредставлениеОшибки;
	ОбработатьОшибкиФормированияОтчета();
	
	Если ОжиданиеОтвета Тогда
		// Повторный вызов процедуры формирования при асинхронном получении данных от сервиса.
		ПодключитьОбработчикОжидания("Подключаемый_СформироватьОтчет", 3, Истина);
	Иначе
		ИмяДокумента = ?(ЭтоЮридическоеЛицо, "РезультатГлавное", "РезультатДанныеГосРеестров");
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы[ИмяДокумента], "НеИспользовать");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДопПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		СформироватьОтчетНаКлиенте(СтрокаПоиска);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НайтиПоНаименованиюЗавершение(Результат, ДопПараметры) Экспорт

	Если НЕ ЗначениеЗаполнено(Результат) 
		ИЛИ ТипЗнч(Результат) <> Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетНаКлиенте(Результат);

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	ДанныеОтчета = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// Очистка временного хранилища.
	УдалитьИзВременногоХранилища(АдресХранилища);
	
	// Если результат не сформирован или нет данных во временном хранилище
	// выполнять обработку не требуется.
	Если ДанныеОтчета = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ДанныеОтчета.Свойство("СостояниеДосье") Тогда
		СостояниеФормированияОтчета.СостояниеДосье = ДанныеОтчета.СостояниеДосье;
	КонецЕсли;
	
	Если ДанныеОтчета.Свойство("СостояниеПроверки") Тогда
		СостояниеФормированияОтчета.СостояниеПроверки = ДанныеОтчета.СостояниеПроверки;
	КонецЕсли;
	
	ОписаниеОшибки = ДанныеОтчета.ОписаниеОшибки;
	Контрагент     = ДанныеОтчета.Контрагент;
	ОжиданиеОтвета = ПустаяСтрока(ОписаниеОшибки)
		И (СостояниеФормированияОтчета.СостояниеДосье = "Ожидание"
		Или СостояниеФормированияОтчета.СостояниеПроверки = "Ожидание");
	
	// Очистка
	Если Не СостояниеФормированияОтчета.ОчищеноСодержимоеДокументов Тогда
		
		// Общие свойства
		НайденныйИНН = "";
		НаименованиеКонтрагента = "";
		ОбластиРасшифровки.Очистить();
		
		// Главное
		РезультатГлавное.Очистить();
		Элементы.РезультатГлавное.ИспользуемоеИмяФайла = Неопределено;
		РезультатГлавное.ТекущаяОбласть = РезультатГлавное.Область(1, 2, 1, 2);
		
		// Данные единых гос. реестров
		РезультатДанныеГосРеестров.Очистить();
		Элементы.РезультатДанныеГосРеестров.ИспользуемоеИмяФайла = Неопределено;
		РезультатДанныеГосРеестров.ТекущаяОбласть = РезультатДанныеГосРеестров.Область(1, 2, 1, 2);
		
		// Данные программы
		Если ПоказатьДанныеПрограммы Тогда
			РезультатДанныеПрограммы.Очистить();
			Элементы.РезультатДанныеПрограммы.ИспользуемоеИмяФайла = Неопределено;
			РезультатДанныеПрограммы.ТекущаяОбласть = РезультатДанныеПрограммы.Область(1, 2, 1, 2);
		КонецЕсли;
		
		// Бух. отчетность
		РезультатБухгалтерскаяОтчетность.Очистить();
		Элементы.РезультатБухгалтерскаяОтчетность.ИспользуемоеИмяФайла = Неопределено;
		РезультатБухгалтерскаяОтчетность.ТекущаяОбласть = РезультатБухгалтерскаяОтчетность.Область(1, 2, 1, 2);
		
		// Показатели
		РезультатАнализОтчетности.Очистить();
		Элементы.РезультатАнализОтчетности.ИспользуемоеИмяФайла = Неопределено;
		РезультатАнализОтчетности.ТекущаяОбласть = РезультатАнализОтчетности.Область(1, 2, 1, 2);
		
		// Фин. анализ
		РезультатФинансовыйАнализ.Очистить();
		Элементы.РезультатФинансовыйАнализ.ИспользуемоеИмяФайла = Неопределено;
		РезультатФинансовыйАнализ.ТекущаяОбласть = РезультатФинансовыйАнализ.Область(1, 2, 1, 2);
		
		// Проверки
		РезультатПроверки.Очистить();
		Элементы.РезультатПроверки.ИспользуемоеИмяФайла = Неопределено;
		РезультатПроверки.ТекущаяОбласть = РезультатПроверки.Область(1, 2, 1, 2);
		
		СостояниеФормированияОтчета.ОчищеноСодержимоеДокументов = Истина;
		
	КонецЕсли;
	
	ДанныеДосье    = Неопределено;
	ДанныеПроверки = Неопределено;
	Если СостояниеФормированияОтчета.СостояниеДосье = "СформированОтчет" Тогда
		ДанныеДосье = ДанныеОтчета.ДанныеДосье;
		Если ОжиданиеОтвета Тогда
			// Сохранить для использования на следующей итерации.
			ПоместитьВоВременноеХранилище(ДанныеДосье, АдресХранилищаДанныеДосье);
		КонецЕсли;
		СостояниеФормированияОтчета.СостояниеДосье = "Завершено";
	КонецЕсли;
	
	Если СостояниеФормированияОтчета.СостояниеПроверки = "СформированОтчет" Тогда
		ДанныеПроверки = ДанныеОтчета.ДанныеПроверки;
		Если ОжиданиеОтвета Тогда
			// Сохранить для использования на следующей итерации.
			ПоместитьВоВременноеХранилище(ДанныеПроверки, АдресХранилищаДанныеПроверки);
		КонецЕсли;
		СостояниеФормированияОтчета.СостояниеПроверки = "Завершено";
	КонецЕсли;
	
	// Заполнение
	Если Не ОжиданиеОтвета И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		
		Если ДанныеДосье = Неопределено Тогда
			// Данные сохранены во временное хранилище на предыдущей итерации.
			ДанныеДосье = ПолучитьИзВременногоХранилища(АдресХранилищаДанныеДосье);
			// Очистка временного хранилища
			ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаДанныеДосье);
		КонецЕсли;
		
		Если ДанныеПроверки = Неопределено Тогда
			// Данные во временном хранилище.
			ДанныеПроверки = ПолучитьИзВременногоХранилища(АдресХранилищаДанныеПроверки);
			// Очистка временного хранилища
			ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаДанныеПроверки);
		КонецЕсли;
		
		// Общие свойства
		НайденныйИНН = ДанныеДосье.НайденныйИНН;
		НаименованиеКонтрагента = ДанныеДосье.НаименованиеКонтрагента;
		Для Каждого СтрокаОбласти Из ДанныеДосье.ОбластиРасшифровки Цикл
			НоваяСтрока = ОбластиРасшифровки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОбласти);
		КонецЦикла;
		
		Для Каждого СтрокаОбласти Из ДанныеПроверки.ОбластиРасшифровки Цикл
			НоваяСтрока = ОбластиРасшифровки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОбласти);
		КонецЦикла;
		
		// Главное
		Если ДанныеДосье.Свойство("РезультатГлавное") Тогда
			РезультатГлавное.Вывести(ДанныеДосье.РезультатГлавное);
			Элементы.РезультатГлавное.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаГлавное);
		КонецЕсли;
		
		// Данные единых гос. реестров
		РезультатДанныеГосРеестров.Вывести(ДанныеДосье.РезультатДанныеГосРеестров);
		Элементы.РезультатДанныеГосРеестров.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаДанныеГосРеестров);
		
		// Данные программы
		Если ПоказатьДанныеПрограммы И ДанныеДосье.Свойство("РезультатДанныеПрограммы") Тогда
			РезультатДанныеПрограммы.Вывести(ДанныеДосье.РезультатДанныеПрограммы);
			Элементы.РезультатДанныеПрограммы.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаДанныеПрограммы);
		КонецЕсли;
		
		// Бух. отчетность
		Если ДанныеДосье.Свойство("РезультатБухгалтерскаяОтчетность") Тогда
			РезультатБухгалтерскаяОтчетность.Вывести(ДанныеДосье.РезультатБухгалтерскаяОтчетность);
			Элементы.РезультатБухгалтерскаяОтчетность.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаБухгалтерскаяОтчетность);
		КонецЕсли;
		
		// Показатели
		Если ДанныеДосье.Свойство("РезультатАнализОтчетности") Тогда
			РезультатАнализОтчетности.Вывести(ДанныеДосье.РезультатАнализОтчетности);
			Элементы.РезультатАнализОтчетности.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаАнализОтчетности);
		КонецЕсли;
		
		// Фин. анализ
		Если ДанныеДосье.Свойство("РезультатФинансовыйАнализ") Тогда
			РезультатФинансовыйАнализ.Вывести(ДанныеДосье.РезультатФинансовыйАнализ);
			Элементы.РезультатФинансовыйАнализ.ИспользуемоеИмяФайла = СокрЛП(ДанныеДосье.ИмяФайлаФинансовыйАнализ);
		КонецЕсли;
		
		// Проверки
		Если ДанныеПроверки.Свойство("РезультатПроверки") Тогда
			РезультатПроверки.Вывести(ДанныеПроверки.РезультатПроверки);
			
			Если ДанныеДосье.Свойство("РезультатГлавное") Тогда
				Если ДанныеПроверки.ТекстИнформацияОПроверках <> Неопределено Тогда
					Область = Отчеты.ДосьеКонтрагента.ПолучитьМакет("Главное").ПолучитьОбласть("РезультатыПроверок");
					Область.Параметры.РезультатыПроверок = ДанныеПроверки.ТекстИнформацияОПроверках;
					РезультатГлавное.Вывести(Область);
				КонецЕсли;
			КонецЕсли;
			
			Элементы.РезультатПроверки.ИспользуемоеИмяФайла = СокрЛП(
				СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Досье %1 - проверки'"),
						ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
							НаименованиеКонтрагента, ""))));
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьСвойстваЗаголовкамРазделовНаСервере(?(ЭтоЮридическоеЛицо, "Главное", "ДанныеГосРеестров"));
	УправлениеФормойНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЗаголовкамРазделовНаСервере(ИмяТекущегоРаздела)
	
	Элементы.ДекорацияРазделГлавное.Гиперссылка                 = Истина;
	Элементы.ДекорацияРазделДанныеГосРеестров.Гиперссылка       = Истина;
	Элементы.ДекорацияРазделДанныеПрограммы.Гиперссылка         = Истина;
	Элементы.ДекорацияРазделБухгалтерскаяОтчетность.Гиперссылка = Истина;
	Элементы.ДекорацияРазделАнализОтчетности.Гиперссылка        = Истина;
	Элементы.ДекорацияРазделФинансовыйАнализ.Гиперссылка        = Истина;
	Элементы.ДекорацияРазделПроверки.Гиперссылка                = Истина;
	
	// АПК:1346-выкл
	// Сброс настроек в значение Авто.
	
	Элементы.ДекорацияРазделГлавное.ЦветФона                 = Новый Цвет;
	Элементы.ДекорацияРазделДанныеГосРеестров.ЦветФона       = Новый Цвет;
	Элементы.ДекорацияРазделДанныеПрограммы.ЦветФона         = Новый Цвет;
	Элементы.ДекорацияРазделБухгалтерскаяОтчетность.ЦветФона = Новый Цвет;
	Элементы.ДекорацияРазделАнализОтчетности.ЦветФона        = Новый Цвет;
	Элементы.ДекорацияРазделФинансовыйАнализ.ЦветФона        = Новый Цвет;
	Элементы.ДекорацияРазделПроверки.ЦветФона                = Новый Цвет;
	
	// АПК:1346-вкл
	
	Элементы["ДекорацияРаздел" + ИмяТекущегоРаздела].Гиперссылка = Ложь;
	Элементы["ДекорацияРаздел" + ИмяТекущегоРаздела].ЦветФона = ЦветаСтиля.ДосьеТекущийРазделЦвет;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРасшифровкуТабличногоДокумента(Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) <> Тип("Структура")
		ИЛИ НЕ Расшифровка.Свойство("Действие") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка.Действие = "Показать" 
		ИЛИ Расшифровка.Действие = "Свернуть" Тогда
		
		ПоказатьСкрытьОбластьДокумента(Расшифровка);
		
	ИначеЕсли Расшифровка.Действие = "Открыть" Тогда
		
		Если НЕ Расшифровка.Свойство("ИНН") Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Расшифровка.ИНН) 
			ИЛИ (СтрДлина(Расшифровка.ИНН) <> 10
			И СтрДлина(Расшифровка.ИНН) <> 12) Тогда
			Возврат;
		КонецЕсли;
		ПараметрыФормы = Новый Структура("ИНН", Расшифровка.ИНН);
		ОткрытьФорму("Отчет.ДосьеКонтрагента.Форма", ПараметрыФормы, , Расшифровка.ИНН);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкиФормированияОтчета()
	
	Если НЕ ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации"
		Или ОписаниеОшибки = "НеУказанПароль" Тогда
		Если ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
			ТекстВопроса = НСтр("ru='Для формирования ""Досье контрагента""
				|необходимо подключить Интернет-поддержку пользователей.
				|Подключить Интернет-поддержку?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ПоказатьПредупреждение(
				,
				НСтр("ru='Для формирования ""Досье контрагента""
					|необходимо подключить Интернет-поддержку пользователей.
					|Обратитесь к администратору.'"));
		КонецЕсли;
	ИначеЕсли ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен" Тогда
		
		ОбработчикЗавершения = Новый ОписаниеОповещения(
			"ОкончаниеПодключенияТестовогоПериода",
			ЭтотОбъект);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИдентификаторМестаВызова", "dosie_kontragenta");
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
		
		РаботаСКонтрагентамиКлиент.ПодключитьТестовыйПериод(
			ПараметрыФормы,
			ЭтотОбъект,
			ДополнительныеПараметры);
		
	Иначе
		ПоказатьПредупреждение(, ОписаниеОшибки);
	КонецЕсли;
	
	ОписаниеОшибки = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПодключенияТестовогоПериода(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("ПовторитьДействие") И Результат.ПовторитьДействие Тогда
		СформироватьОтчетНаКлиенте(СтрокаПоиска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначениеИННКонтрагента(КонтрагентСсылка)
	
	СвойстваСправочника = РаботаСКонтрагентами.СвойстваСправочникаКонтрагенты(КонтрагентСсылка);
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрагентСсылка, СвойстваСправочника.РеквизитИНН);
	
КонецФункции

#КонецОбласти
