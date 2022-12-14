#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ОрганизацияОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.КассоваяКнигаОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	
	СтрокаВалютаРеглУчета = Строка(Константы.ВалютаРегламентированногоУчета.Получить());
	Элементы.Излишек.Заголовок = Элементы.Излишек.Заголовок + " (" + СтрокаВалютаРеглУчета + ")";
	Элементы.Недостача.Заголовок = Элементы.Недостача.Заголовок + " (" + СтрокаВалютаРеглУчета + ")";
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыПриСозданииНаСервере.КолонкаСостоянияЭДО = Элементы.ПредставлениеСостояния;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	КассоваяКнига = Настройки.Получить("КассоваяКнига");
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновленияВидимостиСостоянияЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	КассоваяКнига = Неопределено;
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Организация));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКассовойКнигиОтбор", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.КассовыеКниги.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКассовойКнигиОтбор(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		КассоваяКнига = Результат;
		КассоваяКнигаПредставление = Строка(КассоваяКнига);
		УстановитьОтборДинамическихСписков();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборОчистка(Элемент, СтандартнаяОбработка)
	
	КассоваяКнига = Неопределено;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КассоваяКнига = ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.КассовыеКниги.ПустаяСсылка") Тогда
		ВыбранноеЗначение = НСтр("ru = '<Основная кассовая книга организации>'");
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВидимостьСостоянияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(ЭтотОбъект, Элементы.ПредставлениеСостояния);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредставлениеСостояния Тогда
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбменСКонтрагентамиКлиент.ДекорацияСостояниеЭДОФормаСпискаНажатие(ВыбраннаяСтрока, СтандартнаяОбработка);
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	КонецЕсли;
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораКассовыхКниг()
	
	Справочники.КассовыеКниги.КассовыеКнигиОрганизации(Организация, Элементы.КассоваяКнигаОтбор.СписокВыбора);
	
	Элементы.КассоваяКнигаОтбор.Доступность = Элементы.КассоваяКнигаОтбор.СписокВыбора.Количество();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассоваяКнига", КассоваяКнига, ВидСравненияКомпоновкиДанных.Равно,, КассоваяКнига <> Неопределено);
	
КонецПроцедуры

#КонецОбласти