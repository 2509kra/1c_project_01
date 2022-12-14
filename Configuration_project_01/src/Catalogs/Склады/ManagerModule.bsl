#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриОтгрузке");
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриПоступлении");
	Результат.Добавить("ИспользоватьСкладскиеПомещения");
	Результат.Добавить("НастройкаАдресногоХранения");
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач");
	Результат.Добавить("ТипСклада");
	Результат.Добавить("Родитель");
	Результат.Добавить("ВыборГруппы");
	Результат.Добавить("РозничныйВидЦены");
	Результат.Добавить("ИспользоватьСтатусыРасходныхОрдеров");
	Результат.Добавить("ИспользоватьСтатусыПриходныхОрдеров");
	Результат.Добавить("ДатаНачалаОрдернойСхемыПриОтгрузке");
	Результат.Добавить("ДатаНачалаОрдернойСхемыПриПоступлении");
	Результат.Добавить("ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач");
	Результат.Добавить("ДатаНачалаИспользованияСкладскихПомещений");
	Результат.Добавить("ДатаНачалаАдресногоХраненияОстатков");
	Результат.Добавить("Подразделение");
	                                                         
	Возврат Результат;

КонецФункции

// Возвращает розничный склад, если найден один розничный склад, иначе - пустую ссылку.
//
//	Возвращаемое значение:
//		СправочникСсылка.Склады - розничный склад.
//
Функция РозничныйСкладПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	(НЕ Склады.ПометкаУдаления)
	|	И Склады.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		Склад = Выборка.Склад;
	Иначе
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Склад;

КонецФункции 

// Возвращает розничный склад, если найден один розничный склад, иначе - пустую ссылку.
//
//	Параметры:
//		УчитыватьГруппыСкладов - Булево - если ИСТИНА, но может быть возвращена группа складов, которую разрешено выбирать в документах,
//						иначе - возвращается только конкретный склад, если он один в справочнике
//		ИсключитьГруппыДоступныеВЗаказах - Булево - если УчитыватьГруппыСкладов = ИСТИНА, то этот параметр позволяет исключить из анализа
//						группы складов, которые можно выбирать только в заказах
//	Возвращаемое значение:
//		СправочникСсылка.Склады - розничный склад.
//
Функция СкладПоУмолчанию(УчитыватьГруппыСкладов = Ложь, ИсключитьГруппыДоступныеВЗаказах = Ложь) Экспорт
	
	Если УчитыватьГруппыСкладов Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	Таблица.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Таблица
		|ГДЕ
		|	НЕ Таблица.ПометкаУдаления
		|	И Таблица.ВыборГруппы В (&ВыборГруппыСкладов)
		|");
		
		Запрос.УстановитьПараметр("ВыборГруппыСкладов", ВариантыВыбораГруппыСкладов(ИсключитьГруппыДоступныеВЗаказах));
		
	Иначе
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	Таблица.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Таблица
		|ГДЕ
		|	(НЕ Таблица.ПометкаУдаления)
		|	И (НЕ Таблица.ЭтоГруппа)
		|");
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Склад = Выборка.Склад;
	Иначе
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Склад;
	
КонецФункции

// Проверяет, что на складе отключен контроль свободных остатков
//
// Параметры:
//  Склад	 - 	СправочникСсылка.Склады - ссылка на склад.
// 
// Возвращаемое значение:
//  Булево - признак отключенности контроля остатков на складе.
//
Функция КонтрольОстатковНаСкладеОтключен(Склад) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Результат
	|ИЗ
	|	РегистрСведений.НастройкаКонтроляОбеспечения КАК Настройка
	|ГДЕ
	|	Настройка.Склад = &Склад
	|	И Настройка.Контролировать");
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

// Функция возвращает учетный вид цен склада
//
// Параметры:
//  Склад	 - СправочникСсылка.Склады	 - склад, для которого определяется учетный вид цены.
// 
// Возвращаемое значение:
//  СправочникСсылка.ВидыЦен - ссылка на учетный вид цены склада.
//
Функция УчетныйВидЦены(Склад) Экспорт
	Перем ВидЦены;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") И ЗначениеЗаполнено(Склад) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Склады.УчетныйВидЦены
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка = &Склад";
		Запрос.УстановитьПараметр("Склад", Склад);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ВидЦены = Выборка.УчетныйВидЦены;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены);
	
КонецФункции

// Функция возвращает источник информации о ценах для печати склада
//
// Параметры:
//  Склад	 - СправочникСсылка.Склады	 - склад, для которого определяется учетный вид цены.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ИсточникиИнформацииОЦенахДляПечати - значение перечисления для склада по умолчанию.
//
Функция ИсточникИнформацииОЦенахДляПечати(Склад) Экспорт
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Возврат Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.ИсточникИнформацииОЦенахДляПечати
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Ссылка = &Склад";
	Запрос.УстановитьПараметр("Склад",Склад);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИсточникИнформацииОЦенахДляПечати;
	Иначе
		Возврат Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПустаяСсылка();
	КонецЕсли;
КонецФункции

// Проверяет в привилегированном режиме, является ли элемент справочника группой складов.
//	
//	Параметры:
//		Склад - СправочникСсылка.Склады - элемента справочника, для которого производится проверка
//	Возвращаемое значение:
// 		Булево 
//
Функция ЭтоГруппа(Склад) Экспорт
	
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ЭтоГруппа");
	
КонецФункции 

// Проверяет в привилегированном режиме, является ли элемент справочника группой складов, и при этом
//  склады могут указываться в табличных частях документов продажи.
//
// Параметры:
//  Склад	 - СправочникСсылка.Склады	 - элемента справочника, для которого производится проверка.
// 
// Возвращаемое значение:
//  Булево - склад является группой складов.
//
Функция ЭтоГруппаИСкладыИспользуютсяВТЧДокументовПродажи(Склад) Экспорт
	
	Если ЗначениеЗаполнено(Склад) 
		И ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи") Тогда
		Возврат Справочники.Склады.ЭтоГруппа(Склад);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции 

// Проверяет в привилегированном режиме, является ли элемент справочника группой складов, и при этом
//  склады могут указываться в табличных частях документов закупки.
//
// Параметры:
//  Склад	 - СправочникСсылка.Склады	 - Склад, признак которого нужно получить.
// 
// Возвращаемое значение:
//  Булево - склад является группой складов. Склады этой группы могут указывать в табличной части
//  документа закупки.
//
Функция ЭтоГруппаИСкладыИспользуютсяВТЧДокументовЗакупки(Склад) Экспорт
	
	Если ЗначениеЗаполнено(Склад) 
		И ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") Тогда
		Возврат Справочники.Склады.ЭтоГруппа(Склад);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции 

// Возвращает массив возможных (согласно настройкам ФО) вариантов выбора группы складов.
//
// Параметры:
// 		ИсключитьГруппыДоступныеВЗаказах - Булево - указывает на необходимость в массив не включать значение РазрешитьВЗаказах.
//
// Возвращаемое значение:
// 		Массив - содержит значения перечисления ВыборГруппыСкладов, по которым необходимо отобрать склады.
//
Функция ВариантыВыбораГруппыСкладов(ИсключитьГруппыДоступныеВЗаказах) Экспорт
	
	ВыборГруппыСкладов = Новый Массив();
	ВыборГруппыСкладов.Добавить(Перечисления.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных);
	Если Не ИсключитьГруппыДоступныеВЗаказах Тогда
		ВыборГруппыСкладов.Добавить(Перечисления.ВыборГруппыСкладов.РазрешитьВЗаказах);
	КонецЕсли;
	
	Возврат ВыборГруппыСкладов;
	
КонецФункции

// Возвращает массив ссылок на группы складов, в иерархию которых входит указанный склад.
//	
//	Параметры:
//		Склад - СправочникСсылка.Склады - склад, для которого нужно получить массив групп
//	Возвращаемое значение:
//		Массив - массив ссылок на группы, в иерархию которых входит склад.
//
Функция ИерархияГрупп(Склад) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	МассивГрупп = Новый Массив;
	
	Группа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "Родитель");
	
	Пока ЗначениеЗаполнено(Группа) Цикл
		МассивГрупп.Добавить(Группа);
		Группа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Группа, "Родитель");
	КонецЦикла;

	Возврат МассивГрупп; 
	
КонецФункции

// Возвращает текст запроса по документам, зависящим от использования ордерной схемы при поступлении.
//
// Возвращаемое значение:
//	Строка - текст запроса по документам, зависящим от использования ордерной схемы при поступлении.
//
Функция ТекстЗапросаПоДокументамЗависящимОтОрдернойСхемыПриПоступлении() Экспорт
	Описания = Новый Массив;
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ВозвратТоваровОтКлиента";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаказПоставщику";
	Описание.ИмяПоляДата = "ТЧ.ДатаПоступления";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаявкаНаВозвратТоваровОтКлиента";
	Описание.ИмяПоляДата = "ТЧ.ДатаПоступления";
	Описание.ИмяТЧ = "ВозвращаемыеТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "КорректировкаПриобретения";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описание.ИмяТЧ = "Расхождения";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПеремещениеТоваров";
	Описание.ИмяПоляСклад = "Шапка.СкладПолучатель";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПриобретениеТоваровУслуг";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описания.Добавить(Описание);
	
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПрочееОприходованиеТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "СборкаТоваров";
	Описания.Добавить(Описание);
	
	Возврат ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания);
КонецФункции

// Возвращает текст запроса по документам, зависящим от использования ордерной схемы при отгрузке.
//
// Возвращаемое значение:
//	Строка - текст запроса по документам, зависящим от использования ордерной схемы при отгрузке.
//
Функция ТекстЗапросаПоДокументамЗависящимОтОрдернойСхемыПриОтгрузке() Экспорт
	Описания = Новый Массив;
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ВнутреннееПотреблениеТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ВозвратТоваровПоставщику";
	Описания.Добавить(Описание);
	
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПеремещениеТоваров";
	Описание.ИмяПоляСклад = "Шапка.СкладОтправитель";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаказНаПеремещение";
	Описание.ИмяПоляСклад = "Шапка.СкладОтправитель";
	Описание.ИмяПоляДата = "ТЧ.НачалоОтгрузки";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "РеализацияТоваровУслуг";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "СборкаТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаявкаНаВозвратТоваровОтКлиента";
	Описание.ИмяПоляДата = "ТЧ.ДатаОтгрузки";
	Описание.ИмяТЧ = "ЗаменяющиеТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаказНаСборку";
	Описание.ИмяПоляДата = "Шапка.НачалоСборкиРазборки";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаказНаВнутреннееПотребление";
	Описание.ИмяПоляДата = "ТЧ.ДатаОтгрузки";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЗаказКлиента";
	Описание.ИмяПоляДата = "ТЧ.ДатаОтгрузки";
	Описания.Добавить(Описание);
	
	
	
	Возврат ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания);
КонецФункции

// Возвращает текст запроса по документам, зависящим от использования ордерной схемы при отражении излишков, недостач.
//
// Возвращаемое значение:
//	Строка - текст запроса по документам, зависящим от использования ордерной схемы при отражении излишков, недостач.
//
Функция ТекстЗапросаПоДокументамЗависящимОтОрдернойСхемыПриОтраженииИзлишковНедостач() Экспорт
	Описания = Новый Массив;
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "КорректировкаПриобретения";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описание.ИмяТЧ = "Расхождения";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "КорректировкаРеализации";
	Описание.ИмяПоляСклад = "ТЧ.Склад";
	Описание.ИмяТЧ = "Расхождения";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОприходованиеИзлишковТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПересортицаТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПересчетТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПорчаТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "СписаниеНедостачТоваров";
	Описания.Добавить(Описание);
	
	Возврат ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания);
КонецФункции

// Возвращает текст запроса по документам, зависящим от использования складских помещений.
// 
// Возвращаемое значение:
//  Строка - текст запроса по документам, зависящим от использования складских помещений.
//
Функция ТекстЗапросаПоДокументамЗависящимОтИспользованияСкладскихПомещений() Экспорт
	Описания = Новый Массив;
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеИзлишковТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеНедостачТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеПорчиТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "КорректировкаПоОрдеруНаТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОтчетОРозничныхПродажах";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПересчетТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПриходныйОрдерНаТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "РасходныйОрдерНаТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "УстановкаБлокировокЯчеек";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЧекККМ";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ЧекККМВозврат";
	Описания.Добавить(Описание);
	
	Возврат ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания);
КонецФункции

// Возвращает текст запроса по документам, зависящим от использования адресного хранения остатков.
//
// Параметры:
//	ОтбиратьПоПомещению - Булево, Истина - признак необходимости фильтровать документы по складскому помещению.
//
// Возвращаемое значение:
//	Строка - текст запроса по документам, зависящим от использования адресного хранения остатков.
//
Функция ТекстЗапросаПоДокументамЗависящимОтИспользованияАдресногоХранения(ОтбиратьПоПомещению = Ложь) Экспорт
	
	Описания = Новый Массив;
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеИзлишковТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеНедостачТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаОтражениеПорчиТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ОрдерНаПеремещениеТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "КорректировкаПоОрдеруНаТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПересчетТоваров";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "ПриходныйОрдерНаТовары";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеОбъекта();
	Описание.Имя = "РасходныйОрдерНаТовары";
	Описание.ИмяПоляДата = "Шапка.ДатаОтгрузки";
	Описания.Добавить(Описание);
	
	Возврат ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания,ОтбиратьПоПомещению);
	
КонецФункции

// Включение ведения статусов расходных ордеров для всех складов
//
Процедура ВключитьИспользованиеСтатусовРасходныхОрдеров() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Склады.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	НЕ Склады.ЭтоГруппа
	|	И Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
	|	И НЕ Склады.ИспользоватьСтатусыРасходныхОрдеров";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СкладОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СкладОбъект.ИспользоватьСтатусыРасходныхОрдеров = Истина;
		СкладОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#Область Команды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = Документы.ПоручениеЭкспедитору.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа ИЛИ
	|	ЗначениеРазрешено(Ссылка)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ДляДоступаКСвойствамСкладов

// Возвращает свойства складов
//
// Параметры:
//	Склады - Массив, СправочникСсылка.Склады - склады для которых определяются свойства
//
// Возвращаемое значение:
//	Соответствие - ключи являются ссылками на склады, значения структурой значений свойств
//
Функция СвойстваСкладов(Склады) Экспорт
	
	ДанныеСкладов = Новый Соответствие;
	
	Если ТипЗнч(Склады) = Тип("СправочникСсылка.Склады") Тогда
		МассивСкладов = Новый Массив;
		МассивСкладов.Добавить(Склады);
	Иначе
		МассивСкладов = Склады;		 
	КонецЕсли;	
	
	ПустойСклад = Справочники.Склады.ПустаяСсылка();
	Если МассивСкладов.Найти(ПустойСклад) <> Неопределено Тогда
	
		СтруктураСвойств = Новый Структура;
		СтруктураСвойств.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
		СтруктураСвойств.Вставить("ЦеховаяКладовая", Ложь);
		
		ДанныеСкладов.Вставить(ПустойСклад, СтруктураСвойств);
		
		Если МассивСкладов.Количество() = 1 Тогда
			Возврат ДанныеСкладов;
		КонецЕсли;	
			
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Склады.Ссылка КАК Ссылка,
	|	Склады.Подразделение КАК Подразделение,
	|	Склады.ЦеховаяКладовая КАК ЦеховаяКладовая
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Ссылка В (&МассивСкладов)";
	
	Запрос.УстановитьПараметр("МассивСкладов", МассивСкладов);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураСвойств = Новый Структура;
		СтруктураСвойств.Вставить("Подразделение");
		СтруктураСвойств.Вставить("ЦеховаяКладовая");
		
		ЗаполнитьЗначенияСвойств(СтруктураСвойств, Выборка);
		
		ДанныеСкладов.Вставить(Выборка.Ссылка, СтруктураСвойств);		
		
	КонецЦикла;
	
	Возврат ДанныеСкладов;
	
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СкладыВызовСервера.СкладыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		
		Параметры.Вставить("Ключ", СкладыВызовСервера.ПолучитьСкладПоУмолчанию());
		ВыбраннаяФорма = "ФормаЭлемента";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьПомещениеВСправочниках(Параметры,АдресХранилища) Экспорт
	
	Склад = Параметры.Склад;
	Помещение = Параметры.Помещение;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СкладскиеЯчейки.Ссылка
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Владелец = &Склад
	|	И СкладскиеЯчейки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Помещение = Помещение;
		СправочникОбъект.Записать();
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РабочиеУчастки.Ссылка
	|ИЗ
	|	Справочник.РабочиеУчастки КАК РабочиеУчастки
	|ГДЕ
	|	РабочиеУчастки.Владелец = &Склад
	|	И РабочиеУчастки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Помещение = Помещение;
		СправочникОбъект.Записать();
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбластиХранения.Ссылка
	|ИЗ
	|	Справочник.ОбластиХранения КАК ОбластиХранения
	|ГДЕ
	|	ОбластиХранения.Владелец = &Склад
	|	И ОбластиХранения.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Помещение = Помещение;
		СправочникОбъект.Записать();
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Помещение", Помещение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПравилаРазмещенияТоваровВЯчейках.СкладскаяГруппаНоменклатуры,
	|	ПравилаРазмещенияТоваровВЯчейках.СкладскаяГруппаУпаковок,
	|	ПравилаРазмещенияТоваровВЯчейках.Склад,
	|	&Помещение,
	|	ПравилаРазмещенияТоваровВЯчейках.ОбластьХранения,
	|	ПравилаРазмещенияТоваровВЯчейках.Приоритет
	|ИЗ
	|	РегистрСведений.ПравилаРазмещенияТоваровВЯчейках КАК ПравилаРазмещенияТоваровВЯчейках
	|ГДЕ
	|	ПравилаРазмещенияТоваровВЯчейках.Склад = &Склад
	|	И ПравилаРазмещенияТоваровВЯчейках.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ЗаписатьНаборСведенийПоПомещениюВРегистр(Результат, Параметры, "ПравилаРазмещенияТоваровВЯчейках");
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад,
	|	&Помещение,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.ОсновнаяЯчейка
	|ИЗ
	|	РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
	|ГДЕ
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад = &Склад
	|	И РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ЗаписатьНаборСведенийПоПомещениюВРегистр(Результат, Параметры, "РазмещениеНоменклатурыПоСкладскимЯчейкам");
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Помещение,
	|	НастройкиАдресныхСкладов.*
	|ИЗ
	|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|ГДЕ
	|	НастройкиАдресныхСкладов.Склад = &Склад
	|	И НастройкиАдресныхСкладов.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ЗаписатьНаборСведенийПоПомещениюВРегистр(Результат, Параметры, "НастройкиАдресныхСкладов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьНаборСведенийПоПомещениюВРегистр(РезультатЗапроса, Параметры, ИмяРегистра)
	
	НачатьТранзакцию();
	
	Попытка
		
		НаборРазмещение = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		НаборРазмещение.Отбор.Склад.Установить(Параметры.Склад);
		НаборРазмещение.Отбор.Помещение.Установить(Параметры.Помещение);
		НаборРазмещение.Загрузить(РезультатЗапроса.Выгрузить());
		НаборРазмещение.Записать();
		НаборРазмещение.Очистить();
		
		НаборРазмещение.Отбор.Склад.Установить(Параметры.Склад);
		НаборРазмещение.Отбор.Помещение.Установить(Справочники.СкладскиеПомещения.ПустаяСсылка());
		НаборРазмещение.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заполнение помещений в справочниках.'", КодОсновногоЯзыка),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

Функция ИменаОбъектовСПустымПомещением(Склад) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	""СкладскиеЯчейки"" КАК НазваниеОбъекта
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Владелец = &Склад
	|	И СкладскиеЯчейки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	""РабочиеУчастки""
	|ИЗ
	|	Справочник.РабочиеУчастки КАК РабочиеУчастки
	|ГДЕ
	|	РабочиеУчастки.Владелец = &Склад
	|	И РабочиеУчастки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	""ОбластиХранения""
	|ИЗ
	|	Справочник.ОбластиХранения КАК ОбластиХранения
	|ГДЕ
	|	ОбластиХранения.Владелец = &Склад
	|	И ОбластиХранения.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	""ПравилаРазмещенияТоваровВЯчейках""
	|ИЗ
	|	РегистрСведений.ПравилаРазмещенияТоваровВЯчейках КАК ПравилаРазмещенияТоваровВЯчейках
	|ГДЕ
	|	ПравилаРазмещенияТоваровВЯчейках.Склад = &Склад
	|	И ПравилаРазмещенияТоваровВЯчейках.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	""РазмещениеНоменклатурыПоСкладскимЯчейкам""
	|ИЗ
	|	РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
	|ГДЕ
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад = &Склад
	|	И РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НазваниеОбъекта");
	
КонецФункции

Функция ТекстЗапросаРасчетаРекомендуемойДатыНачалаНовойСхемыУчетаНаСкладе(Описания,ОтбиратьПоПомещению = Ложь)
	
	ЭтоПервыйВМассиве = Истина;
	ТекстЗапроса = "";
	
	Для Каждого Описание Из Описания Цикл
		ПрисоединитьТЧ = СтрНайти(Описание.ИмяПоляСклад,"ТЧ.") > 0 Или СтрНайти(Описание.ИмяПоляДата,"ТЧ.");
		Текст ="
				|ВЫБРАТЬ
				|	МАКСИМУМ(" + Описание.ИмяПоляДата + ") КАК Дата
				|ИЗ
				|	Документ." + Описание.Имя + " КАК Шапка " +
			?(ПрисоединитьТЧ,"ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ." + Описание.Имя + "."+ Описание.ИмяТЧ + " КАК ТЧ
				|ПО (Шапка.Ссылка = ТЧ.Ссылка)","") + "
				|ГДЕ Шапка.Проведен
				|И " + Описание.ИмяПоляСклад +" = &Склад";
		Если ОтбиратьПоПомещению Тогда
			Если Описание.Имя = "ОрдерНаПеремещениеТоваров" Тогда
				Текст = Текст + "
				|И Шапка.ПомещениеОтправитель = &Помещение
				|	ИЛИ Шапка.ПомещениеПолучатель = &Помещение";
			Иначе
				Текст = Текст + "
				|И " + ?(Найти(Описание.ИмяПоляСклад,"ТЧ.") > 0,"ТЧ.","Шапка.") + "Помещение = &Помещение";
			КонецЕсли;
		КонецЕсли;
		Если НЕ ЭтоПервыйВМассиве Тогда
			ТекстЗапроса = Текст + "
				|ОБЪЕДИНИТЬ ВСЕ" + ТекстЗапроса;
		Иначе
			ТекстЗапроса = Текст;
			ЭтоПервыйВМассиве = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО Дата УБЫВ";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ОписаниеОбъекта()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя");
	Описание.Вставить("ИмяТЧ",             "Товары");
	Описание.Вставить("ИмяПоляСклад",      "Шапка.Склад");
	Описание.Вставить("ИмяПоляДата",       "Шапка.Дата");
	Возврат Описание;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
