#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК Т2 
	|	ПО Т2.Родитель = Т.Партнер
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Партнер)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Партнер)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК ИерархияПартнеров 
	|	ПО ИерархияПартнеров.Родитель = ЭтотСписок.Партнер
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиПартнеры
	|	ПО ВнешниеПользователиПартнеры.ОбъектАвторизации = ИерархияПартнеров.Партнер
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров 
	|	ПО КонтактныеЛицаПартнеров.Владелец = ЭтотСписок.Партнер
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиКонтактныеЛица 
	|	ПО ВнешниеПользователиКонтактныеЛица.ОбъектАвторизации = КонтактныеЛицаПартнеров.Ссылка
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВнешниеПользователиПартнеры.Ссылка)
	|	ИЛИ ЗначениеРазрешено(ВнешниеПользователиКонтактныеЛица.Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Функция получает значения реквизитов выбранного контрагента.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - Ссылка на контрагента.
//
// Возвращаемое значение:
//  Структура - реквизиты выбранного контрагента.
//
Функция РеквизитыКонтрагента(Контрагент, ДатаСведений = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Если ДатаСведений <> Неопределено Тогда
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ИсторияКППКонтрагентов.КПП КАК КПП
		|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
		|ИЗ
		|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
		|ГДЕ
		|	ИсторияКППКонтрагентов.Ссылка = &Контрагент
		|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИсторияКППКонтрагентов.Период УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ИсторияНаименованийКонтрагентов.НаименованиеПолное КАК НаименованиеПолное
		|ПОМЕСТИТЬ ИсторическоеЗначениеНаименования
		|ИЗ
		|	Справочник.Контрагенты.ИсторияНаименований КАК ИсторияНаименованийКонтрагентов
		|ГДЕ
		|	ИсторияНаименованийКонтрагентов.Ссылка = &Контрагент
		|	И ИсторияНаименованийКонтрагентов.Период <= &ДатаСведений
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИсторияНаименованийКонтрагентов.Период УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ИсторическоеЗначениеНаименования.НаименованиеПолное, Контрагенты.НаименованиеПолное) КАК НаименованиеПолное,
		|	Контрагенты.ИНН                                                                               КАК ИНН,
		|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП)                                        КАК КПП,
		|	Контрагенты.КодПоОКПО                                                                         КАК КодПоОКПО,
		|	Контрагенты.ЮрФизЛицо                                                                         КАК ЮрФизЛицо,
		|	Контрагенты.НалоговыйНомер                                                                    КАК НалоговыйНомер,
		|	Контрагенты.СтранаРегистрации                                                                 КАК СтранаРегистрации,
		|	ЕСТЬNULL(СтраныМира.КодАльфа2, """")                                                          КАК КодАльфа2СтраныРегистрации,
		|	Контрагенты.ОбособленноеПодразделение                                                         КАК ОбособленноеПодразделение,
		|	Контрагенты.ГоловнойКонтрагент                                                                КАК ГоловнойКонтрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
		|		ПО Контрагенты.СтранаРегистрации = СтраныМира.Ссылка
		|	ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
		|		ПО (ИСТИНА)
		|	ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеНаименования КАК ИсторическоеЗначениеНаименования
		|		ПО (ИСТИНА)
		|ГДЕ
		|	Контрагенты.Ссылка = &Контрагент
		|";
		
		Запрос.УстановитьПараметр("ДатаСведений", ДатаСведений);
		
	Иначе
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.НаименованиеПолное        КАК НаименованиеПолное,
		|	Контрагенты.ИНН                       КАК ИНН,
		|	Контрагенты.КПП                       КАК КПП,
		|	Контрагенты.КодПоОКПО                 КАК КодПоОКПО,
		|	Контрагенты.ЮрФизЛицо                 КАК ЮрФизЛицо,
		|	Контрагенты.НалоговыйНомер            КАК НалоговыйНомер,
		|	Контрагенты.СтранаРегистрации         КАК СтранаРегистрации,
		|	ЕСТЬNULL(СтраныМира.КодАльфа2, """")  КАК КодАльфа2СтраныРегистрации,
		|	Контрагенты.ОбособленноеПодразделение КАК ОбособленноеПодразделение,
		|	Контрагенты.ГоловнойКонтрагент        КАК ГоловнойКонтрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
		|		ПО Контрагенты.СтранаРегистрации = СтраныМира.Ссылка
		|ГДЕ
		|	Контрагенты.Ссылка = &Контрагент";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Представление              = Выборка.НаименованиеПолное;
		Наименование               = Выборка.НаименованиеПолное;
		ИНН                        = Выборка.ИНН;
		КПП                        = Выборка.КПП;
		НалоговыйНомер             = Выборка.НалоговыйНомер;
		КодПоОКПО                  = Выборка.КодПоОКПО;
		ЮрФизЛицо                  = Выборка.ЮрФизЛицо;
		НалоговыйНомер             = Выборка.НалоговыйНомер;
		СтранаРегистрации          = Выборка.СтранаРегистрации;
		КодАльфа2СтраныРегистрации = Выборка.КодАльфа2СтраныРегистрации;
		ОбособленноеПодразделение  = Выборка.ОбособленноеПодразделение;
		ГоловнойКонтрагент         = Выборка.ГоловнойКонтрагент;
	Иначе
		Представление              = "";
		Наименование               = "";
		ИНН                        = "";
		КПП                        = "";
		НалоговыйНомер             = "";
		КодПоОКПО                  = "";
		ЮрФизЛицо                  = Перечисления.ЮрФизЛицо.ПустаяСсылка();
		НалоговыйНомер             = Выборка.НалоговыйНомер;
		СтранаРегистрации          = Справочники.СтраныМира.ПустаяСсылка();
		КодАльфа2СтраныРегистрации = "";
		ОбособленноеПодразделение  = Ложь;
		ГоловнойКонтрагент         = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Представление",              Представление);
	СтруктураРеквизитов.Вставить("Наименование",               Наименование);
	СтруктураРеквизитов.Вставить("ИНН",                        ИНН);
	СтруктураРеквизитов.Вставить("КПП",                        КПП);
	СтруктураРеквизитов.Вставить("КодПоОКПО",                  КодПоОКПО);
	СтруктураРеквизитов.Вставить("ЮрФизЛицо",                  ЮрФизЛицо);
	СтруктураРеквизитов.Вставить("НалоговыйНомер",             НалоговыйНомер);
	СтруктураРеквизитов.Вставить("СтранаРегистрации",          СтранаРегистрации);
	СтруктураРеквизитов.Вставить("КодАльфа2СтраныРегистрации", КодАльфа2СтраныРегистрации);
	СтруктураРеквизитов.Вставить("ОбособленноеПодразделение",  ОбособленноеПодразделение);
	СтруктураРеквизитов.Вставить("ГоловнойКонтрагент",         ГоловнойКонтрагент);
	
	Возврат СтруктураРеквизитов;

КонецФункции

Функция КППНаДату(Контрагент, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСведений) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "КПП");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Контрагент", Контрагент);
	Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
	Запрос.Текст ="
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИсторияКППКонтрагентов.КПП КАК КПП
	|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
	|ИЗ
	|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|ГДЕ
	|	ИсторияКППКонтрагентов.Ссылка = &Контрагент
	|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИсторияКППКонтрагентов.Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП) КАК КПП
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Контрагенты.Ссылка = &Контрагент";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КПП;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция СокрЮрНаименованиеНаДату(Контрагент, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСведений) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "НаименованиеПолное");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Контрагент", Контрагент);
	Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
	Запрос.Текст ="
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИсторияНаименованийКонтрагентов.НаименованиеПолное КАК НаименованиеПолное
	|ПОМЕСТИТЬ ИсторическоеЗначениеНаименования
	|ИЗ
	|	Справочник.Контрагенты.ИсторияНаименований КАК ИсторияНаименованийКонтрагентов
	|ГДЕ
	|	ИсторияНаименованийКонтрагентов.Ссылка = &Контрагент
	|	И ИсторияНаименованийКонтрагентов.Период <= &ДатаСведений
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИсторияНаименованийКонтрагентов.Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ИсторическоеЗначениеНаименования.НаименованиеПолное, Контрагенты.НаименованиеПолное) КАК НаименованиеПолное
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеНаименования КАК ИсторическоеЗначениеНаименования
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Контрагенты.Ссылка = &Контрагент";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НаименованиеПолное;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ЮридическоеФизическоеЛицо");
	НеРедактируемыеРеквизиты.Добавить("ОбособленноеПодразделение");
	НеРедактируемыеРеквизиты.Добавить("ГоловнойКонтрагент");
	НеРедактируемыеРеквизиты.Добавить("КПП");
	НеРедактируемыеРеквизиты.Добавить("НаименованиеПолное");
	НеРедактируемыеРеквизиты.Добавить("ИсторияКПП.*");
	НеРедактируемыеРеквизиты.Добавить("ИсторияНаименований.*");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПартнерыИКонтрагентыВызовСервера.КонтрагентыДанныеВыбора(Параметры);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			ИспользоватьПолнотекстовыйПоиск = ОбщегоНазначенияУТВызовСервера.ИспользуетсяПолнотекстовыйПоиск("ИспользоватьПолнотекстовыйПоиск");
			
			Если ИспользоватьПолнотекстовыйПоиск Тогда
				ВыбраннаяФорма       = "ФормаВыбораИспользуютсяТолькоПартнеры";
			Иначе
				ВыбраннаяФорма       = "ФормаВыбораИспользуютсяТолькоПартнерыБезПолнотекстовогоПоиска";
			КонецЕсли;
			
			СтандартнаяОбработка = Ложь;
			
			Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Партнер") Тогда
				Параметры.Отбор.Удалить("Партнер");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	//Сидоров+
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ.НомерЛС) Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаЭлементаЛС";
		КонецЕсли;
	КонецЕсли;
	//Сидоров-
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИБ

// Заполняет предопределенные элементы справочника "Контрагенты".
//
Процедура ЗаполнитьПредопределенныхКонтрагентов() Экспорт
	
	СправочникОбъект = Справочники.Контрагенты.РозничныйПокупатель.ПолучитьОбъект();
	СправочникОбъект.НаименованиеПолное = НСтр("ru = 'Розничный покупатель'");
	СправочникОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
	СправочникОбъект.Партнер = Справочники.Партнеры.РозничныйПокупатель;
	СправочникОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = Отчеты.РасчетыСПартнерами.ДобавитьКомандуОтчета(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "ФормаЭлемента,ФормаСписка,ФормаСпискаПараметрическая";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДосьеКонтрагента(КомандыОтчетов);
	
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "ФормаЭлемента,ФормаСписка,ФормаСпискаПараметрическая";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт



КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - СправочникСсылка - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * ВариантОтправки - Строка - Варианты отправки письма: "Кому", "Копия", "СкрытаяКопия", "ОбратныйАдреса";
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
