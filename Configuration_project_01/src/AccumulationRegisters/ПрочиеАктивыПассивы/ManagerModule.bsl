#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
// Формирует текст запроса для формирования движений по регистру "Активы и пассивы".
//
Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(ЕстьВтПартииПрочихРасходов = Истина) Экспорт
	
	ТекстЗапроса = "
	// Отражение уменьшения пассивов у организации - источника.
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки) КАК Статья,
	|	Строки.Организация КАК Аналитика,
	|	СУММА(Строки.Сумма) КАК Сумма
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|СГРУППИРОВАТЬ ПО
	|	Строки.Период,
	|	Строки.Организация,
	|	Строки.Подразделение,
	|	Строки.НаправлениеДеятельности
	|
	// Отражение увеличения пассивов учете у организации - получателя.
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Строки.ОрганизацияПолучатель КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки) КАК Статья,
	|	Строки.ОрганизацияПолучатель КАК Аналитика,
	|	СУММА(Строки.Сумма) КАК Сумма
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|СГРУППИРОВАТЬ ПО
	|	Строки.Период,
	|	Строки.ОрганизацияПолучатель,
	|	Строки.Подразделение,
	|	Строки.НаправлениеДеятельности
	|";
	Если ЕстьВтПартииПрочихРасходов Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		// Отражение уменьшения пассивов у организации - источника.
		|ВЫБРАТЬ
		|	Строки.Период КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	Строки.Организация КАК Организация,
		|	Строки.Подразделение КАК Подразделение,
		|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
		|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки) КАК Статья,
		|	Строки.Организация КАК Аналитика,
		|	СУММА(Строки.Стоимость) КАК Сумма
		|ИЗ
		|	ВтПартииПрочихРасходов КАК Строки
		|ГДЕ
		|	Строки.ОрганизацияПолучатель <> Строки.Организация
		|СГРУППИРОВАТЬ ПО
		|	Строки.Период,
		|	Строки.Организация,
		|	Строки.Подразделение,
		|	Строки.НаправлениеДеятельности
		|
		// Отражение увеличения пассивов учете у организации - получателя.
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|	Строки.Период КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	Строки.ОрганизацияПолучатель КАК Организация,
		|	Строки.Подразделение КАК Подразделение,
		|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
		|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки) КАК Статья,
		|	Строки.ОрганизацияПолучатель КАК Аналитика,
		|	СУММА(Строки.Стоимость) КАК Сумма
		|ИЗ
		|	ВтПартииПрочихРасходов КАК Строки
		|ГДЕ
		|	Строки.ОрганизацияПолучатель <> Строки.Организация
		|СГРУППИРОВАТЬ ПО
		|	Строки.Период,
		|	Строки.ОрганизацияПолучатель,
		|	Строки.Подразделение,
		|	Строки.НаправлениеДеятельности
		|";
	КонецЕсли;
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрНакопления.ПрочиеАктивыПассивы";
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ПрочиеАктивыПассивы.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.4.9.12";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a2553e25-65f9-47b3-81ff-44255b36833c");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПрочиеАктивыПассивы.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Прочие активы/пассивы""
	|- заполняет новый реквизит ВидИсточника'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	СписокЗапросов = Новый Массив;
	
	
	Если СписокЗапросов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = ПолноеИмяРегистра();
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		ТипДокументСсылка = ТипЗнч(Регистратор);
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПрочиеАктивыПассивы.НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыНакопления.ПрочиеАктивыПассивы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
			НаборЗаписей.Прочитать();
			
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать движения по регистру ""Активы и пассивы"" документа ""%1"" по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Регистратор, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеРегистра,
				Регистратор,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеУправленческогоБаланса

Процедура ЗарегистироватьКОбновлениюУправленческогоБаланса(Параметры, Регистраторы, ПолноеИмяРегистраИсточника) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ФормироватьУправленческийБаланс")
		ИЛИ НЕ Константы.ЗаполненыДвиженияАктивовПассивов.Получить()
		ИЛИ НЕ ВлияетНаУправленческийБаланс(ПолноеИмяРегистраИсточника)
		ИЛИ НЕ ЗначениеЗаполнено(Регистраторы) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыУпрБаланса = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Параметры);
	ПараметрыУпрБаланса.Очередь = ОбновлениеИнформационнойБазы.ОчередьОтложенногоОбработчикаОбновления("РегистрыНакопления.ПрочиеАктивыПассивы.ОбработатьДанныеДляПереходаНаНовуюВерсию");
	Регистраторы = ОтобратьРегистраторыУправленческогоБаланса(Регистраторы);
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(ПараметрыУпрБаланса, Регистраторы, ПолноеИмяРегистра());
	
КонецПроцедуры

Функция ОтобратьРегистраторыУправленческогоБаланса(Регистраторы)
	
	Типы = Новый Соответствие;
	Для Каждого Регистратор Из Регистраторы Цикл
		Типы.Вставить(ТипЗнч(Регистратор));
	КонецЦикла;
	МассивТипов = Новый Массив;
	Для Каждого Тип Из Типы Цикл
		МассивТипов.Добавить(Тип.Ключ);
	КонецЦикла;
	ТипКолонки = Новый ОписаниеТипов(МассивТипов);
	
	ТаблицаРегистраторов = Новый ТаблицаЗначений;
	ТаблицаРегистраторов.Колонки.Добавить("Регистратор", ТипКолонки);
	Для Каждого Регистратор Из Регистраторы Цикл
		НоваяСтрока = ТаблицаРегистраторов.Добавить();
		НоваяСтрока.Регистратор = Регистратор;
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	 Т.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ втРегистраторы
	|ИЗ
	|	&ТаблицаРегистраторов КАК Т
	|;
	|
	|ВЫБРАТЬ
	|	Т.Регистратор КАК Регистратор
	|ИЗ
	|	втРегистраторы КАК Т
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&ТипыРегистраторовРегистра)";
	
	ТипыРегистраторовРегистра = Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы.СтандартныеРеквизиты.Регистратор.Тип.Типы();
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТипыРегистраторовРегистра", ТипыРегистраторовРегистра);
	Запрос.УстановитьПараметр("ТаблицаРегистраторов", ТаблицаРегистраторов);
	
	Выборка = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	Возврат Выборка;
	
КонецФункции

// Проверяет влияние обновления регистра-источника на управленческий баланс.
// Если в регистре-источник изменились незначимые реквизиты или обработчик обновления отсутствует,
// то после его обновления движения упр. баланса не изменятся.
// Флаги проставляются вручную на основании экспертной оценки.
//
// Параметры:
//  ПолноеИмяРегистра - Строка - полное имя регистра в формате "РегистрНакопления.ИмяРегисра".
//
// Возвращаемое значение:
//  Истина - изменения в источника влияют на упр. баланс
//  Соответствие - если ПолноеИмяРегистра = НЕОПРЕДЕЛНО, возвращается соответствие со всеми влияющими источниками упр. баланса.
Функция ВлияетНаУправленческийБаланс(ПолноеИмяРегистра = Неопределено)
	
	ОбновлениеИзменитБаланс = Новый Соответствие;
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеДокументыСсылка"               , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеСредстваБезналичные"           , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеСредстваВКассахККМ"            , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеСредстваВПути"                 , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеСредстваНаличные"              , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц"       , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПартииПрочихРасходов"                  , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПереданнаяВозвратнаяТара"              , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПодарочныеСертификаты"                 , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПринятаяВозвратнаяТара"                , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПрочиеАктивыПассивы"                   , Истина);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПрочиеДоходы"                          , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ПрочиеРасходы"                         , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.РасчетыПоФинансовымИнструментам"       , Истина);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.РасчетыСКлиентамиПоДокументам"         , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.РасчетыСПоставщикамиПоДокументам"      , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.РасчетыСКлиентамиПоСрокам"             , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.РасчетыСПоставщикамиПоСрокам"          , Ложь);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.СебестоимостьТоваров"                  , Истина);
	ОбновлениеИзменитБаланс.Вставить("РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту"     , Истина);
	
	Если ПолноеИмяРегистра = Неопределено Тогда
		ВлияющиеИсточники = Новый Соответствие;
		Для Каждого Источник Из ОбновлениеИзменитБаланс Цикл
			Если Источник.Значение Тогда
				ВлияющиеИсточники.Вставить(Источник.Ключ, Истина);
			КонецЕсли;
		КонецЦикла;
		Возврат ВлияющиеИсточники;
	КонецЕсли;
	
	Возврат ОбновлениеИзменитБаланс[ПолноеИмяРегистра];
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли