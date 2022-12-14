
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаДокумента = Параметры.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Элементы.ТаблицаРасходовНаправлениеДеятельности.Видимость = Справочники.НаправленияДеятельности.ИспользуетсяУчетПоНаправлениям();
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Элементы.ТаблицаРасходовСумма.Заголовок =
		СтрШаблон(НСтр("ru='Упр. учет с НДС (%1)'"), ВалютаУправленческогоУчета);
	Элементы.ТаблицаРасходовСуммаБезНДС.Заголовок =
		СтрШаблон(НСтр("ru='Упр. учет без НДС (%1)'"), ВалютаУправленческогоУчета);
	Элементы.ТаблицаРасходовСуммаРегл.Заголовок =
		СтрШаблон(НСтр("ru='Бухгалтерский учет (%1):'"), ВалютаРегламентированногоУчета);
	Элементы.ТаблицаРасходовСуммаНУ.Заголовок =
		СтрШаблон(НСтр("ru='Налоговый учет (%1):'"), ВалютаРегламентированногоУчета);
	Элементы.ТаблицаРасходовПостояннаяРазница.Заголовок =
		СтрШаблон(НСтр("ru='Постоянная разница (%1):'"), ВалютаРегламентированногоУчета);
	Элементы.ТаблицаРасходовВременнаяРазница.Заголовок =
		СтрШаблон(НСтр("ru='Временная разница (%1):'"), ВалютаРегламентированногоУчета);
	
	ЗаполнитьТаблицуРасходов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы
		И Модифицированность
		И ТаблицаРасходов.НайтиСтроки(Новый Структура("СтрокаВыбрана", Истина)).Количество() > 0 Тогда
		
		Режим = Новый СписокЗначений;
		Режим.Добавить(КодВозвратаДиалога.Да,     НСтр("ru = 'Добавить'"));
		Режим.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru = 'Не добавлять'"));
		Режим.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		Оповещение = Новый ОписаниеОповещения("ПодтверждениеЗакрытия", ЭтаФорма);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Некоторые строки были выбраны. Добавить их в документ?'"), Режим);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеЗакрытия(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПеренестиРасходыВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЭлементыОтбора = Новый Массив;
	ЭлементыОтбора.Добавить("ОтборСтатьяРасходов");
	ЭлементыОтбора.Добавить("ОтборПодразделение");
	
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если Элементы[ЭлементОтбора].СписокВыбора.НайтиПоЗначению(ЭтаФорма[ЭлементОтбора]) = Неопределено Тогда
			ЭтаФорма[ЭлементОтбора] = Элементы[ЭлементОтбора].СписокВыбора[0].Значение; // пустое значение
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаРасходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Перем ИмяДанных;
	
	ТекДанные = Элементы.ТаблицаРасходов.ТекущиеДанные;
	
	НаОткрытие = Новый Структура;
	НаОткрытие.Вставить("ТаблицаРасходовПодразделение",		"Подразделение");
	НаОткрытие.Вставить("ТаблицаРасходовНаправлениеДеятельности", "НаправлениеДеятельности");
	НаОткрытие.Вставить("ТаблицаРасходовСтатьяРасходов",	"СтатьяРасходов");
	НаОткрытие.Вставить("ТаблицаРасходовАналитикаРасходов",	"АналитикаРасходов");
	
	Если ТекДанные <> Неопределено И НаОткрытие.Свойство(Поле.Имя, ИмяДанных) Тогда
		ПоказатьЗначение(Неопределено, ТекДанные[ИмяДанных]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиРасходыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРасходыВыполнить()
	
	ВыбратьВсеРасходыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРасходыВыполнить()
	
	ВыбратьВсеРасходыНаСервере(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаРасходовПодразделение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборПодразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаРасходовСтатьяРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборСтатьяРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаРасходовАналитикаРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборАналитикаРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеРасходыНаСервере(ЗначениеВыбора = Истина)
	
	СтруктураОтбора = Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора);
	
	Если ЗначениеЗаполнено(ОтборПодразделение)
		И ЗначениеВыбора Тогда
		СтруктураОтбора.Вставить("Подразделение", ОтборПодразделение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборСтатьяРасходов)
		И ЗначениеВыбора Тогда
		СтруктураОтбора.Вставить("СтатьяРасходов", ОтборСтатьяРасходов);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборАналитикаРасходов)
		И ЗначениеВыбора Тогда
		СтруктураОтбора.Вставить("АналитикаРасходов", ОтборАналитикаРасходов);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаРасходов.НайтиСтроки(СтруктураОтбора) Цикл
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьРасходыВХранилище(УникальныйИдентификатор)
	
	РезультатВыбора = ТаблицаРасходов.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	Возврат ПоместитьВоВременноеХранилище(РезультатВыбора, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуРасходов()

	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Организация",	Параметры.Организация);
	ДанныеОтбора.Вставить("Ссылка",			Параметры.Ссылка);
	ДанныеОтбора.Вставить("Дата",			ДатаДокумента);
	
	Документы.ПрочиеДоходыРасходы.ПолучитьОстаткиПрочихРасходов(
		ДанныеОтбора,
		ТаблицаРасходов);
	
	// Заполним списки выбора для элементов отбора
	Колонки = "Подразделение, НаправлениеДеятельности, СтатьяРасходов, АналитикаРасходов";
	ТЗ = ТаблицаРасходов.Выгрузить(, Колонки);
	
	ПустаяСтатья = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
	ПустоеПодр = Справочники.СтруктураПредприятия.ПустаяСсылка();
	ПустойВариант = Перечисления.ВариантыРаспределенияРасходов.ПустаяСсылка();
	
	ЗаполнитьПараметрыВыбораЭлемента(ТЗ, "АналитикаРасходов");
	
	ЗаполнитьСписокВыбораЭлемента(ТЗ, "СтатьяРасходов", ПустаяСтатья, НСтр("ru = '<по всем статьям>'"));
	ЗаполнитьСписокВыбораЭлемента(ТЗ, "Подразделение", ПустоеПодр, НСтр("ru = '<по всем подразделениям>'"));
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПараметрыВыбораЭлемента(ТЗ, ИмяКолонки)
	
	Список = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(ТЗ.ВыгрузитьКолонку(ИмяКолонки));
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(Список)));
	
	Элементы["Отбор" + ИмяКолонки].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецФункции

&НаСервере
Функция ЗаполнитьСписокВыбораЭлемента(ТЗ, ИмяКолонки, ПустоеЗначение, ОписаниеПустогоЗначения)
	
	Список = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(ТЗ.ВыгрузитьКолонку(ИмяКолонки));
	
	Элементы["Отбор" + ИмяКолонки].СписокВыбора.ЗагрузитьЗначения(Список);
	Элементы["Отбор" + ИмяКолонки].СписокВыбора.Вставить(0, ПустоеЗначение, ОписаниеПустогоЗначения);
	
КонецФункции

&НаКлиенте
Процедура ПеренестиРасходыВДокумент()
	
	Модифицированность = Ложь;
	АдресВоВременномХранилище = ПоместитьРасходыВХранилище(Этаформа.ВладелецФормы.УникальныйИдентификатор);
	Закрыть(АдресВоВременномХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатьяРасходовПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАналитикаРасходовПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтбор(Форма)
	
	ЭлементыОтбора = Новый Массив;
	ЭлементыОтбора.Добавить("ОтборСтатьяРасходов");
	ЭлементыОтбора.Добавить("ОтборАналитикаРасходов");
	ЭлементыОтбора.Добавить("ОтборПодразделение");
	
	Отбор = Новый Структура;
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ЗначениеЗаполнено(Форма[ЭлементОтбора]) Тогда
			Отбор.Вставить(СтрЗаменить(ЭлементОтбора, "Отбор", ""), Форма[ЭлементОтбора]);
		КонецЕсли;
	КонецЦикла;
	
	Форма.Элементы.ТаблицаРасходов.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	
КонецПроцедуры

#КонецОбласти
