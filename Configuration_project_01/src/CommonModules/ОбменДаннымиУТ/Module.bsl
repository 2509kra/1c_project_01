#Область ПрограммныйИнтерфейс

// Возвращает признак доступности выполнения операций по закрытию месяца в текущей ИБ.
//
// Параметры:
//   Отказ - Булево - признак отказа от выполнения операции.
//
// Возвращаемое значение:
//   Булево - Истина, если выполнение операций по закрытию месяца доступно в данной ИБ,
//            Ложь - в противном случае.
//
Функция ВЭтомУзлеДоступноВыполнениеОперацийЗакрытияМесяца(Отказ) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		Отказ = Истина;
		
		СообщениеПользователю = 
			НСтр("ru = 'Выполнять регламентные операции связанные с закрытием месяца
			|в подчиненном узле распределенной информационной базы не требуется,
			|они выполняются только в центральном узле информационной базы.'");
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Определяет перечень доступных версий универсального формата EnterpriseData.
//
// Параметры:
//  ВерсииФормата - Соответствие - Соответствие номера версии формата общему модулю,
//                  в котором находятся обработчики выгрузки/загрузки для данной версии.
//
Процедура ДоступныеВерсииУниверсальногоФормата(ВерсииФормата) Экспорт
	
	ВерсииФормата.Вставить("1.3", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.4", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.5", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.7", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.8", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.10", МенеджерОбменаЧерезУниверсальныйФормат);
	
КонецПроцедуры

// Обработчик после загрузки данных.
// Используется в типовых правилах конвертации при обменах и переносах данных.
// Вызывается из соответствующего обработчика событий "После загрузки данных" правил конвертации.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//            * ПроверятьНаИспользованиеИмпортныхТоваров - Булево - Если Истина - будет включено использование
//              импортных товаров при необходимости (если в базе есть элементы справочника "Номера ГТД").
//            * ПроверятьНаИспользованиеИмпортныхЗакупок - Булево - Если Истина - будет включено использование
//              импортных закупок (если в базе есть соответствующие операции).
//            * ПроверятьНаИспользованиеКомиссииПриЗакупках - Булево - Если Истина - будет включено использование
//              комиссии при закупках (если в базе есть соответствующие операции).
//            * ПроверятьНаИспользованиеКомиссииПриПродажах - Булево - Если Истина - будет включено использование
//              комиссии при продажах (если в базе есть соответствующие операции).
//            * ПроверятьНаИспользованиеДоговоров - Булево - Если Истина - будет включено использование
//              договоров контрагентов (если в базе есть хотя бы один договор с покупателем).
//            * ПроверятьНаИспользованиеРозничныхПродаж - Булево - Если Истина - будет включено использование
//              розничных продаж (если в базе есть соответствующие операции).
//            * ПроверятьНаИспользованиеПеремещений - Булево - Если Истина - будет включено использование
//              перемещений товаров (если в базе есть соответствующие операции).
//            * ПроверятьНаИспользованиеНесколькихВидовНоменклатуры - Булево - Если Истина - будет включено использование
//              нескольких видов номенклатуры (если видов номенклатуры от 3 и более).
//            * ПроверятьНаИспользованиеАлкогольнойПродукцииВРознице - Булево - Если Истина - будет включено
//              использование розничных продаж алкогольной продукции (если в базе есть виды номенклатуры с.
//              признаком "Алкогольная продукция").
//            * ПроверятьНаИспользованиеОтгрузкиБезПереходаПраваСобственности - Булево - Если Истина - будет включено
//              использование операций отгрузки без перехода права собственности (если в базе есть соответствующие
//              операции.
//
Процедура ПослеЗагрузкиДанных(Параметры) Экспорт
	
	Если Параметры.ПроверятьНаИспользованиеИмпортныхТоваров
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеТовары") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Справочник.НомераГТД КАК НомераГТД");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьИмпортныеТовары.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеИмпортныхЗакупок
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.ТаможеннаяДекларацияИмпорт КАК Док
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	1
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг КАК Док
		|ГДЕ
		|	Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту)");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьИмпортныеЗакупки.Установить(Истина);
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеТовары") Тогда
				Константы.ИспользоватьИмпортныеТовары.Установить(Истина);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеКомиссииПриЗакупках
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.ОтчетКомитенту КАК Док
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	1
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг КАК Док
		|ГДЕ
		|	Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию)");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьКомиссиюПриЗакупках.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеКомиссииПриПродажах
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.ОтчетКомиссионера КАК Док
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	1
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК Док
		|ГДЕ
		|	Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию)");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Если Константы.ИспользованиеСоглашенийСКлиентами.Получить() = Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать Тогда
				ВключитьИспользованиеСоглашенийСКлиентамиПриНеобходимости();
				Если Константы.ИспользованиеСоглашенийСКлиентами.Получить() = Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать Тогда
					Константы.ИспользованиеСоглашенийСКлиентами.Установить(Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоТиповыеСоглашения);
				КонецЕсли;
			КонецЕсли;
			Константы.ИспользоватьКомиссиюПриПродажах.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеДоговоров Тогда
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами") Тогда
		
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	1 КАК Поле1
			|ИЗ
			|	Справочник.ДоговорыКонтрагентов КАК Спр
			|ГДЕ
			|	Спр.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем)");
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				Константы.ИспользоватьДоговорыСКлиентами.Установить(Истина);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками") Тогда
		
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	1 КАК Поле1
			|ИЗ
			|	Справочник.ДоговорыКонтрагентов КАК Спр
			|ГДЕ
			|	Спр.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПоставщиком)");
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				Константы.ИспользоватьДоговорыСПоставщиками.Установить(Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеРозничныхПродаж
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.ОтчетОРозничныхПродажах КАК Док
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	1
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК Док
		|ГДЕ
		|	Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ)");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьРозничныеПродажи.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ПроверятьНаИспользованиеПеремещений
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК Док");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьПеремещениеТоваров.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	Если Параметры.ПроверятьНаИспользованиеНесколькихВидовНоменклатуры
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
				"ВЫБРАТЬ 
				|	Количество(Спр.Ссылка) КАК Количество
				|ИЗ
				|	Справочник.ВидыНоменклатуры КАК Спр");
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		Если Выборка.Количество > 2 Тогда
			Константы.ИспользоватьНесколькоВидовНоменклатуры.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	Если Параметры.ПроверятьНаИспользованиеАлкогольнойПродукцииВРознице
		И Не ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийАлкоВРознице") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Справочник.ВидыНоменклатуры КАК Спр
		|ГДЕ АлкогольнаяПродукция");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ВестиСведенияДляДекларацийАлкоВРознице.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	Если Параметры.ПроверятьНаИспользованиеОтгрузкиБезПереходаПраваСобственности
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьОтгрузкуБезПереходаПраваСобственности") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК Док
		|ГДЕ Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности)");
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьОтгрузкуБезПереходаПраваСобственности.Установить(Истина);
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРеализацийТоваровУслуг") Тогда
				Константы.ИспользоватьСтатусыРеализацийТоваровУслуг.Установить(Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#Область ВыгрузкаЗагрузкаДанныхВСервисе

// Процедура-обработчик события "ПередЗагрузкойОбъекта" для механизма выгрузки/загрузки данных в сервисе.
// 
// Параметры:
//   Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//               контейнера, используемый в процессе загрузки данных.
//   Объект    - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//               БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//               ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//               РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//               РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//               объект данных информационной базы, перед загрузкой которого был вызван обработчик.
//               Значение, переданное в процедуру ПередЗагрузкойОбъекта() в качестве значения параметра
//               Объект может быть модифицировано внутри процедуры обработчика ПередЗагрузкойОбъекта().
//   Артефакты - Массив(ОбъектXDTO) - дополнительные данные, логически неразрывно связанные
//               с объектом данных, но не являющиеся его частью. Сформированы в экспортируемых процедурах
//               ПередВыгрузкойОбъекта() обработчиков выгрузки данных (см. комментарий к процедуре
//               ПриРегистрацииОбработчиковВыгрузкиДанных(). Каждый артефакт должен являться XDTO-объектом,
//               для типа которого в качестве базового типа используется абстрактный XDTO-тип
//               {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//               помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных.
//   Отказ     - Булево. Если в процедуре ПередЗагрузкойОбъекта() установить значение данного
//               параметра равным Истина - загрузка объекта данных выполняться не будет.
//
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	Объект.ДополнительныеСвойства.Вставить("РегистрироватьДанныеПервичныхДокументов", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Функция готовит структуру параметров, которые используются при синхронизации данных через универсальный формат.
Функция ПараметрыПослеЗагрузкиДанных() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПроверятьНаИспользованиеИмпортныхТоваров", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеИмпортныхЗакупок", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеКомиссииПриЗакупках", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеКомиссииПриПродажах", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеДоговоров", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеРозничныхПродаж", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеПеремещений", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеНесколькихВидовНоменклатуры", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеАлкогольнойПродукцииВРознице", Истина);
	Параметры.Вставить("ПроверятьНаИспользованиеОтгрузкиБезПереходаПраваСобственности", Истина);
	
	Возврат Параметры;
	
КонецФункции

Процедура ВключитьИспользованиеСоглашенийСКлиентамиПриНеобходимости()
	
	ТекущееЗначениеКонстанты = Константы.ИспользованиеСоглашенийСКлиентами.Получить();
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.СоглашенияСКлиентами КАК Спр
	|ГДЕ
	|	Спр.Типовое = ИСТИНА
	|	И Спр.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.СоглашенияСКлиентами КАК Спр
	|ГДЕ
	|	Спр.Типовое = ЛОЖЬ
	|	И Спр.ПометкаУдаления = ЛОЖЬ");
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ЕстьТиповые = Не РезультатыЗапроса[0].Пустой();
	ЕстьИндивидуальные = Не РезультатыЗапроса[1].Пустой();
	
	Если ЕстьТиповые И ЕстьИндивидуальные Тогда
		
		Если ТекущееЗначениеКонстанты <> Перечисления.ИспользованиеСоглашенийСКлиентами.ТиповыеИИндивидуальныеСоглашения Тогда
			Константы.ИспользованиеСоглашенийСКлиентами.Установить(Перечисления.ИспользованиеСоглашенийСКлиентами.ТиповыеИИндивидуальныеСоглашения);
		КонецЕсли;
		
	ИначеЕсли ЕстьТиповые Тогда
		
		Если ТекущееЗначениеКонстанты <> Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоТиповыеСоглашения
			И ТекущееЗначениеКонстанты <> Перечисления.ИспользованиеСоглашенийСКлиентами.ТиповыеИИндивидуальныеСоглашения Тогда
			Константы.ИспользованиеСоглашенийСКлиентами.Установить(Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоТиповыеСоглашения);
		КонецЕсли;
		
	ИначеЕсли ЕстьИндивидуальные Тогда
		
		Если ТекущееЗначениеКонстанты <> Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоИндивидуальныеСоглашения
			И ТекущееЗначениеКонстанты <> Перечисления.ИспользованиеСоглашенийСКлиентами.ТиповыеИИндивидуальныеСоглашения Тогда
			Константы.ИспользованиеСоглашенийСКлиентами.Установить(Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоИндивидуальныеСоглашения);
		КонецЕсли;
		
	ИначеЕсли Не ЗначениеЗаполнено(ТекущееЗначениеКонстанты) Тогда
		Константы.ИспользованиеСоглашенийСКлиентами.Установить(Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед записью настройки синхронизации данных, которая выполняет обмен с бухгалтерией.
// В случае необходимости меняется значение константы ИспользуетсяОбменСБухгалтериейПредприятия.
//
// Параметры:
//    ПланОбменаОбъект - записываемый узел плана обмена, предназначенный для обмена с бухгалтерией.
//    ЭтоУдаление - булево, признак того, что выполняется пометка на удаление или непосредственное удаление узла.
Процедура АктуализироватьПризнакИспользованияОбменаСБухгалтерией(ПланОбменаОбъект, ЭтоУдаление) Экспорт
	
	Если Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Получить() Тогда
		
		Если ЭтоУдаление Тогда
			
			// Установка в Ложь с проверкой других обменов с бухгалтерией.
			Запрос = ОбменДаннымиУТУП.ЗапросУзлыОбменаСБухгалтерией();
			ОбменСБухгалтериейНайден = Ложь;
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.Ссылка = ПланОбменаОбъект.Ссылка Тогда
					Продолжить;
				КонецЕсли;
				ОбменСБухгалтериейНайден = Истина;
				Прервать;
			КонецЦикла;
			Если НЕ ОбменСБухгалтериейНайден Тогда
				Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Установить(Ложь);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Не ЭтоУдаление И Не ПланОбменаОбъект.ЭтотУзел Тогда
		Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Установить(Истина);
	КонецЕсли;
КонецПроцедуры

#Область РасчетСебестоимости

// При получении из периферийного узла данных, требующих перерасчета себестоимости, добавляет запись в регистр ЗаданияКРасчетуСебестоимости.
//
// Параметры:
//	ПолученныеДанные - Произвольный - это параметр ЭлементДанных одноименного события плана обмена.
//
// Возвращаемое значение:
//	Булево - признак того, что ПолученныеДанные - это данные, относящиеся к механизму расчета себестоимости.
//
Функция СоздатьЗаданиеКРасчетуСебестоимостиПриОбменеДанными(ПолученныеДанные) Экспорт
	
	Возврат РасчетСебестоимостиПрикладныеАлгоритмы.СоздатьЗаданиеКРасчетуСебестоимостиПриОбменеДанными(ПолученныеДанные);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт 
	Возврат;
КонецПроцедуры

#КонецОбласти