
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ЕстьОшибкиУчетныхЗаписей = Ложь;
	ПараметрыДетализации = Неопределено;
	Если Параметры.Свойство("ПараметрыДетализации", ПараметрыДетализации) Тогда
		
		КонтекстОперации = ПараметрыДетализации.КонтекстОперации;
		Если Не ОбменСКонтрагентамиДиагностикаКлиентСервер.ЕстьОшибки(КонтекстОперации) Тогда
			Элементы.ПровестиДиагностику.Видимость = Ложь;
		КонецЕсли;
		Заголовок = Заголовок + СтрШаблон(" (%1)", Формат(ПараметрыДетализации.КонтекстОперации.ДатаНачалаОперации, НСтр("ru = 'ДФ=HH:mm'") ));
		ЗаполнитьУчетныеЗаписи(ПараметрыДетализации, ЕстьОшибкиУчетныхЗаписей);
		ЗаполнитьРезультатыОпераций(ПараметрыДетализации, ЕстьОшибкиУчетныхЗаписей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтобратьОперации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчетныеЗаписи

&НаКлиенте
Процедура УчетныеЗаписиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.УчетныеЗаписиСостояниеСинхронизации И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ПодробноеПредставлениеОшибки) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Состояние синхронизации'"));
		ПараметрыФормы.Вставить("Ошибки", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Элемент.ТекущиеДанные.ПодробноеПредставлениеОшибки));
		ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.РасшифровкаОшибок", ПараметрыФормы);
	ИначеЕсли Поле = Элементы.УчетныеЗаписиНаименование Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.КлючЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультатыОпераций

&НаКлиенте
Процедура РезультатыОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.РезультатыОперацийПредставлениеДокумента Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	ИначеЕсли Поле = Элементы.РезультатыОперацийОшибка И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ошибка) Тогда
		ПоказатьПредупреждение(, Элемент.ТекущиеДанные.Ошибка);
	ИначеЕсли Поле = Элементы.РезультатыОперацийДокументыУчета Тогда
		КоличествоДокументовУчета = Элемент.ТекущиеДанные.СсылкиНаДокументыУчета.Количество();
		Если КоличествоДокументовУчета > 0 Тогда
			Если КоличествоДокументовУчета = 1 Тогда
				ПоказатьЗначение(, Элемент.ТекущиеДанные.СсылкиНаДокументыУчета[0].Значение);
			Иначе 
				Оповещение = Новый ОписаниеОповещения("ПослеВыбораУчетногоДокумента", ЭтотОбъект);
				Элемент.ТекущиеДанные.СсылкиНаДокументыУчета.ПоказатьВыборЭлемента(Оповещение);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Неудачные(Команда)
	
	ОбработатьНажатиеНаКнопкуОтбора(Элементы.Неудачные);
	ОтобратьОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура Успешные(Команда)
	
	ОбработатьНажатиеНаКнопкуОтбора(Элементы.Успешные);
	ОтобратьОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДиагностику(Команда)
	
	КонтекстОперации.ОшибкиОбработаны = Ложь;
	ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОбработатьОшибки(КонтекстОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРезультатыОпераций(ПараметрыДетализации, ЕстьОшибкиУчетныхЗаписей)
	
	УспешныеДокументы = ПараметрыДетализации.РезультатыОтправкиПолучения.Успешные;
	НеудачныеДокументы = ПараметрыДетализации.РезультатыОтправкиПолучения.Неудачные;
	ЕстьПредупрежденияСтраницыДокументы = Ложь;
	ЕстьПредупрежденияСтраницыУчетныеЗаписи = Ложь;
	Если НеудачныеДокументы.Количество() > 0 Тогда
		Элементы.Неудачные.Пометка = Истина;
		Элементы.СтраницаДокументы.Картинка = БиблиотекаКартинок.НекорректныйКонтрагент;
		ЕстьПредупрежденияСтраницыДокументы = Истина;
	ИначеЕсли УспешныеДокументы.Количество() > 0 Тогда
		Элементы.Успешные.Пометка = Истина;
	КонецЕсли;
	Если ЕстьОшибкиУчетныхЗаписей Тогда
		Элементы.СтраницаУчетныеЗаписи.Картинка = БиблиотекаКартинок.НекорректныйКонтрагент;
		ЕстьПредупрежденияСтраницыУчетныеЗаписи = Истина;
	КонецЕсли;
	
	Если ЕстьПредупрежденияСтраницыДокументы И Не ЕстьПредупрежденияСтраницыУчетныеЗаписи Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДокументы;
	ИначеЕсли Не ЕстьПредупрежденияСтраницыДокументы И ЕстьПредупрежденияСтраницыУчетныеЗаписи Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаУчетныеЗаписи;
	ИначеЕсли ЕстьПредупрежденияСтраницыДокументы И ЕстьПредупрежденияСтраницыУчетныеЗаписи Тогда
		Если РезультатыОпераций.Количество() Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДокументы;
		Иначе 
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаУчетныеЗаписи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Успешные.Заголовок = СтрШаблон(НСтр("ru = '%1 (%2)'"), Элементы.Успешные.Заголовок, УспешныеДокументы.Количество());
	Элементы.Неудачные.Заголовок = СтрШаблон(НСтр("ru = '%1 (%2)'"), Элементы.Неудачные.Заголовок, НеудачныеДокументы.Количество());
	
	ВсеДокументы = Новый Массив;
	Для каждого УспешныйДокумент Из УспешныеДокументы Цикл
		ВсеДокументы.Добавить(УспешныйДокумент.Ссылка);
	КонецЦикла; 
	Для каждого НеудачныйДокумент Из НеудачныеДокументы Цикл
		ВсеДокументы.Добавить(НеудачныйДокумент.Ссылка);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Основания.Ссылка КАК ЭлектронныйДокумент,
	|	Основания.ДокументОснование КАК УчетныйДокумент,
	|	ПРЕДСТАВЛЕНИЕ(Основания.ДокументОснование) КАК УчетныйДокументПредставление
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий.ДокументыОснования КАК Основания
	|ГДЕ
	|	Основания.Ссылка В(&НаборЭлектронныхДокументов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Основания.Ссылка,
	|	Основания.ДокументОснование,
	|	ПРЕДСТАВЛЕНИЕ(Основания.ДокументОснование)
	|ИЗ
	|	Документ.ЭлектронныйДокументИсходящий.ДокументыОснования КАК Основания
	|ГДЕ
	|	Основания.Ссылка В(&НаборЭлектронныхДокументов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭлектронныйДокументВходящий.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументВходящий.ВидЭД) КАК ВидЭД,
	|	ЭлектронныйДокументВходящий.ДатаДокументаОтправителя КАК Дата,
	|	ЭлектронныйДокументВходящий.НомерДокументаОтправителя КАК Номер
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
	|ГДЕ
	|	ЭлектронныйДокументВходящий.Ссылка В(&НаборЭлектронныхДокументов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронныйДокументИсходящий.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументИсходящий.ВидЭД),
	|	ЭлектронныйДокументИсходящий.ДатаДокументаОтправителя,
	|	ЭлектронныйДокументИсходящий.НомерДокументаОтправителя
	|ИЗ
	|	Документ.ЭлектронныйДокументИсходящий КАК ЭлектронныйДокументИсходящий
	|ГДЕ
	|	ЭлектронныйДокументИсходящий.Ссылка В(&НаборЭлектронныхДокументов)";
	Запрос.УстановитьПараметр("НаборЭлектронныхДокументов", ВсеДокументы);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	Основания = РезультатЗапроса[0].Выгрузить();
	ВыборкаПредставлениеЭД = РезультатЗапроса[1].Выбрать();
	
	Элементы.СтраницаДокументы.Заголовок = Элементы.СтраницаДокументы.Заголовок + СтрШаблон(" (%1)", ВсеДокументы.Количество());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЭД.ПредставлениеСостояния КАК ПредставлениеСостояния,
	|	СостоянияЭД.ЭлектронныйДокумент КАК ЭлектронныйДокумент
	|ИЗ
	|	РегистрСведений.СостоянияЭД КАК СостоянияЭД
	|ГДЕ
	|	СостоянияЭД.ЭлектронныйДокумент В(&СсылкиНаОбъекты)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ПакетЭД.СтатусПакета),
	|	ПакетЭД.Ссылка
	|ИЗ
	|	Документ.ПакетЭД КАК ПакетЭД
	|ГДЕ
	|	ПакетЭД.Ссылка В(&СсылкиНаОбъекты)";
	
	Запрос.УстановитьПараметр("СсылкиНаОбъекты", ВсеДокументы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Для каждого УспешныйДокумент Из УспешныеДокументы Цикл
		НоваяСтрока = ДобавитьСтрокуРезультатаОперации(УспешныйДокумент.Ссылка, ВыборкаДетальныеЗаписи, ВыборкаПредставлениеЭД, Основания);
		НоваяСтрока.Картинка = 3;
		НоваяСтрока.ЕстьОшибки = Ложь;
	КонецЦикла;
	
	Для каждого НеудачныйДокумент Из НеудачныеДокументы Цикл
		НоваяСтрока = ДобавитьСтрокуРезультатаОперации(НеудачныйДокумент.Ссылка, ВыборкаДетальныеЗаписи, ВыборкаПредставлениеЭД, Основания, НеудачныйДокумент.Ошибка);
		НоваяСтрока.Картинка = 0;
		НоваяСтрока.ЕстьОшибки = Истина;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУчетныеЗаписи(ПараметрыДетализации, ЕстьОшибкиУчетныхЗаписей)
	
	МассивУчетныхЗаписей = Новый Массив;
	Для каждого КлючИЗначение Из ПараметрыДетализации.ОбработанныеУчетныеЗаписи Цикл
		НоваяСтрока = УчетныеЗаписи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, КлючИЗначение.Значение);
		Если НоваяСтрока.ОтправкаПолучениеВыполнялись Тогда
			НоваяСтрока.Картинка = 3;
			НоваяСтрока.Порядок = 0;
			НоваяСтрока.СостояниеСинхронизации = НСтр("ru = 'Выполнена'");
		Иначе 
			Если КлючИЗначение.Значение.ПользовательОтказалсяОтОперации Тогда
				НоваяСтрока.Картинка = 2;
				НоваяСтрока.Порядок = 2;
				НоваяСтрока.СостояниеСинхронизации = НСтр("ru = 'Отменена'");
			ИначеЕсли НоваяСтрока.ВидОшибки = ОбменСКонтрагентамиДиагностикаКлиентСервер.ВидОшибкиОтправкиИПолученияНетДоступныхСертификатов() Тогда 
				НоваяСтрока.Картинка = 1;
				НоваяСтрока.Порядок = 1;
				НоваяСтрока.СостояниеСинхронизации = КлючИЗначение.Значение.ИнформацияОбОшибке.КраткоеПредставление;
				НоваяСтрока.ПодробноеПредставлениеОшибки = КлючИЗначение.Значение.ИнформацияОбОшибке;
			Иначе 
				НоваяСтрока.Картинка = 0;
				НоваяСтрока.Порядок = 1;
				НоваяСтрока.СостояниеСинхронизации = КлючИЗначение.Значение.ИнформацияОбОшибке.КраткоеПредставление;
				НоваяСтрока.ПодробноеПредставлениеОшибки = КлючИЗначение.Значение.ИнформацияОбОшибке;
				ЕстьОшибкиУчетныхЗаписей = Истина;
			КонецЕсли;
		КонецЕсли;
		МассивУчетныхЗаписей.Добавить(КлючИЗначение.Значение.Идентификатор);
	КонецЦикла;
	УчетныеЗаписи.Сортировать("Порядок Возр");
	
	Элементы.СтраницаУчетныеЗаписи.Заголовок = Элементы.СтраницаУчетныеЗаписи.Заголовок + СтрШаблон(" (%1)", УчетныеЗаписи.Количество());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК НаименованиеУчетнойЗаписи
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|ГДЕ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО В(&ИдентификаторыЭДО)";
	
	Запрос.УстановитьПараметр("ИдентификаторыЭДО", МассивУчетныхЗаписей);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(УчетнаяЗапись.Идентификатор, "ИдентификаторЭДО") Тогда
			УчетнаяЗапись.Наименование = ВыборкаДетальныеЗаписи.НаименованиеУчетнойЗаписи;
			ЗначенияКлюча = Новый Структура("ИдентификаторЭДО", УчетнаяЗапись.Идентификатор);
			УчетнаяЗапись.КлючЗаписи = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьКлючЗаписи(ЗначенияКлюча);
			ВыборкаДетальныеЗаписи.Сбросить();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуРезультатаОперации(ЭлектронныйДокумент, ВыборкаДетальныеЗаписи, ВыборкаПредставлениеЭД, Основания, Ошибка = "")
	
	НоваяСтрока = РезультатыОпераций.Добавить();
	НоваяСтрока.Документ = ЭлектронныйДокумент;
	НоваяСтрока.Картинка = 3;
	НоваяСтрока.Ошибка = Ошибка;
	Если ВыборкаДетальныеЗаписи.НайтиСледующий(ЭлектронныйДокумент, "ЭлектронныйДокумент") Тогда
		НоваяСтрока.ПредставлениеСостояния = ВыборкаДетальныеЗаписи.ПредставлениеСостояния;
		ВыборкаДетальныеЗаписи.Сбросить();
	КонецЕсли;
	
	Если (ТипЗнч(ЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий")
		Или ТипЗнч(ЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящий"))
		И ВыборкаПредставлениеЭД.НайтиСледующий(ЭлектронныйДокумент, "Ссылка") Тогда
		НоваяСтрока.ПредставлениеДокумента = СтрШаблон(НСтр("ru = '%1 №%2 от %3'"),
		ВыборкаПредставлениеЭД.ВидЭД,
		ВыборкаПредставлениеЭД.Номер,
		Формат(ВыборкаПредставлениеЭД.Дата, "ДЛФ=D"));
		ВыборкаПредставлениеЭД.Сбросить();
	Иначе 
		НоваяСтрока.ПредставлениеДокумента = ЭлектронныйДокумент;
	КонецЕсли;
	
	ОтборЭД = Новый Структура("ЭлектронныйДокумент", НоваяСтрока.Документ);
	ОснованияЭД = Основания.НайтиСтроки(ОтборЭД);
	
	Если ЗначениеЗаполнено(ОснованияЭД) Тогда
		Для каждого ОснованиеЭД Из ОснованияЭД Цикл
			НоваяСтрока.СсылкиНаДокументыУчета.Добавить(ОснованиеЭД.УчетныйДокумент);
		КонецЦикла; 
		Представление = "";
		КоличествоОснований = ОснованияЭД.Количество();
		Если КоличествоОснований = 1 Тогда
			Представление = ОснованияЭД[0].УчетныйДокументПредставление;
		Иначе
			ШаблонСтроки = НСтр("ru = ';%1 документ;;%1 документа;%1 документов;%1 документов'");
			Представление = СтрокаСЧислом(ШаблонСтроки, КоличествоОснований, ВидЧисловогоЗначения.Количественное);
		КонецЕсли;
		НоваяСтрока.ОтражениеВУчете = Представление;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление() 
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РезультатыОпераций.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("РезультатыОперацийОшибки");
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РезультатыОпераций.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("РезультатыОперацийОшибки");
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчетныеЗаписи.Картинка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокКартинок = Новый СписокЗначений;
	СписокКартинок.Добавить(0);
	СписокКартинок.Добавить(1);
	ОтборЭлемента.ПравоеЗначение = СписокКартинок;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("УчетныеЗаписиСостояниеСинхронизации");
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчетныеЗаписи.Картинка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокКартинок = Новый СписокЗначений;
	СписокКартинок.Добавить(2);
	СписокКартинок.Добавить(3);
	ОтборЭлемента.ПравоеЗначение = СписокКартинок;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("УчетныеЗаписиСостояниеСинхронизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНаКнопкуОтбора(Кнопка) 
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьОперации() 
	
	Успешные = Элементы.Успешные.Пометка;
	Неуспешные = Элементы.Неудачные.Пометка;
	
	Если (Успешные И Неуспешные)
		Или (Не Успешные И Не Неуспешные) Тогда
		
		ОтборСтрок = Неопределено;
		
	Иначе
		Если Успешные Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьОшибки", Ложь);
		Иначе
			ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьОшибки", Истина);
		КонецЕсли;
	КонецЕсли;
		
	Элементы.РезультатыОпераций.ОтборСтрок = ОтборСтрок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораУчетногоДокумента(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ВыбранныйЭлемент.Значение);
	
КонецПроцедуры

#КонецОбласти 

