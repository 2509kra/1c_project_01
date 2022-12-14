#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу классификатора из макета с предопределенными элементами.
// Макеты хранятся в макетах данного справочника (см. общую форму "ДобавлениеЭлементовВКлассификатор").
//
// Параметры:
//	Переменные - Строка - в данном методе не используется, однако является обязательной в случае обращения
//							к другим классификаторам.
//
// Возвращаемое значение:
//		ТаблицаЗначений - таблица классификатора с колонками:
//			* Код					- Строка - строковое представление кода элемента классификатора.
//			* Наименование			- Строка - наименование элемента классификатора.
//			* ЕдиницаИзмеренияКод	- Строка - код единицы измерения по ОКЕИ.
//			* ПрослеживаемыйТовар	- Булево - признак того, что товар подлежит учету в системе прослеживаемости.
//
Функция ТаблицаКлассификатора(Знач Переменные) Экспорт
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТоварнойНоменклатурыВнешнеэкономическойДеятельности");
	
	// В полученном макете содержатся значения всех списков используемых в отчете, ищем переданный.
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		
		// Заполнение дерева данными списка.
		ВерхОбласти	= Список.Верх;
		НизОбласти	= Список.Низ;
		
		НомерКолонки	= 1;
		Область			= Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки		= Область.Текст;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255)));
			ИначеЕсли ИмяКолонки = "ЕдиницаИзмерения" Тогда
				ТаблицаПоказателей.Колонки.Добавить("ЕдиницаИзмеренияКод",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(3)));
			ИначеЕсли ИмяКолонки = "ПрослеживаемыйТовар" Тогда
				ТаблицаПоказателей.Колонки.Добавить("ПрослеживаемыйТовар",Новый ОписаниеТипов("Булево"));
			КонецЕсли;
			
			НомерКолонки	= НомерКолонки + 1;
			Область			= Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки		= Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			
			// Отображаем только элементы.
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			
			Если СтрДлина(Код) = 2 Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				
				Если Колонка.Имя = "ПрослеживаемыйТовар" Тогда
					СтрокаСписка[Колонка.Имя] = Число(СокрЛП(ЗначениеКолонки)) = 1;
				Иначе
					СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

Процедура ЗаполнитьКодыТНВЭДВКоллекции(Коллекция, ПолеНоменклатуры, КодыТНВЭДНоменклатуры, СоответствиеКодов, Отказ) Экспорт
	
	Для Каждого СтрокаТЧ Из Коллекция Цикл
		
		СтрокаКода = КодыТНВЭДНоменклатуры.Найти(СтрокаТЧ[ПолеНоменклатуры],"ПолеНоменклатуры");
		
		Если СтрокаКода = Неопределено Тогда
			СтрокаКода = КодыТНВЭДНоменклатуры.Найти(СтрокаТЧ[ПолеНоменклатуры].Номенклатура,"ПолеНоменклатуры");
			Если СтрокаКода = Неопределено Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаКода.КодТНВЭД = ПустаяСсылка() Тогда
			СтрокаТЧ.КодТНВЭД = СоответствиеКодов[СтрокаКода.СырьевойТовар];
		Иначе
			СтрокаТЧ.КодТНВЭД = СтрокаКода.КодТНВЭД;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСлужебныеЭлементы() Экспорт
	
	СоответствиеКодов = Новый Соответствие;
	СоответствиеКодов.Вставить(Ложь, НайтиПоНаименованию("несырьевой товар"));
	СоответствиеКодов.Вставить(Истина, НайтиПоНаименованию("сырьевой товар"));
	
	Возврат СоответствиеКодов;
	
КонецФункции

// Функция ищет по коду элементы в справочнике Классификатор ТН ВЭД.
//  Если их нет, то создает элементы справочника в соответствии с классификатором ТН ВЭД ЕАЭС.
//
// Параметры:
//  Код - Строка(10) - Строка с кодом классификатора ТН ВЭД,
//  РежимОбновления - Булево, Истина - признак записи объекта через метод ОбновлениеИнформационнойБазы.ЗаписатьОбъект().
// 
// Возвращаемое значение:
//  Ссылка - ссылка на элемент классификатора или Неопределено, если такого кода нет в ТН ВЭД.
//
Функция НайтиСоздатьЭлементКлассификатораТНВЭД(Код, РежимОбновления = Ложь) Экспорт
	
	СуществующийЭлемент = Справочники.КлассификаторТНВЭД.НайтиПоКоду(Код);
	Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
		
		ТаблицаКлассификатора = ТаблицаКлассификатора(1);
		ТаблицаКлассификатора.Индексы.Добавить("Код");
		
		СтруктураПоиска = Новый Структура("Код",Код);
		НайденныеСтроки = ТаблицаКлассификатора.НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() = 1 Тогда
			СвойстваЭлемента = НайденныеСтроки[0];
			
			СправочникОбъект = Справочники.КлассификаторТНВЭД.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(СправочникОбъект, СвойстваЭлемента);
			
			СправочникОбъект.НаименованиеПолное = СвойстваЭлемента.Наименование;
			
			Соответствие = Справочники.УпаковкиЕдиницыИзмерения.ЗаполнитьЕдиницыИзмеренияИзКлассификатора(СвойстваЭлемента.ЕдиницаИзмеренияКод,
																											РежимОбновления);
			Если Соответствие <> Неопределено Тогда
				СправочникОбъект.ЕдиницаИзмерения = Соответствие[СвойстваЭлемента.ЕдиницаИзмеренияКод];
			КонецЕсли;
			
			Если РежимОбновления Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			Иначе
				СправочникОбъект.Записать();
			КонецЕсли;
			
			Возврат СправочникОбъект.Ссылка;
			
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат СуществующийЭлемент;
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.КлассификаторТНВЭД.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.4.13.262";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("44268cf0-d303-4b40-9a87-6491d85a1bf4");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.КлассификаторТНВЭД.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит ""Прослеживаемый товар"" в соответствии с классификатором ТН ВЭД.
	|Заполняет реквизит ""единица измерения"", если он не заполнен.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.КлассификаторТНВЭД.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.УпаковкиЕдиницыИзмерения.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.КлассификаторТНВЭД.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.КлассификаторТНВЭД.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеОбъекта.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторТНВЭД КАК ДанныеОбъекта
	|ГДЕ
	|	ДанныеОбъекта.Ссылка В (&ПрослеживаемыеКодыТНВЭД)
	|	И НЕ ДанныеОбъекта.ПрослеживаемыйТовар
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КлассификаторТНВЭД.Ссылка
	|ИЗ
	|	Справочник.КлассификаторТНВЭД КАК КлассификаторТНВЭД
	|ГДЕ
	|	КлассификаторТНВЭД.ЕдиницаИзмерения = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ПрослеживаемыеКодыТНВЭД", ПрослеживаемыеКодыТНВЭД());
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.КлассификаторТНВЭД";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	ПрослеживаемыеКодыТНВЭД = ПрослеживаемыеКодыТНВЭД();
	Соответствие = Справочники.УпаковкиЕдиницыИзмерения.ЗаполнитьЕдиницыИзмеренияИзКлассификатора("796", Истина);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДанныеОбъекта = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ДанныеОбъекта = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				
				Продолжить;
			КонецЕсли;
			
			ОбъектИзменен = Ложь;
			
			Если Не ДанныеОбъекта.ПрослеживаемыйТовар
				И ПрослеживаемыеКодыТНВЭД.Найти(Выборка.Ссылка) <> Неопределено Тогда
				
				ОбъектИзменен = Истина;
				ДанныеОбъекта.ПрослеживаемыйТовар = Истина;
				
			КонецЕсли;
			
			Если ДанныеОбъекта.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()
				и Соответствие <> Неопределено Тогда
				
				ОбъектИзменен = Истина;
				ДанныеОбъекта.ЕдиницаИзмерения = Соответствие["796"];
				
			КонецЕсли;
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДанныеОбъекта);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
																						ПолноеИмяОбъекта);
	
КонецПроцедуры

Функция ПрослеживаемыеКодыТНВЭД(ПроверитьПризнакПрослеживаемости = Ложь)
	
	КодыТНВЭД = Новый Массив;
	
	Макет			= Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТоварнойНоменклатурыВнешнеэкономическойДеятельности");
	ОбластиМакета	= Макет.Области;
	
	НомерКолонкиКод					= ОбластиМакета.Найти("ОбластьКодТНВЭД").Лево;
	НомерКолонкиПрослеживаемости	= ОбластиМакета.Найти("ОбластьПрослеживаемыйТовар").Лево;
	
	Для Каждого ОбластьМакета Из ОбластиМакета Цикл
		Если СтрНайти(ОбластьМакета.Имя, "ОбластьПрослеживаемыйТовар_") = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВверхОбласти	= ОбластьМакета.Верх;
		НизОбласти		= ОбластьМакета.Низ;
		
		Пока ВверхОбласти <= НизОбласти Цикл
			ЗначениеКодаТНВЭД			= СокрЛП(Макет.Область(ВверхОбласти,
																НомерКолонкиКод,
																ВверхОбласти,
																НомерКолонкиКод).Текст);
			ЗначениеПрослеживаемости	= СокрЛП(Макет.Область(ВверхОбласти,
																НомерКолонкиПрослеживаемости,
																ВверхОбласти,
																НомерКолонкиПрослеживаемости).Текст);
			
			Если ЗначениеПрослеживаемости = "1" Тогда
				КодТНВЭД = Справочники.КлассификаторТНВЭД.НайтиПоКоду(ЗначениеКодаТНВЭД);
				
				Если ЗначениеЗаполнено(КодТНВЭД) Тогда
					Если Не ПроверитьПризнакПрослеживаемости Тогда
						КодыТНВЭД.Добавить(КодТНВЭД);
					ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодТНВЭД, "ПрослеживаемыйТовар") Тогда
						КодыТНВЭД.Добавить(КодТНВЭД);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ВверхОбласти = ВверхОбласти + 1;
		КонецЦикла
		
	КонецЦикла;
	
	Возврат КодыТНВЭД;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли