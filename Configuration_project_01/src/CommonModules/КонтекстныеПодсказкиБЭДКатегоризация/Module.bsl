////////////////////////////////////////////////////////////////////////////////
// КонтекстныеПодсказкиБЭДКатегоризация: механизм контекстных подсказок.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак соответствия категории общему контексту конфигурации.
//
// Параметры:
//  Категория - ПланВидовХарактеристикСсылка.КатегорииНовостей - категория;
//  Значение - Булево, Строка - значение категории. 
//
// Возвращаемое значение:
//  Булево - признак соответствия категории общему контексту конфигурации.
// 
Функция УдовлетворяетОбщемуКонтексту(Категория, Значение) Экспорт
	
	ФункцияРасчета = ФункцияРасчетаВнеконтекстнойКатегории(Категория); 
	
	Параметры = Новый Структура;
	Параметры.Вставить("Значение", Значение); 
	Параметры.Вставить("Результат", Ложь); 
	
	ОбщегоНазначения.ВыполнитьВБезопасномРежиме("Параметры.Результат = КонтекстныеПодсказкиБЭДКатегоризация." 
													+ ФункцияРасчета + "(Параметры.Значение)", Параметры); 
	
	Возврат Параметры.Результат;
	
КонецФункции

// Возвращает признак принадлежности категории к внеконтекстным.
//
// Параметры:
//  Категория - ПланВидовХарактеристикСсылка.КатегорииНовостей - категория;
//
// Возвращаемое значение:
//  Булево - признак принадлежности категории к внеконтекстным.
// 
Функция ЭтоВнеконтекстнаяКатегория(Категория) Экспорт
	
	СписокВнеконтекстныхКатегорий = КонтекстныеПодсказкиБЭДПовтИсп.СписокВнеконтекстныхКатегорий();
	
	Возврат СписокВнеконтекстныхКатегорий.Получить(Категория) <> Неопределено;
	
КонецФункции

// Возвращает параметры доступных значений для списка категорий.
//
// Параметры:
//  Категории - Массив из ПланВидовХарактеристикСсылка.КатегорииНовостей - категории получения возможного контекста;
//
// Возвращаемое значение:
//  Соответствие - параметры доступных значений категорий.
//    * Ключ - ПланВидовХарактеристикСсылка.КатегорииНовостей - категория;
//    * Значение - Структура - параметры доступных значений категории.
//      * Значения - СписокЗначений - список доступных значений категории.
//      * Типы - ОписаниеТипов - доступные типы значений категорий.
//
Функция ВозможныйКонтекст(Категории) Экспорт

	ВозможныйКонтекст = Новый Соответствие;
	
	Для Каждого Категория Из Категории Цикл 
		
		Если Не ЗначениеЗаполнено(Категория) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыДоступныхЗначений = Новый Структура; 
		
		Параметры = Новый Структура;
		Параметры.Вставить("Результат", Новый Структура);
		
		ТипЗначенияКатегории = Категория.ТипЗначения;
		
		Если ТипЗначенияКатегории.Типы().Найти(Тип("Булево")) = Неопределено Тогда
			
			КодКатегории = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Категория, "Код");
			ОбщегоНазначения.ВыполнитьВБезопасномРежиме("Параметры.Результат = КонтекстныеПодсказкиБЭДКатегоризация.ПараметрыДоступныхЗначенийКатегории_" + КодКатегории + "()", Параметры); 
			ПараметрыДоступныхЗначений = Параметры.Результат;

		Иначе
			
			ПараметрыДоступныхЗначений = ПараметрыДоступныхЗначенийКатегорииЛогическогоТипа(); 
			
		КонецЕсли;
				
		ВозможныйКонтекст.Вставить(Категория, ПараметрыДоступныхЗначений);
		
	КонецЦикла;
	
	Возврат ВозможныйКонтекст;
	
КонецФункции

#Область ВычислениеЗначенийКонтекстныхКатегорий

Функция ЕстьУчетнаяЗаписьЭДО(Организация) Экспорт 
	
	Возврат ОбменСКонтрагентамиСлужебный.ЕстьУчетнаяЗаписьЭДО(Организация);
	
КонецФункции

Функция КодОператораКонтрагента(Контрагент) Экспорт
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(АбонентыЭДО.ОператорЭДО, """") КАК ОператорКонтрагента
	|ИЗ
	|	ИмяТаблицыКонтрагенты КАК Контрагенты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АбонентыЭДО КАК АбонентыЭДО
	|		ПО Контрагенты.ИмяРеквизитаИНН = АбонентыЭДО.ИНН
	|			И Контрагенты.ИмяРеквизитаКПП = АбонентыЭДО.КПП
	|			И (Контрагенты.Ссылка = &Контрагент)";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	ИмяТаблицыКонтрагенты = ОбщегоНазначения.ИмяТаблицыПоСсылке(Контрагент);
	ИмяРеквизитаИНН = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
	ИмяРеквизитаКПП = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяТаблицыКонтрагенты", ИмяТаблицыКонтрагенты);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяРеквизитаИНН", ИмяРеквизитаИНН);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяРеквизитаКПП", ИмяРеквизитаКПП);

	Запрос.Текст = ТекстЗапроса;
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапроса.Следующий() Тогда
		Возврат ВыборкаЗапроса.ОператорКонтрагента;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция КонтрагентПодключенКЭДО(Контрагент) Экспорт
	    
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СостоянияКонтрагентовБЭД.Контрагент КАК Контрагент
	|ИЗ
	|	РегистрСведений.СостоянияКонтрагентовБЭД КАК СостоянияКонтрагентовБЭД
	|ГДЕ
	|	СостоянияКонтрагентовБЭД.Контрагент = &Контрагент
	|	И СостоянияКонтрагентовБЭД.Состояние = &Состояние";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Состояние", Перечисления.СостоянияКонтрагентаБЭД.Подключен);
	
	Возврат Запрос.Выполнить().Пустой();

КонецФункции

Функция СтатусДокументооборота(УчетныйДокумент) Экспорт
	
	СостояниеВерсийЭД = ОбменСКонтрагентамиСлужебный.ДанныеСостоянияЭД(УчетныйДокумент).СостояниеВерсииЭД;
	
	Если Не ЗначениеЗаполнено(СостояниеВерсийЭД) Тогда
		Возврат "";
	КонецЕсли;

	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(СостояниеВерсийЭД);
	
КонецФункции

Функция ЗначениеТипаЭД(ТипЭД) Экспорт
	
	Если Не ЗначениеЗаполнено(ТипЭД) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(ТипЭД);
	
КонецФункции

Функция ЗначениеСтатусаЭД(ФайлЭД) Экспорт
	
	Если Не ЗначениеЗаполнено(ФайлЭД) Тогда
		Возврат "";
	КонецЕсли;
	
	СтатусЭД = ФайлЭД.СтатусЭД;
	
	Если Не ЗначениеЗаполнено(СтатусЭД) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(СтатусЭД);
	
КонецФункции

Функция ЗначениеСостоянияВерсииЭД(СостояниеВерсииЭД) Экспорт
	
	Если Не ЗначениеЗаполнено(СостояниеВерсииЭД) Тогда
		Возврат "";
	КонецЕсли; 
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(СостояниеВерсииЭД);
	
КонецФункции

Функция ЗначениеВидаЭД(ВидЭД) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидЭД) Тогда
		Возврат "";
	КонецЕсли;
	 	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(ВидЭД);
	
КонецФункции

Функция ЗначениеНаправленияЭД(НаправлениеЭД) Экспорт
	
	Если Не ЗначениеЗаполнено(НаправлениеЭД) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(НаправлениеЭД);
	
КонецФункции

Функция СуществуютНеверныеПодписиФайла(ПрисоединенныйФайл) Экспорт
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭлектронныеПодписи = ОбменСКонтрагентамиСлужебный.УстановленныеПодписи(ПрисоединенныйФайл);
	
	Для Каждого СтрокаЭлектроннойПодписи Из ЭлектронныеПодписи Цикл
		Если Не СтрокаЭлектроннойПодписи.ПодписьВерна Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция СвязьОрганизацииСКонтрагентомНастроена(Организация, Контрагент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации
		|			И (ПриглашенияКОбменуЭлектроннымиДокументами.Контрагент = &Контрагент)
		|			И (ПриглашенияКОбменуЭлектроннымиДокументами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Принято))
		|ГДЕ
		|	УчетныеЗаписиЭДО.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция СтатусКонтроляОтраженияВУЧете(ЭлектронныйДокумент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭлектронныеДокументы.Ссылка КАК ЭлектронныйДокумент,
		|	ВЫБОР
		|		КОГДА КонтрольОтраженияВУчетеЭДО.СопоставитьНоменклатуру
		|			ТОГДА ""СопоставитьНоменклатуру""
		|		КОГДА КонтрольОтраженияВУчетеЭДО.СоздатьУчетныйДокумент
		|			ТОГДА ""СоздатьУчетныйДокумент""
		|		КОГДА КонтрольОтраженияВУчетеЭДО.ПровестиУчетныйДокумент
		|			ТОГДА ""ПровестиУчетныйДокумент""
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Статус
		|ИЗ
		|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрольОтраженияВУчетеЭДО КАК КонтрольОтраженияВУчетеЭДО
		|		ПО ЭлектронныеДокументы.Ссылка = КонтрольОтраженияВУчетеЭДО.ЭлектронныйДокумент
		|ГДЕ
		|	НЕ ЭлектронныеДокументы.ПометкаУдаления
		|	И ЭлектронныеДокументы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭлектронныйДокумент);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Статус;
	КонецЦикла;

	Возврат "";
	
КонецФункции

Функция КодОператораУчетнойЗаписиОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|ГДЕ
	|	УчетныеЗаписиЭДО.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапроса.Следующий() Тогда
		Возврат ВыборкаЗапроса.ОператорЭДО;
	КонецЕсли;

	Возврат "";

КонецФункции

Функция СуществуютСертификатыСИстекающимСрокомДействияДляОрганизации(Организация) Экспорт
	
	Возврат СуществуетДействующийНаДатуСертификат(ДобавитьМесяц(ТекущаяДатаСеанса(), 1), Организация);
	
КонецФункции

Функция СуществуютСертификатыСИстекшимСрокомДействияДляОрганизации(Организация) Экспорт
	
	Возврат СуществуетДействующийНаДатуСертификат(ТекущаяДатаСеанса(), Организация);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СуществуетДействующийНаДатуСертификат(Дата, Организация = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|ГДЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо < &ДействителенДо";
	
	Запрос.Параметры.Вставить("ДействителенДо", Дата);
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		Запрос.Текст = Запрос.Текст + " И СертификатыКлючейЭлектроннойПодписиИШифрования.Организация = &Организация";
		Запрос.Параметры.Вставить("Организация", Организация);
	КонецЕсли;
	
	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции

Функция ПараметрыДоступныхЗначенийКатегорииЛогическогоТипа()
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Булево"));
	
	Значения = Новый СписокЗначений;
	Значения.Добавить(Истина);
	Значения.Добавить(Ложь);
	
	ПараметрыДоступныхЗначений.Вставить("Значения", Значения);
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

Функция ФункцияРасчетаВнеконтекстнойКатегории(Категория)
	
	СписокВнеконтекстныхКатегорий = КонтекстныеПодсказкиБЭДПовтИсп.СписокВнеконтекстныхКатегорий();
	
	Возврат СписокВнеконтекстныхКатегорий.Получить(Категория);
	
КонецФункции

#Область ВычислениеЗначенийВнеконтекстныхКатегорий

Функция СуществуетКонтрагентОператора(КодОператора) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	АбонентыЭДО.ОператорЭДО КАК ОператорЭДО
	|ИЗ
	|	РегистрСведений.АбонентыЭДО КАК АбонентыЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИмяТаблицыКонтрагенты КАК Контрагенты
	|		ПО АбонентыЭДО.ИНН = Контрагенты.ИмяРеквизитаИНН
	|			И АбонентыЭДО.КПП = Контрагенты.ИмяРеквизитаКПП
	|			И (АбонентыЭДО.ОператорЭДО = &ОператорЭДО)";
	
	Запрос.УстановитьПараметр("ОператорЭДО", КодОператора);
	
	ИмяТаблицыКонтрагенты = "Справочник." + ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Контрагенты");
	ИмяРеквизитаИНН = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
	ИмяРеквизитаКПП = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицыКонтрагенты", ИмяТаблицыКонтрагенты);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяРеквизитаИНН", ИмяРеквизитаИНН);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяРеквизитаКПП", ИмяРеквизитаКПП); 
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция СуществуетЭДСоСтатусомОтраженияВУчете(Статус) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЭлектронныеДокументы.Ссылка КАК ЭлектронныйДокумент
		|ИЗ
		|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрольОтраженияВУчетеЭДО КАК КонтрольОтраженияВУчетеЭДО
		|		ПО ЭлектронныеДокументы.Ссылка = КонтрольОтраженияВУчетеЭДО.ЭлектронныйДокумент
		|ГДЕ
		|	НЕ ЭлектронныеДокументы.ПометкаУдаления
		|	И ВЫБОР
		|			КОГДА КонтрольОтраженияВУчетеЭДО.СопоставитьНоменклатуру
		|				ТОГДА ""СопоставитьНоменклатуру""
		|			КОГДА КонтрольОтраженияВУчетеЭДО.СоздатьУчетныйДокумент
		|				ТОГДА ""СоздатьУчетныйДокумент""
		|			КОГДА КонтрольОтраженияВУчетеЭДО.ПровестиУчетныйДокумент
		|				ТОГДА ""ПровестиУчетныйДокумент""
		|			ИНАЧЕ """"
		|		КОНЕЦ = &Статус";
	
	Запрос.УстановитьПараметр("Статус", Статус);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция СуществуетНеобработанныйДокументВДеревеДействийДляРаздела(Раздел) Экспорт
	
	Если ДоступныеДействияДереваДействий().Значения.НайтиПоЗначению(Раздел) = Неопределено Тогда 
		Возврат Ложь;	
	КонецЕсли;	
		
	ПараметрыТекущихЭД = ОбменСКонтрагентамиСлужебный.НовыеПараметрыОпределенияТекущихЭлектронныхДокументов();
	ПараметрыТекущихЭД.Раздел = Раздел;
	ПараметрыТекущихЭД.КоличествоПолучаемыхЗаписей = 1;
		
	Запрос = ОбменСКонтрагентамиСлужебный.ЗапросКоличестваТекущихЭлектронныхДокументов(ПараметрыТекущихЭД);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка._Счетчик <> 0;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ОтсутствуетНеобработанныйДокументВДеревеДействийДляРаздела(Раздел) Экспорт
	
	Возврат Не СуществуетНеобработанныйДокументВДеревеДействийДляРаздела(Раздел);
	
КонецФункции

Функция СоздаватьЭлектронныеПодписиНаСервере(Условие) Экспорт
	
	Возврат ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() = Условие;

КонецФункции

Функция ПроверятьЭлектронныеПодписиНаСервере(Условие) Экспорт
	
	Возврат ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере() = Условие;
	
КонецФункции

Функция СертификатыЕстьВСписке(Условие) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
	|ГДЕ
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.Отпечаток <> """"";
	
	Результат = Не Запрос.Выполнить().Пустой();
	
	Возврат Результат = Условие;

КонецФункции

Функция СертификатыЕстьВЛичномСписке(Условие) Экспорт

	Возврат ОбменСКонтрагентамиСлужебный.ТаблицаДоступныхДляПодписиСертификатов().Количество() > 0;
	
КонецФункции

Функция СуществуютУчетныеЗаписи(Условие) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
	
	ЗаписьСуществует = Не Запрос.Выполнить().Пустой();
	
	Возврат ЗаписьСуществует = Условие;

КонецФункции

Функция СуществуютУчетныеЗаписиОператора(КодОператора) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|ГДЕ
	|	УчетныеЗаписиЭДО.ОператорЭДО = &ОператорЭДО";
	
	Запрос.Параметры.Вставить("ОператорЭДО", КодОператора);
	
	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции

Функция СуществуютЭлементыВСправочнике(ИмяСправочника) Экспорт

	ОбъектМетаданных = Метаданные.Справочники.Найти(ИмяСправочника);
	
	Если ОбъектМетаданных = Неопределено Или Не ПравоДоступа("Чтение", ОбъектМетаданных) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	Данные.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.%1 КАК Данные";
	
	Запрос.Текст = СтрШаблон(Запрос.Текст, ИмяСправочника);

	Результат = Не Запрос.Выполнить().Пустой();	
	
	Возврат Результат;
	
КонецФункции

Функция ОтсутствуютЭлементыВСправочнике(ИмяСправочника) Экспорт
	
	Возврат Не СуществуютЭлементыВСправочнике(ИмяСправочника);
	
КонецФункции

Функция СуществуютСертификатыСИстекающимСрокомДействия(Условие) Экспорт
	
	Возврат СуществуетДействующийНаДатуСертификат(ДобавитьМесяц(ТекущаяДатаСеанса(), 1)); 
	
КонецФункции

Функция СуществуютСертификатыСИстекшимСрокомДействия(Условие) Экспорт
	
	Возврат СуществуетДействующийНаДатуСертификат(ТекущаяДатаСеанса()); 
	
КонецФункции

#КонецОбласти

#Область ВычислениеПараметровДоступныхЗначенийКатегорий

// Вид электронного документа
Функция ПараметрыДоступныхЗначенийКатегории_LED_EDKind() Экспорт
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Для Каждого ВидЭД Из Перечисления.ВидыЭД Цикл
		Имя = ОбщегоНазначения.ИмяЗначенияПеречисления(ВидЭД);
		Синоним = Строка(ВидЭД);
		СписокДоступныхЗначений.Добавить(Имя, Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", СписокДоступныхЗначений); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Статус документооборота
Функция ПараметрыДоступныхЗначенийКатегории_LED_DocExchSts() Экспорт
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Для Каждого СостояниеВерсийЭД Из Перечисления.СостоянияВерсийЭД Цикл
		Имя = ОбщегоНазначения.ИмяЗначенияПеречисления(СостояниеВерсийЭД);
		Синоним = Строка(СостояниеВерсийЭД);
		СписокДоступныхЗначений.Добавить(Имя, Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", СписокДоступныхЗначений); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Статус документооборота
Функция ПараметрыДоступныхЗначенийКатегории_LED_DocSts() Экспорт
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Для Каждого СтатусЭД Из Перечисления.СтатусыЭД Цикл
		Имя = ОбщегоНазначения.ИмяЗначенияПеречисления(СтатусЭД);
		Синоним = Строка(СтатусЭД);
		СписокДоступныхЗначений.Добавить(Имя, Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", СписокДоступныхЗначений); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Тип электронного документа
Функция ПараметрыДоступныхЗначенийКатегории_LED_EDType() Экспорт
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Для Каждого ТипЭД Из Перечисления.ТипыЭД Цикл
		Имя = ОбщегоНазначения.ИмяЗначенияПеречисления(ТипЭД);
		Синоним = Строка(ТипЭД);
		СписокДоступныхЗначений.Добавить(Имя, Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", СписокДоступныхЗначений); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Направление электронного документа
Функция ПараметрыДоступныхЗначенийКатегории_LED_DocDirection() Экспорт
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Для Каждого НаправлениеЭД Из Перечисления.НаправленияЭД Цикл
		Имя = ОбщегоНазначения.ИмяЗначенияПеречисления(НаправлениеЭД);
		Синоним = Строка(НаправлениеЭД);
		СписокДоступныхЗначений.Добавить(Имя, Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", СписокДоступныхЗначений); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Код оператора учетной записи организации
Функция ПараметрыДоступныхЗначенийКатегории_LED_OrgLoginOfOper() Экспорт
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Неопределено); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Код оператора контрагента
Функция ПараметрыДоступныхЗначенийКатегории_LED_CustomerOperCode() Экспорт
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Неопределено); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Существует контрагент оператора X
Функция ПараметрыДоступныхЗначенийКатегории_LED_ExistCustOfOper() Экспорт
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Неопределено); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Существует учетные записи оператора X
Функция ПараметрыДоступныхЗначенийКатегории_LED_AccOfOperIsExist() Экспорт
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Неопределено); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Существует ЭД со статусом отражения в учете X
Функция ПараметрыДоступныхЗначенийКатегории_LED_DocStsOfAccEx() Экспорт
	
	Возврат ПараметрыДоступныхЗначенийКатегории_LED_DocAccSts();
	
КонецФункции

// Существует не обработанные ЭД для действия X в дереве действий
Функция ПараметрыДоступныхЗначенийКатегории_LED_NotPrcDocInActTr() Экспорт
	
	Возврат ДоступныеДействияДереваДействий();
	
КонецФункции

// Отсутствуют не обработанные ЭД для действия X в дереве действий
Функция ПараметрыДоступныхЗначенийКатегории_LED_EmpPrcDocInActTr() Экспорт
	
	Возврат ДоступныеДействияДереваДействий();
	
КонецФункции

// Статусы отражения в учете документов
Функция ПараметрыДоступныхЗначенийКатегории_LED_DocAccSts() Экспорт
	
	Значения = Новый СписокЗначений;
	Значения.Добавить("СопоставитьНоменклатуру", НСтр("ru='Сопоставить номенклатуру'"));
	Значения.Добавить("СоздатьУчетныйДокумент",  НСтр("ru='Создать учетный документ'"));
	Значения.Добавить("ПровестиУчетныйДокумент", НСтр("ru='Провести учетный документ'"));
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Значения); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

// Существуют элементы в справочнике Х
Функция ПараметрыДоступныхЗначенийКатегории_LED_ElemExistInCat() Экспорт
	
	Возврат ПараметрыДоступныхЗначенийДанныеСправочников();
	
КонецФункции

// Отсутствуют элементы в справочнике Х
Функция ПараметрыДоступныхЗначенийКатегории_LED_ElemNotExInCat() Экспорт
	
	Возврат ПараметрыДоступныхЗначенийДанныеСправочников();
	
КонецФункции

Функция ПараметрыДоступныхЗначенийДанныеСправочников()
	
	Значения = Новый СписокЗначений;
	
	Для Каждого Спр Из Метаданные.Справочники Цикл
		Значения.Добавить(Спр.Имя, Спр.Синоним);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Значения); 
	
	Возврат ПараметрыДоступныхЗначений;
	
КонецФункции

Функция ДоступныеДействияДереваДействий()
	
	ОписаниеРазделов = Новый ТаблицаЗначений;
	ОписаниеРазделов.Колонки.Добавить("Имя");
	ОписаниеРазделов.Колонки.Добавить("Представление");
	ОписаниеРазделов.Колонки.Добавить("Видимость");
	ОписаниеРазделов.Колонки.Добавить("РассчитыватьКоличество");
	ОписаниеРазделов.Колонки.Добавить("КоличествоРассчитано");

	Обработки.ОбменСКонтрагентами.ИнициализироватьРазделы(ОписаниеРазделов);
	
	Значения = Новый СписокЗначений;
	
	Для Каждого Раздел Из ОписаниеРазделов Цикл
		Значения.Добавить(Раздел.Имя, Раздел.Представление);
	КонецЦикла;
	
	ПараметрыДоступныхЗначений = Новый Структура;
	ПараметрыДоступныхЗначений.Вставить("Типы", Новый ОписаниеТипов("Строка"));
	ПараметрыДоступныхЗначений.Вставить("Значения", Значения); 
	
	Возврат ПараметрыДоступныхЗначений;

КонецФункции

#КонецОбласти

#КонецОбласти
