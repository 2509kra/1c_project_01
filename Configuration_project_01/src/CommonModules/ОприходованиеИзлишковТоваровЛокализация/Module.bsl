
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	УчетПрослеживаемыхТоваровЛокализация.ПроверитьЗаполнениеКоличестваПоРНПТ(Объект, Отказ, Неопределено);
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.<Имя документа> - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-1 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ1";
		КомандаПечати.Представление = НСтр("ru='Акт о приеме-передаче ТМЦ на хранение (МХ-1)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры


// Функция получает данные для формирования печатной формы МХ - 1
//
Функция ПолучитьДанныеДляПечатнойФормыМХ1(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет КАК ПредварительныйРасчет,
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Дата КАК ДатаДокумента,
	|	Документ.Организация КАК Организация,
	|	Документ.Склад КАК Склад,
	|	Склады.ИсточникИнформацииОЦенахДляПечати КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваров КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО (РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(Документ.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(Документ.Дата, МЕСЯЦ))
	|			И (РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен)
	|			И (Документ.Организация = РасчетСебестоимостиТоваровОрганизации.Организация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО (Документ.Склад = Склады.Ссылка)
	|ГДЕ
	|	Документ.Ссылка В(&МассивДокументов)
	|	И Документ.Проведен
	|	И Склады.СкладОтветственногоХранения
	|	И Документ.Организация <> Склады.Поклажедержатель
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Шапка.Склад КАК Склад,
	|	Товары.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Представление КАК ВидУпаковки,
	|	Товары.Количество КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Шапка.ВидЦены КАК ВидЦены,
	|	Шапка.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваров.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	|		ИЛИ (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|			И Шапка.ПредварительныйРасчет ЕСТЬ NULL))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление ВидУпаковки,
	|	ВидыЗапасов.Количество КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения.УчетныйВидЦены КАК ВидЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваров.Товары КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|;
	|";
	
	СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке = МассивРезультатов[6];
	РезультатПоСкладам = МассивРезультатов[7];
	РезультатПоТабличнойЧасти = МассивРезультатов[8];
	
	СтруктураДанныхДляПечати = Новый Структура(
		"РезультатПоШапке, РезультатПоСкладам, РезультатПоТабличнойЧасти",
		РезультатПоШапке,
		РезультатПоСкладам,
		РезультатПоТабличнойЧасти);
		
	Возврат СтруктураДанныхДляПечати
	
КонецФункции

#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

//++ Локализация
//-- Локализация

#КонецОбласти

#КонецОбласти
