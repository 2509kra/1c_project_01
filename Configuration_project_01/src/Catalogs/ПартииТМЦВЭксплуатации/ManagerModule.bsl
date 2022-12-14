#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик перед записью документа передачи в эксплуатацию
// 		Заполняется реквизит "ПартияТМЦВЭксплуатации" в табличной части
// 		При необходимости создаются новые элементы справочника партий
// 		Ссылки на партии, не используемые в дальнейшем, помечаются для удаления.
//
// Параметры:
// 		Объект - ДокументОбъект.ВнутреннееПотреблениеТоваров, ДокументОбъект.ВводОстатков - объект документа передачи
// 		Отказ - Булево - Возвращаемый признак удачного выполнения обработчика.
//
Процедура ЗаполнитьПартии(Объект, Отказ) Экспорт
	
	ДопСвойства = Объект.ДополнительныеСвойства;
	ЭтоВнутреннееПотребление = (ТипЗнч(Объект) = Тип("ДокументОбъект.ВнутреннееПотреблениеТоваров"));
	ЭтоВводОстатков = (ТипЗнч(Объект) = Тип("ДокументОбъект.ВводОстатков"));
	
	ЭтоОперацияПередачи = (
		(ЭтоВнутреннееПотребление И Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию)
		Или (ЭтоВводОстатков И Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиТМЦВЭксплуатации));
	
	ПометкаУдаленияПартий = Объект.ПометкаУдаления Или Не ЭтоОперацияПередачи;
	
	Если ДопСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись И Не ПометкаУдаленияПартий Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаДокумент = Объект.Ссылка;
	Если ДопСвойства.ЭтоНовый Тогда
		Если ЭтоВнутреннееПотребление Тогда
			СсылкаНаДокумент = Документы.ВнутреннееПотреблениеТоваров.ПолучитьСсылку();
		ИначеЕсли ЭтоВводОстатков Тогда
			СсылкаНаДокумент = Документы.ВводОстатков.ПолучитьСсылку();
		КонецЕсли;
		Объект.УстановитьСсылкуНового(СсылкаНаДокумент);
	КонецЕсли;
	
	ТабличнаяЧасть = ?(ЭтоВводОстатков, Объект.ТМЦВЭксплуатации.Выгрузить(), Объект.Товары.Выгрузить());
	Если ЭтоВнутреннееПотребление Тогда
		
		ТабличнаяЧасть.Колонки.Добавить("ДатаПередачиВЭксплуатацию", Новый ОписаниеТипов("Дата"));
		ТабличнаяЧасть.ЗаполнитьЗначения(НачалоДня(Объект.Дата), "ДатаПередачиВЭксплуатацию");
		
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
	Запрос.УстановитьПараметр("Дата", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("ПометкаУдаленияПартий", ПометкаУдаленияПартий);
	Запрос.УстановитьПараметр("ТабличнаяЧасть", ТабличнаяЧасть);
	#Область ТекстЗапроса
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
	|	ВЫРАЗИТЬ(Таблица.ДатаПередачиВЭксплуатацию КАК ДАТА) КАК ДатаПередачиВЭксплуатацию,
	|	ВЫРАЗИТЬ(Таблица.КатегорияЭксплуатации КАК Справочник.КатегорииЭксплуатации) КАК КатегорияЭксплуатации,
	|	ВЫРАЗИТЬ(Таблица.ИнвентарныйНомер КАК СТРОКА(11)) КАК ИнвентарныйНомер,
	|	ВЫРАЗИТЬ(Таблица.СтатьяРасходов КАК ПланВидовХарактеристик.СтатьиРасходов) КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	ВЫРАЗИТЬ(Таблица.ФизическоеЛицо КАК Справочник.ФизическиеЛица) КАК ФизическоеЛицо,
	|	ВЫРАЗИТЬ(Таблица.ПартияТМЦВЭксплуатации КАК Справочник.ПартииТМЦВЭксплуатации) КАК ПартияТМЦВЭксплуатации
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	&ТабличнаяЧасть КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.ДатаПередачиВЭксплуатацию КАК Дата,
	|	Таблица.КатегорияЭксплуатации КАК КатегорияЭксплуатации,
	|	Таблица.КатегорияЭксплуатации.ИнвентарныйУчет КАК ИнвентарныйУчет,
	|	Таблица.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	Таблица.СтатьяРасходов КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Таблица.КатегорияЭксплуатации.СпособПогашенияСтоимостиБУ КАК СпособПогашенияСтоимостиБУ,
	|	Таблица.КатегорияЭксплуатации.СпособПогашенияСтоимостиНУ КАК СпособПогашенияСтоимостиНУ,
	|	Таблица.КатегорияЭксплуатации.СрокЭксплуатации КАК СрокЭксплуатации,
	|	Таблица.КатегорияЭксплуатации.ЕдиницаИзмеренияНаработки КАК ЕдиницаИзмеренияНаработки,
	|	Таблица.КатегорияЭксплуатации.ОбъемНаработки КАК ОбъемНаработки,
	|	Таблица.ПартияТМЦВЭксплуатации КАК ПартияТМЦВЭксплуатации
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	ДанныеДокумента КАК Таблица
	|ГДЕ
	|	НЕ &ПометкаУдаленияПартий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки - 1 КАК ИндексСтроки,
	|	ЕСТЬNULL(СправочникПартий.Ссылка, ЗНАЧЕНИЕ(Справочник.ПартииТМЦВЭксплуатации.ПустаяСсылка)) КАК ПартияТМЦВЭксплуатации,
	|	&Документ КАК Документ,
	|	Таблица.Дата КАК Дата,
	|	Таблица.КатегорияЭксплуатации КАК КатегорияЭксплуатации,
	|	Таблица.СрокЭксплуатации КАК СрокЭксплуатации,
	|	Таблица.ИнвентарныйУчет КАК ИнвентарныйУчет,
	|	Таблица.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	Таблица.СпособПогашенияСтоимостиБУ КАК СпособПогашенияСтоимостиБУ,
	|	Таблица.СпособПогашенияСтоимостиНУ КАК СпособПогашенияСтоимостиНУ,
	|	Таблица.ЕдиницаИзмеренияНаработки КАК ЕдиницаИзмеренияНаработки,
	|	Таблица.ОбъемНаработки КАК ОбъемНаработки,
	|	Таблица.СтатьяРасходов КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|	&НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА НЕ СправочникПартий.Ссылка ЕСТЬ NULL 
	|				И СправочникПартий.Документ = &Документ
	|				И Таблица.ИнвентарныйУчет = СправочникПартий.ИнвентарныйУчет
	|				И Таблица.ИнвентарныйНомер = СправочникПартий.ИнвентарныйНомер
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТребуетсяНоваяПартия,
	|	ВЫБОР
	|		КОГДА НЕ СправочникПартий.Ссылка ЕСТЬ NULL 
	|				И НЕ СправочникПартий.ПометкаУдаления
	|				И СправочникПартий.Документ = &Документ
	|				И СправочникПартий.НаправлениеДеятельности = &НаправлениеДеятельности
	|				И Таблица.Дата = СправочникПартий.Дата
	|				И Таблица.КатегорияЭксплуатации = СправочникПартий.КатегорияЭксплуатации
	|				И Таблица.СрокЭксплуатации = СправочникПартий.СрокЭксплуатации
	|				И Таблица.ИнвентарныйУчет = СправочникПартий.ИнвентарныйУчет
	|				И Таблица.ИнвентарныйНомер = СправочникПартий.ИнвентарныйНомер
	|				И Таблица.ФизическоеЛицо = СправочникПартий.ФизическоеЛицо
	|				И Таблица.СпособПогашенияСтоимостиБУ = СправочникПартий.СпособПогашенияСтоимостиБУ
	|				И Таблица.СпособПогашенияСтоимостиНУ = СправочникПартий.СпособПогашенияСтоимостиНУ
	|				И Таблица.ЕдиницаИзмеренияНаработки = СправочникПартий.ЕдиницаИзмеренияНаработки
	|				И Таблица.ОбъемНаработки = СправочникПартий.ОбъемНаработки
	|				И Таблица.СтатьяРасходов = СправочникПартий.СтатьяРасходов
	|				И Таблица.АналитикаРасходов = СправочникПартий.АналитикаРасходов
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТребуетсяПерезаполнитьПартию
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Таблица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииТМЦВЭксплуатации КАК СправочникПартий
	|		ПО Таблица.ПартияТМЦВЭксплуатации = СправочникПартий.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.ПартияТМЦВЭксплуатации,
	|	ТаблицаДокумента.Документ,
	|	ТаблицаДокумента.НаправлениеДеятельности,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.КатегорияЭксплуатации,
	|	ТаблицаДокумента.СрокЭксплуатации,
	|	ТаблицаДокумента.ИнвентарныйУчет,
	|	ТаблицаДокумента.ИнвентарныйНомер,
	|	ТаблицаДокумента.СпособПогашенияСтоимостиБУ,
	|	ТаблицаДокумента.СпособПогашенияСтоимостиНУ,
	|	ТаблицаДокумента.ЕдиницаИзмеренияНаработки,
	|	ТаблицаДокумента.ОбъемНаработки,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов,
	|	ТаблицаДокумента.ФизическоеЛицо
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	НЕ ТаблицаДокумента.ТребуетсяПерезаполнитьПартию
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.ИндексСтроки,
	|	ТаблицаДокумента.ПартияТМЦВЭксплуатации,
	|	ТаблицаДокумента.Документ,
	|	ТаблицаДокумента.НаправлениеДеятельности,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.КатегорияЭксплуатации,
	|	ТаблицаДокумента.СрокЭксплуатации,
	|	ТаблицаДокумента.ИнвентарныйУчет,
	|	ТаблицаДокумента.ИнвентарныйНомер,
	|	ТаблицаДокумента.СпособПогашенияСтоимостиБУ,
	|	ТаблицаДокумента.СпособПогашенияСтоимостиНУ,
	|	ТаблицаДокумента.ЕдиницаИзмеренияНаработки,
	|	ТаблицаДокумента.ОбъемНаработки,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов,
	|	ТаблицаДокумента.ФизическоеЛицо,
	|	ТаблицаДокумента.ТребуетсяНоваяПартия
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.ТребуетсяПерезаполнитьПартию
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ПартияТМЦВЭксплуатации КАК Ссылка
	|ИЗ
	|	ДанныеДокумента КАК Таблица
	|ГДЕ
	|	Таблица.ПартияТМЦВЭксплуатации <> ЗНАЧЕНИЕ(Справочник.ПартииТМЦВЭксплуатации.ПустаяСсылка)
	|	И НЕ Таблица.ПартияТМЦВЭксплуатации В
	|				(ВЫБРАТЬ
	|					ТаблицаДокумента.ПартияТМЦВЭксплуатации
	|				ИЗ
	|					ТаблицаДокумента КАК ТаблицаДокумента
	|				ГДЕ
	|					НЕ ТаблицаДокумента.ТребуетсяПерезаполнитьПартию)";
	
	#КонецОбласти
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СтруктураПоискаПартии = Новый Структура(
		"Документ, НаправлениеДеятельности, Дата, КатегорияЭксплуатации,
		|ИнвентарныйУчет, ИнвентарныйНомер,
		|СпособПогашенияСтоимостиБУ, СпособПогашенияСтоимостиНУ, СрокЭксплуатации, ЕдиницаИзмеренияНаработки, ОбъемНаработки,
		|СтатьяРасходов, АналитикаРасходов, ФизическоеЛицо");
	
	АктуальныеПартии = Новый Соответствие;
	ТаблицаАктуальныхПартий = Новый ТаблицаЗначений;
	ТаблицаАктуальныхПартий.Колонки.Добавить("ПартияТМЦВЭксплуатации");
	Для Каждого КлючИЗначение Из СтруктураПоискаПартии Цикл
		ТаблицаАктуальныхПартий.Колонки.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Если Не Результат[3].Пустой() Тогда
		
		Выборка = Результат[3].Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаАктуальныхПартий.Добавить(), Выборка);
			АктуальныеПартии.Вставить(Выборка.ПартияТМЦВЭксплуатации, Истина);
		КонецЦикла;
		
	КонецЕсли;
	
	ТабличнаяЧасть = ?(ЭтоВводОстатков, Объект.ТМЦВЭксплуатации, Объект.Товары);
	
	Если Не Результат[4].Пустой() Тогда
		
		Выборка = Результат[4].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаТабличнойЧасти = ТабличнаяЧасть[Выборка.ИндексСтроки];
			
			ЗаполнитьЗначенияСвойств(СтруктураПоискаПартии, Выборка);
			НайденныеСтроки = ТаблицаАктуальныхПартий.НайтиСтроки(СтруктураПоискаПартии);
			Если НайденныеСтроки.Количество() <> 0 Тогда
				СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации = НайденныеСтроки[0].ПартияТМЦВЭксплуатации;
				Продолжить;
			КонецЕсли;
			
			ОбъектПартии = Неопределено;
			Если Выборка.ТребуетсяНоваяПартия Или АктуальныеПартии.Получить(СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации) <> Неопределено Тогда
				ОбъектПартии = Справочники.ПартииТМЦВЭксплуатации.СоздатьЭлемент();
			Иначе
				ОбъектПартии = СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации.ПолучитьОбъект();
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ОбъектПартии, Выборка);
			ОбъектПартии.ПометкаУдаления = Ложь;
			
			Попытка
				ОбъектПартии.Записать();
			Исключение
				Отказ = Истина;
				ВызватьИсключение ИнформацияОбОшибке().Описание;
			КонецПопытки;
			
			СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации = ОбъектПартии.Ссылка;
			АктуальныеПартии.Вставить(СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации, Истина);
			
			СтрокаАктуальнойПартии = ТаблицаАктуальныхПартий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаАктуальнойПартии, Выборка);
			СтрокаАктуальнойПартии.ПартияТМЦВЭксплуатации = СтрокаТабличнойЧасти.ПартияТМЦВЭксплуатации;
			
		КонецЦикла;
	КонецЕсли;
	
	Если Не Результат[5].Пустой() Тогда
		
		Выборка = Результат[5].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если АктуальныеПартии.Получить(Выборка.Ссылка) = Неопределено Тогда
				
				ОбъектПартии = Выборка.Ссылка.ПолучитьОбъект();
				ОбъектПартии.ПометкаУдаления = Истина;
				Попытка
					ОбъектПартии.Записать();
				Исключение
					Отказ = Истина;
					ВызватьИсключение ИнформацияОбОшибке().Описание;
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ТМЦВЭксплуатацииВызовСервера.ОбработкаПолученияДанныхВыбораПартииТМЦВЭксплуатации(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

