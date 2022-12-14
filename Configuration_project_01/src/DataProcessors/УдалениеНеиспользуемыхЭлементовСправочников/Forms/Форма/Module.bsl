
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ИсключаемыеСправочники = ПолучитьИсключаемыеСправочники();
	// заполнение списка справочников
	Для каждого Справочник Из Метаданные.Справочники Цикл
		Если ИсключаемыеСправочники.Найти(Справочник) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.СписокСправочников.Добавить();
		НоваяСтрока.ИмяСправочника = Справочник.Имя;
		НоваяСтрока.ПредставлениеСправочника = Справочник.Представление();
	КонецЦикла;
	Объект.СписокСправочников.Сортировать("ПредставлениеСправочника");
	Для Каждого СтрокаТаблицы Из Объект.СписокСправочников Цикл
		СтрокаТаблицы.НомерСтрокиСписка = Объект.СписокСправочников.Индекс(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Элементы.ДекорацияРезервнаяКопия.Видимость = Не ПараметрыРаботыКлиента.РазделениеВключено
		И ОбщегоНазначенияКлиент.ПредлагатьСоздаватьРезервныеКопии();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияРезервнаяКопияНажатие(Элемент)
	// Резервная копия ИБ
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЖурналРегистрацииНажатие(Элемент)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СобытиеЖурналаРегистрации", НСтр("ru='ПоискИУдалениеНеиспользуемыхЭлементовСправочников'"));
	ПараметрыФормы.Вставить("ДатаНачала", ДатаВремяЗапуска);

	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписоксправочников

&НаКлиенте
Процедура СписокСправочниковПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Элемент.ТекущийЭлемент.Имя = "СписокСправочниковЕстьОтборКУдалению" ИЛИ
		Элемент.ТекущийЭлемент.Имя = "СписокСправочниковЕстьОтборКИсключению" Тогда
		НастроитьУсловияОтбора("");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	ЗаполнитьПометки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	ЗаполнитьПометки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	Если НЕ ПроверитьПометкиВСписке() Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не выбран ни один справочник'"));
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаОжидание;
	Элементы.КоманднаяПанель_Поиск.ПодчиненныеЭлементы.ФормаВыполнитьПоиск.Видимость = Ложь;
	ПодключитьОбработчикОжидания("ОбработчикОжиданияУдаление", 0.1, Истина); 
КонецПроцедуры

&НаКлиенте
Процедура НастроитьУсловияОтбора(Команда)
	
	СтрокаТаблицыСправочников = Объект.СписокСправочников[Элементы.СписокСправочников.ТекущиеДанные.НомерСтрокиСписка];
	Если НЕ СтрокаТаблицыСправочников.Пометка Тогда
		СтрокаТаблицыСправочников.Пометка = Истина;
	КонецЕсли;
	
	ПараметрыФормыОтбора = Новый Структура();
	ПараметрыФормыОтбора.Вставить("ИмяСправочника");
	ПараметрыФормыОтбора.Вставить("ПредставлениеСправочника");
	ПараметрыФормыОтбора.Вставить("ОтборКомпоновкиДанных");
	ПараметрыФормыОтбора.Вставить("ОтборКомпоновкиДанныхИсключения");

	ЗаполнитьЗначенияСвойств(ПараметрыФормыОтбора, СтрокаТаблицыСправочников);
	
	РезультатНастройкиОтбора = Неопределено;

	
	ОткрытьФорму("Обработка.УдалениеНеиспользуемыхЭлементовСправочников.Форма.ФормаНастройкаОтбора", ПараметрыФормыОтбора,,,,, Новый ОписаниеОповещения("НастроитьУсловияОтбораЗавершение", ЭтотОбъект, Новый Структура("СтрокаТаблицыСправочников", СтрокаТаблицыСправочников)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьУсловияОтбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтрокаТаблицыСправочников = ДополнительныеПараметры.СтрокаТаблицыСправочников;
    
    
    РезультатНастройкиОтбора = Результат;
    
    Если РезультатНастройкиОтбора = Неопределено ИЛИ НЕ ЗначениеЗаполнено(РезультатНастройкиОтбора)
        ИЛИ ТипЗнч(РезультатНастройкиОтбора) <> Тип("Структура") Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьЗначенияСвойств(СтрокаТаблицыСправочников, РезультатНастройкиОтбора);
    Если РезультатНастройкиОтбора.ОтборКомпоновкиДанных.Количество() > 0 Тогда
        СтрокаТаблицыСправочников.ОтборКомпоновкиДанных.Элементы.Очистить();
        Для Каждого ЭлементОтбора Из РезультатНастройкиОтбора.ОтборКомпоновкиДанных Цикл
            ТипЭлементаОтбора = ТипЗнч(ЭлементОтбора);
            НовыйЭлемент = СтрокаТаблицыСправочников.ОтборКомпоновкиДанных.Элементы.Добавить(ТипЭлементаОтбора);
            ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);
        КонецЦикла;
    КонецЕсли;
    Если РезультатНастройкиОтбора.ОтборКомпоновкиДанныхИсключения.Количество() > 0 Тогда
        СтрокаТаблицыСправочников.ОтборКомпоновкиДанныхИсключения.Элементы.Очистить();
        Для Каждого ЭлементОтбора Из РезультатНастройкиОтбора.ОтборКомпоновкиДанныхИсключения Цикл
            ТипЭлементаОтбора = ТипЗнч(ЭлементОтбора);
            НовыйЭлемент = СтрокаТаблицыСправочников.ОтборКомпоновкиДанныхИсключения.Элементы.Добавить(ТипЭлементаОтбора);
            ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);
        КонецЦикла;
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Работа с формой

&НаСервере
Процедура ЗаполнитьПометки(ЗначениеЗаполнения)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.СписокСправочников.ЗаполнитьЗначения(ЗначениеЗаполнения, "Пометка");
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
КонецПроцедуры

&НаСервере
Функция ПроверитьПометкиВСписке()
	Для Каждого СтрокаТаблицы Из Объект.СписокСправочников Цикл
		Если СтрокаТаблицы.Пометка Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

// Поиск и удаление неиспользуемых элементов

&НаКлиенте
Процедура ОбработчикОжиданияУдаление()
	МассивПараметров = Новый Массив;
	Для Каждого ЭлементСписка Из Объект.СписокСправочников Цикл
		Если ЭлементСписка.Пометка = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура(
			"ИмяСправочника,
			|ПредставлениеСправочника,
			|ЕстьОтборКУдалению,
			|ЕстьОтборКИсключению,
			|ОтборКомпоновкиДанных,
			|ОтборКомпоновкиДанныхИсключения");
		
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭлементСписка);
		МассивПараметров.Добавить(СтруктураПараметров);
	КонецЦикла;
	Отказ = Ложь;
	НайтиИУдалитьНеиспользуемыеЭлементыСправочников(МассивПараметров, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	ТаблицаРезультаты.Очистить();
	Для Каждого СтруктураПараметров Из МассивПараметров Цикл
		СтрокаРезультат = ТаблицаРезультаты.Добавить();
		СтрокаРезультат.Справочник = СтруктураПараметров.ПредставлениеСправочника;
		СтрокаРезультат.Обработано = СтруктураПараметров.СчетчикВсегоОбъектов;
		СтрокаРезультат.Удалено = СтруктураПараметров.СчетчикУдаленныхОбъектов;
	КонецЦикла;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаРезультат;
	Элементы.КоманднаяПанель_Поиск.ПодчиненныеЭлементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	Элементы.КоманднаяПанель_Поиск.ПодчиненныеЭлементы.ФормаЗакрыть.Заголовок = НСтр("ru = 'Закрыть'");
	
КонецПроцедуры

&НаСервере
Процедура НайтиИУдалитьНеиспользуемыеЭлементыСправочников(МассивПараметров, Отказ)
	ДатаВремяЗапуска = ТекущаяДатаСеанса();
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недостаточно прав для выполнения операции'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Попытка
		Если НЕ МонопольныйРежим() Тогда
			УстановитьМонопольныйРежим(Истина);
		КонецЕсли;
	Исключение
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось установить монопольный режим'"));
		Возврат;
	КонецПопытки;
	// Вспомогательные данные, которые заполняются и используются в процессе удаления
	ИсключенияПоискаСсылок = Неопределено;
	ВедущиеИзмеренияРегистровСведений = Неопределено;
	ВсеПодчиненныеСправочники = Неопределено;
	// Цикл по обрабатываемым справочникам	
	Для Каждого СтруктураПараметров Из МассивПараметров Цикл
		НайтиИУдалитьНеиспользуемыеЭлементыСправочника(СтруктураПараметров, ИсключенияПоискаСсылок, 
			ВедущиеИзмеренияРегистровСведений, ВсеПодчиненныеСправочники);
	КонецЦикла;
	
	Попытка
		Если МонопольныйРежим() Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось снять монопольный режим'"));
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура НайтиИУдалитьНеиспользуемыеЭлементыСправочника(СтруктураПараметров, ИсключенияПоискаСсылок, 
										ВедущиеИзмеренияРегистровСведений, ВсеПодчиненныеСправочники)
	
	ИмяСправочника = СтруктураПараметров.ИмяСправочника;
	ПредставлениеСправочника = СтруктураПараметров.ПредставлениеСправочника;
	РазмерПорции = 100;
	СтруктураПараметров.Вставить("СчетчикВсегоОбъектов", 0);
	СтруктураПараметров.Вставить("СчетчикУдаленныхОбъектов", 0);
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	// Создание временной таблицы из обрабатываемых элементов справочников, со всеми отборами.
	Если СтруктураПараметров.ЕстьОтборКУдалению ИЛИ СтруктураПараметров.ЕстьОтборКИсключению Тогда
		ТекстЗапросаБазовый = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|*
		|ИЗ Справочник."+ИмяСправочника+" КАК Справочник
		|ГДЕ (НЕ Справочник.Предопределенный)";
		Если СтруктураПараметров.ЕстьОтборКУдалению Тогда
			ЗапросСОтборамиКУдалению = ПолучитьЗапросСОтборомКомпоновкиДанных(ТекстЗапросаБазовый, 
															СтруктураПараметров.ОтборКомпоновкиДанных);
			ЗапросСОтборамиКУдалению.МенеджерВременныхТаблиц = МенеджерВТ;
			// пока запрос не выполняем, возможны разные варианты его обработки
		КонецЕсли;
		Если СтруктураПараметров.ЕстьОтборКИсключению Тогда
			ЗапросСОтборамиКИсключению = ПолучитьЗапросСОтборомКомпоновкиДанных(ТекстЗапросаБазовый, 
															СтруктураПараметров.ОтборКомпоновкиДанныхИсключения);
			ЗапросСОтборамиКИсключению.МенеджерВременныхТаблиц = МенеджерВТ;
			ЗапросСОтборамиКИсключению.Текст = СтрЗаменить(ЗапросСОтборамиКИсключению.Текст, 
														"ИЗ", "ПОМЕСТИТЬ РезультатОтбораКИсключению ИЗ");
			ЗапросСОтборамиКИсключению.Выполнить();
		КонецЕсли;
		
		// Составляем итоговый запрос в зависимости от комбинаций флагов
		Если СтруктураПараметров.ЕстьОтборКУдалению И НЕ СтруктураПараметров.ЕстьОтборКИсключению Тогда
			ЗапросСОтборамиКУдалению.Текст = СтрЗаменить(ЗапросСОтборамиКУдалению.Текст, 
														"ИЗ","ПОМЕСТИТЬ ВыборкаСправочник ИЗ");
			ЗапросСОтборамиКУдалению.Выполнить();
		ИначеЕсли НЕ СтруктураПараметров.ЕстьОтборКУдалению И СтруктураПараметров.ЕстьОтборКИсключению Тогда
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
			
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|Ссылка
			|ПОМЕСТИТЬ ВыборкаСправочник
			|ИЗ Справочник."+ИмяСправочника+" КАК Справочник
			|ГДЕ (НЕ Справочник.Предопределенный) И 
			| Ссылка НЕ В (ВЫБРАТЬ Ссылка ИЗ РезультатОтбораКИсключению)";
			Запрос.Выполнить();
		Иначе  //есть и отбор к удалению, и отбор к исключению
			ЗапросСОтборамиКУдалению.Текст = СтрЗаменить(ЗапросСОтборамиКУдалению.Текст, 
											"ИЗ", "ПОМЕСТИТЬ РезультатОтбораКУдалению ИЗ");
			ЗапросСОтборамиКУдалению.Выполнить();
			
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;

			Запрос.Текст = "ВЫБРАТЬ 
			|Ссылка
			|ПОМЕСТИТЬ ВыборкаСправочник
			|ИЗ РезультатОтбораКУдалению
			|ГДЕ Ссылка НЕ В (ВЫБРАТЬ Ссылка ИЗ РезультатОтбораКИсключению)";
			Запрос.Выполнить();
		КонецЕсли;	
	Иначе
		// Нет никаких отборов
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;

		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|Ссылка
		|ПОМЕСТИТЬ ВыборкаСправочник
		|ИЗ Справочник."+ИмяСправочника+" КАК Справочник
		|ГДЕ (НЕ Справочник.Предопределенный)";
		Запрос.Выполнить();
	КонецЕсли;
	СчетчикВсегоОбъектов = 0;
	
	// Посчитаем сколько всего позиций будет обработано
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;

	Запрос.Текст = "ВЫБРАТЬ
	|Количество(Ссылка) КАК Количество
	|ИЗ ВыборкаСправочник
	|";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СчетчикВсегоОбъектов = Выборка.Количество;
	КонецЕсли;
	Если СчетчикВсегоОбъектов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсключенияПоискаСсылок = Неопределено Тогда
		ИсключенияПоискаСсылок = ОбщегоНазначения.ИсключенияПоискаСсылок();
	КонецЕсли;

	Если ВедущиеИзмеренияРегистровСведений = Неопределено Тогда
		ВедущиеИзмеренияРегистровСведений = Новый Соответствие;
	КонецЕсли;
	
	// Поиск у каких справочников данный справочник является владельцем
	ПодчиненныеСправочники = Новый Соответствие;
	Если ВсеПодчиненныеСправочники = Неопределено Тогда
		ВсеПодчиненныеСправочники = Новый Структура;
		Для каждого Справочник Из Метаданные.Справочники Цикл
			ИмяПодчиненного = Справочник.Имя;
			Если Справочник.Владельцы.Количество() > 0 Тогда
				МассивВладельцев = Новый Массив;
				Для каждого СправочникВладелец Из Справочник.Владельцы Цикл
					МассивВладельцев.Добавить(СправочникВладелец.Имя);
					Если СправочникВладелец.Имя = ИмяСправочника Тогда
						ПодчиненныеСправочники.Вставить(ИмяПодчиненного, Тип("СправочникСсылка."+ИмяПодчиненного)); 
					КонецЕсли;
				КонецЦикла;
				ВсеПодчиненныеСправочники.Вставить(ИмяПодчиненного, МассивВладельцев);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ПодчиненныйСправочник Из ВсеПодчиненныеСправочники Цикл
			ИмяПодчиненного = ПодчиненныйСправочник.Ключ;
			МассивВладельцев = ПодчиненныйСправочник.Значение;
			Если МассивВладельцев.Найти(ИмяСправочника) <> Неопределено Тогда
				ПодчиненныеСправочники.Вставить(ИмяПодчиненного, Тип("СправочникСсылка."+ИмяПодчиненного)); 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивОбработанныхЭлементов = Новый Массив();
	МассивЭлементовКУдалению = Новый Массив();
	МассивПодчиненныхЭлементовКУдалению = Новый Массив();

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ "+РазмерПорции+"
	|	Ссылка
	|ИЗ
	|	ВыборкаСправочник
	|ГДЕ
	|	
	| НЕ Ссылка В (&МассивОбработанныхЭлементов)
	|";
	
	Запрос.УстановитьПараметр("МассивОбработанныхЭлементов", Новый Массив);
	РезультатЗапроса = Запрос.Выполнить();
	
	Пока НЕ РезультатЗапроса.Пустой() Цикл //Обработка порциями
		МассивСсылок = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		// запомним обрабатываемые элементы для следующего прохода
		Для Каждого ЭлементМассива Из МассивСсылок Цикл
			МассивОбработанныхЭлементов.Добавить(ЭлементМассива);
		КонецЦикла;
		
		ТабСсылок = НайтиПоСсылкам(МассивСсылок);
		
		МассивТиповСсылкиНаПодчиненныеСправочники = Новый Массив;
		МассивЭлементовСоСсылкамиНаПодчиненные = Новый Массив;
		МассивСтрокКУдалению = Новый Массив();
		
		// Из таблицы ссылок необходимо удалить лишние строки 
		// 1) которые являются исключением 
		// 2) Данные = Регистр сведений со ссылкой на ведущее измерение.
		Для Каждого СтрокаТаблицыСсылок Из ТабСсылок Цикл
			ПолноеИмяЗависимогоОбъекта = СтрокаТаблицыСсылок.Метаданные.ПолноеИмя();
			// Проверка того что ссылка является исключением
			Если ТипЗнч(ИсключенияПоискаСсылок) = Тип("Массив") Тогда
				Если ИсключенияПоискаСсылок.Найти(ПолноеИмяЗависимогоОбъекта) <> Неопределено Тогда
					МассивСтрокКУдалению.Добавить(СтрокаТаблицыСсылок);
					Продолжить;
				КонецЕсли;
			ИначеЕсли  ТипЗнч(ИсключенияПоискаСсылок) = Тип("Соответствие") Тогда
				Если ИсключенияПоискаСсылок.Получить(ПолноеИмяЗависимогоОбъекта) <> Неопределено Тогда
					МассивСтрокКУдалению.Добавить(СтрокаТаблицыСсылок);
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Если ПодчиненныеСправочники.Количество() > 0 
				И ОбщегоНазначения.ЭтоСправочник(СтрокаТаблицыСсылок.Метаданные)  Тогда
				// Возможно это ссылка из подчиненного справочника - запишем чтобы потом обработать отдельно.
				Если ПодчиненныеСправочники[СтрокаТаблицыСсылок.Метаданные.Имя] <> Неопределено И
					СтрокаТаблицыСсылок.Данные.Владелец = СтрокаТаблицыСсылок.Ссылка Тогда
					ТипДанных = ТипЗнч(СтрокаТаблицыСсылок.Данные);
					Если  МассивТиповСсылкиНаПодчиненныеСправочники.Найти(ТипДанных) = Неопределено Тогда
						МассивТиповСсылкиНаПодчиненныеСправочники.Добавить(ТипДанных);
					КонецЕсли;
					Если МассивЭлементовСоСсылкамиНаПодчиненные.Найти(СтрокаТаблицыСсылок.Ссылка) = Неопределено Тогда
						МассивЭлементовСоСсылкамиНаПодчиненные.Добавить(СтрокаТаблицыСсылок.Ссылка);
					КонецЕсли;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			Если НЕ ОбщегоНазначения.ЭтоРегистрСведений(СтрокаТаблицыСсылок.Метаданные) Тогда
				Продолжить;
			КонецЕсли;
			
			ВедущиеИзмерения = ВедущиеИзмеренияРегистровСведений[ПолноеИмяЗависимогоОбъекта];

			Если ВедущиеИзмерения = Неопределено Тогда
				// Заполнение измерений
				ВедущиеИзмерения = Новый Массив;
				ВедущиеИзмеренияРегистровСведений.Вставить(ПолноеИмяЗависимогоОбъекта, ВедущиеИзмерения);

				Для каждого Измерение Из СтрокаТаблицыСсылок.Метаданные.Измерения Цикл
					Если Измерение.Ведущее Тогда
						ВедущиеИзмерения.Добавить(Измерение.Имя);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ВедущиеИзмерения.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			УдаляемыйОбъектВВедущемИзмерении = Ложь;
			Для Каждого ВедущееИзмерение Из ВедущиеИзмерения Цикл
				Если СтрокаТаблицыСсылок.Данные[ВедущееИзмерение] = СтрокаТаблицыСсылок.Ссылка Тогда
					УдаляемыйОбъектВВедущемИзмерении = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если УдаляемыйОбъектВВедущемИзмерении Тогда
				МассивСтрокКУдалению.Добавить(СтрокаТаблицыСсылок);
			КонецЕсли;
		КонецЦикла;
		// Удаление лишних строк из таблицы ссылок
		Для Каждого СтрокаТЗ Из МассивСтрокКУдалению Цикл
			ТабСсылок.Удалить(СтрокаТЗ);
		КонецЦикла;
		
		// Поиск позиций, на которые нет ссылок
		ЗапросНаУдаление = Новый Запрос;
		ЗапросНаУдаление.МенеджерВременныхТаблиц = МенеджерВТ;
		ЗапросНаУдаление.Текст = 
		"ВЫБРАТЬ 
		|	Ссылка 
		|ИЗ
		|	ВыборкаСправочник
		|ГДЕ
		|	(НЕ Ссылка В (&СписокИспользуемых))
		|	И Ссылка В (&ТекущаяПорция)
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		ТабСсылокСвернутая = ТабСсылок.Скопировать();
		ТабСсылокСвернутая.Свернуть("Ссылка");

		ЗапросНаУдаление.УстановитьПараметр("СписокИспользуемых", ТабСсылокСвернутая.ВыгрузитьКолонку("Ссылка"));
		// Явно задаем состав обрабатываемой порции, чтобы не удалилось лишнего
		ЗапросНаУдаление.УстановитьПараметр("ТекущаяПорция", МассивСсылок);      
		
		Результат = ЗапросНаУдаление.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				МассивЭлементовКУдалению.Добавить(Выборка.Ссылка);
			КонецЦикла;
		КонецЕсли;
		
		// Обработка справочников, имеющих подчиненные элементы
		Если МассивТиповСсылкиНаПодчиненныеСправочники.Количество() > 0 
			И МассивЭлементовСоСсылкамиНаПодчиненные.Количество() > 0 Тогда
			
			ОписаниеТиповПодчиненныеСправочники = Новый ОписаниеТипов(МассивТиповСсылкиНаПодчиненныеСправочники);
			
			// Поиск позиций справочника, ссылки на который есть только у подчиненных справочников.
			Для Каждого ТекЭлемент Из МассивЭлементовСоСсылкамиНаПодчиненные Цикл
				МассивСсылокНаЭлемент = ТабСсылок.НайтиСтроки(Новый Структура("Ссылка", ТекЭлемент));
				СсылкиНаПодчиненныеЭлементы = Новый Массив;
				СсылкиТолькоНаПодчиненныеЭлементы = Истина;
				Для Каждого СтрокаСсылок Из МассивСсылокНаЭлемент Цикл
					Если ОписаниеТиповПодчиненныеСправочники.СодержитТип(ТипЗнч(СтрокаСсылок.Данные))
						И СтрокаСсылок.Данные.Владелец = текЭлемент Тогда
						СсылкиНаПодчиненныеЭлементы.Добавить(СтрокаСсылок.Данные);
					Иначе
						СсылкиТолькоНаПодчиненныеЭлементы = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ СсылкиТолькоНаПодчиненныеЭлементы Тогда
					Продолжить;
				КонецЕсли;
				// На текущий элемент справочника есть ссылки только у подчиненных справочников
				// Поиск ссылок на подчиненные справочники.
				ТабСсылокНаПодчиненные = НайтиПоСсылкам(СсылкиНаПодчиненныеЭлементы);
				МожноУдалятьПодчиненные = Ложь;
				Если ТабСсылокНаПодчиненные.Количество() = 0 Тогда
					МожноУдалятьПодчиненные = Истина;
				Иначе
					// проверка, возможно ссылки только на элемент-владелец
					МожноУдалятьПодчиненные = Истина;
					Для Каждого СтрокаСсылкиНаПодчиненные Из ТабСсылокНаПодчиненные Цикл
						Если СтрокаСсылкиНаПодчиненные.Данные <> текЭлемент Тогда
							МожноУдалятьПодчиненные = Ложь;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				Если МожноУдалятьПодчиненные Тогда
					Для Каждого ПодчиненныйЭлемент Из СсылкиНаПодчиненныеЭлементы Цикл
						МассивПодчиненныхЭлементовКУдалению.Добавить(ПодчиненныйЭлемент);
					КонецЦикла;
					// Удаление текущего элемента справочника
					МассивЭлементовКУдалению.Добавить(текЭлемент);
				КонецЕсли;
			КонецЦикла; //Для Каждого ТекЭлемент Из МассивЭлементовСоСсылкамиНаПодчиненные Цикл
		КонецЕсли;  //Если МассивТиповСсылкиНаПодчиненныеСправочники.Количество() > 0
		// Получим очередную порцию данных
		Запрос.УстановитьПараметр("МассивОбработанныхЭлементов", МассивОбработанныхЭлементов);
		РезультатЗапроса = Запрос.Выполнить();

	КонецЦикла;  //Пока Истина Цикл //Обработка порциями
	
	СчетчикУдаленныхПодчиненныхОбъектов = 0;
	Для Каждого ЭлементКУдалению Из МассивПодчиненныхЭлементовКУдалению Цикл
		УдалитьЭлементСправочника(ЭлементКУдалению, СчетчикУдаленныхПодчиненныхОбъектов);
	КонецЦикла;
	СчетчикУдаленныхОбъектов = 0;
	Для Каждого ЭлементКУдалению Из МассивЭлементовКУдалению Цикл
		УдалитьЭлементСправочника(ЭлементКУдалению, СчетчикУдаленныхОбъектов);
	КонецЦикла;
	
	СтруктураПараметров.Вставить("СчетчикВсегоОбъектов", СчетчикВсегоОбъектов);
	СтруктураПараметров.Вставить("СчетчикУдаленныхОбъектов", СчетчикУдаленныхОбъектов);

КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементСправочника(Ссылка, СчетчикУдаленныхОбъектов)
	ПредставлениеОбъекта = СокрЛП(Ссылка);
	МетаданныеОбъекта = Ссылка.Метаданные();
	ПараметрыЖурнала = Новый Структура();
	ПараметрыЖурнала.Вставить("ГруппаСобытий", НСтр("ru='ПоискИУдалениеНеиспользуемыхЭлементовСправочников'"));
	ПараметрыЖурнала.Вставить("Метаданные", МетаданныеОбъекта);
	ПараметрыЖурнала.Вставить("Данные", Неопределено);
	
	Попытка
		СпрОбъект = Ссылка.ПолучитьОбъект();
		СпрОбъект.Удалить();
	Исключение
		УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		ПараметрыЖурнала.Вставить("Данные", Ссылка);
		ИмяСобытия = НСтр("ru='Не удалось удалить элемент справочника'")+ПредставлениеОбъекта;
		
		ОбщегоНазначенияУТ.ЗаписатьВЖурналСообщитьПользователю(ПараметрыЖурнала,УровеньЖурнала,"",ИмяСобытия,ОписаниеОшибки());
		
		Возврат;
	КонецПопытки;
	
	УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
	ИмяСобытия = НСтр("ru='Удален:'") + " " + ПредставлениеОбъекта;
	
	ОбщегоНазначенияУТ.ЗаписатьВЖурналСообщитьПользователю(ПараметрыЖурнала, УровеньЖурнала, "", ИмяСобытия);

	СчетчикУдаленныхОбъектов = СчетчикУдаленныхОбъектов + 1;
КонецПроцедуры

&НаСервере
// Функция получает запрос с учетом отборов
// Параметры:
// БазовыйЗапрос - строка, основной запрос на который следует наложить отборы
// ОтборКомпоновкиДанных - отбор, который следует применить к запросу.
Функция ПолучитьЗапросСОтборомКомпоновкиДанных(БазовыйЗапрос, ОтборКомпоновкиДанных)
	СКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникиДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникиДанных.Имя = "ИсточникДанных";
	ИсточникиДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = "ИсточникДанных";
	НаборДанных.Имя = "ЗапросПоСправочнику";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.Запрос = БазовыйЗапрос;
	
	ПолеСсылка = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеСсылка.Заголовок = "Ссылка";
	ПолеСсылка.ПутьКДанным = "Ссылка";
	ПолеСсылка.Поле = "Ссылка";
	
	НастройкиКомпоновкиДанных = СКД.НастройкиПоУмолчанию;
	
	ГруппировкаСсылка = НастройкиКомпоновкиДанных.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = ГруппировкаСсылка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));    
	ПолеГруппировки.Использование = Истина;
	ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	Для Каждого ЭлементОтбора Из ОтборКомпоновкиДанных.Элементы Цикл
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(ТипЗнч(ЭлементОтбора));
		ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
	КонецЦикла;
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СКД, КомпоновщикНастроек.ПолучитьНастройки());
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных[0].Запрос);
	Для каждого ПараметрКомпоновки Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.УстановитьПараметр(ПараметрКомпоновки.Имя, ПараметрКомпоновки.Значение);
	КонецЦикла;

	Возврат Запрос;

КонецФункции

// Функция получает массив справочников, которые не следует отображать в списке доступных для обработки.
Функция ПолучитьИсключаемыеСправочники()
	МетаСправочники = Метаданные.Справочники;
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить(МетаСправочники.ИдентификаторыОбъектовМетаданных);
	МассивИсключений.Добавить(МетаСправочники.КлассификаторБанков);
	МассивИсключений.Добавить(МетаСправочники.КлючевыеОперации);
	МассивИсключений.Добавить(МетаСправочники.ОчередьЗаданий);
	МассивИсключений.Добавить(МетаСправочники.ПоставляемыеДанные);
	МассивИсключений.Добавить(МетаСправочники.ПредопределенныеВариантыОтчетов);
	МассивИсключений.Добавить(МетаСправочники.ПроизводственныеКалендари);
	МассивИсключений.Добавить(МетаСправочники.СообщенияСистемы);
	МассивИсключений.Добавить(МетаСправочники.СценарииОбменовДанными);
	МассивИсключений.Добавить(МетаСправочники.ТомаХраненияФайлов);
	МассивИсключений.Добавить(МетаСправочники.ШаблоныЗаданийОчереди);
	Возврат МассивИсключений;
КонецФункции

#КонецОбласти
