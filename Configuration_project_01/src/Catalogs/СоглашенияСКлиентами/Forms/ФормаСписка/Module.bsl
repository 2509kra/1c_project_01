
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	Список.Параметры.УстановитьЗначениеПараметра("Партнер",          Параметры.Партнер);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПартнерОтбор", Параметры.Партнер, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	Если ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Заголовок = НСтр("ru='Соглашения с клиентом'");
	КонецЕсли;
	
	ДоступноСозданиеИндСоглашений = ПраваПользователяПовтИсп.ИзменениеИндивидуальныхСоглашений();
	Элементы.СписокСоздатьСоглашение.Видимость = ДоступноСозданиеИндСоглашений;
	Элементы.УстановитьСтатусДействует.Видимость = ДоступноСозданиеИндСоглашений;
	Элементы.УстановитьСтатусНеСогласовано.Видимость = ДоступноСозданиеИндСоглашений;
	Элементы.УстановитьСтатусЗакрыто.Видимость = ДоступноСозданиеИндСоглашений;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Параметры.Отбор.Свойство("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоРегулярностиПриСозданииНаСервере(Список, Регулярность, СтруктураБыстрогоОтбора);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("ТипСоглашения",    ТипСоглашения);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,"Типовое", НСтр("ru='Типовое'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,"Индивидуальное", НСтр("ru='Индивидуальное'"));

	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.СоглашенияСКлиентами, НСтр("ru = '<Мои соглашения>'")));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ИспользоватьТиповыеСоглашенияСКлиентами			= ПолучитьФункциональнуюОпцию("ИспользоватьТиповыеСоглашенияСКлиентами");
	ИспользоватьИндивидуальныеСоглашенияСКлиентами	= ПолучитьФункциональнуюОпцию("ИспользоватьИндивидуальныеСоглашенияСКлиентами");
	
	Если ИспользоватьТиповыеСоглашенияСКлиентами И НЕ ИспользоватьИндивидуальныеСоглашенияСКлиентами Тогда
		ТипСоглашения = "Типовое";
		
	ИначеЕсли НЕ ИспользоватьТиповыеСоглашенияСКлиентами И ИспользоватьИндивидуальныеСоглашенияСКлиентами Тогда
		ТипСоглашения = "Индивидуальное";
		
	Иначе
		Если СтруктураБыстрогоОтбора = Неопределено Тогда
			
			ТипСоглашения    = Настройки.Получить("ТипСоглашения");
			
		Иначе
			Если Не СтруктураБыстрогоОтбора.Свойство("ТипСоглашения") Тогда
				ТипСоглашения = Настройки.Получить("ТипСоглашения");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Настройки.Удалить("ТипСоглашения");
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоРегулярностиПриЗагрузкеИзНастроек(Список, Регулярность, СтруктураБыстрогоОтбора, Настройки);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТипСоглашения", ТипСоглашения, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ТипСоглашения));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСоглашенияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТипСоглашения", ТипСоглашения, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ТипСоглашения));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура РегулярностьПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьОтборВСпискеПоРегулярности(Список, Регулярность);
	
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

&НаКлиенте
Процедура УстановитьСтатусНеСогласовано(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиНеСогласовано(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиДействует(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыто(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиЗакрыто(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСоглашение(Команда)
	
	ЗначенияЗаполнения = Новый Структура("Партнер", Параметры.Партнер);
	ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	ОткрытьФорму("Справочник.СоглашенияСКлиентами.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.СоглашенияСКлиентами.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

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

#КонецОбласти

#КонецОбласти
