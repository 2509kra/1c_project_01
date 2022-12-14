#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет строку с результатом согласования рецензента в тч РезультатыСогласования.
//
// Параметры:
//	ТочкаМаршрута         - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеПродажи - текущая точка маршрута согласования.
//	Рецензент             - СправочникСсылка.Пользователи - исполнитель задачи по согласованию.
//	РезультатСогласования - ПеречислениеСсылка.РезультатыСогласования - результат согласования.
//	Комментарий           - Строка - комментарий рецензента.
//	ДатаИсполнения        - Дата - дата выполнения задачи по согласованию рецензентом.
//
Процедура ДобавитьРезультатСогласования(Знач ТочкаМаршрута,
	                                    Знач Рецензент,
	                                    Знач РезультатСогласования,
	                                    Знач Комментарий,
	                                    Знач ДатаИсполнения) Экспорт
	
	НоваяСтрока                       = РезультатыСогласования.Добавить();
	НоваяСтрока.ТочкаМаршрута         = ТочкаМаршрута;
	НоваяСтрока.Рецензент             = Рецензент;
	НоваяСтрока.РезультатСогласования = РезультатСогласования;
	НоваяСтрока.Комментарий           = Комментарий;
	НоваяСтрока.ДатаСогласования      = ДатаИсполнения;
	
	Если БизнесПроцессы.СогласованиеПродажи.ИспользуетсяВерсионированиеПредмета(Предмет.Метаданные().ПолноеИмя()) Тогда
		НоваяСтрока.НомерВерсии = БизнесПроцессы.СогласованиеПродажи.НомерПоследнейВерсииПредмета(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтение:    Без ограничения.
	// Изменение: Не используется.
	
	// Чтение, Изменение: набор №0.
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	
КонецПроцедуры 

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата согласования должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ДатаСогласования) И ДатаСогласования < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Дата согласования должна быть не меньше даты бизнес-процесса %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаСогласования",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		
		ИмяТаблицы = Предмет.Метаданные().ПолноеИмя();
		
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|" + ?(ИмяТаблицы = "Справочник.СоглашенияСКлиентами","
			|	ВЫБОР
			|		КОГДА
			|			ДокументПредмет.Согласован
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиСогласован,
			|	ЛОЖЬ КАК ЕстьОшибкиПроведен,
			|","
			|	ВЫБОР
			|		КОГДА
			|			ДокументПредмет.Проведен И ДокументПредмет.Согласован
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиСогласован,
			|	ВЫБОР
			|		КОГДА
			|			НЕ ДокументПредмет.Проведен
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиПроведен,
			|") + "
			|	ДокументПредмет.Статус КАК Статус,
			|	ДокументПредмет.Ссылка КАК Предмет
			|ИЗ
			|	" + ИмяТаблицы + " КАК ДокументПредмет
			|ГДЕ
			|	ДокументПредмет.Ссылка = &Предмет
			|");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		// Документ не проведен - нет смысла начинать согласование
		Если Выборка.ЕстьОшибкиПроведен Тогда
			
			ТекстОшибки = НСтр("ru='Согласование не может быть начато, т.к. документ %ДокументПредмет% не проведен'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДокументПредмет%", Выборка.Предмет);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
			
		// Документ уже согласован - нет смысла начинать согласование
		ИначеЕсли Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru='%Предмет% в статусе ""%Статус%"" не нуждается в согласовании'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%",  Выборка.Статус);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		ЗаполнитьБизнесПроцессНаОснованииЗаказаКлиента(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
		ЗаполнитьБизнесПроцессНаОснованииСоглашенияСКлиентом(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачала            = Дата(1,1,1);
	ДатаОкончания         = Дата(1,1,1);
	РезультатСогласования = Перечисления.РезультатыСогласования.ПустаяСсылка();
	ЕстьОтклоненияОтЛогистическихУсловий = Ложь;
	ЕстьОтклоненияОтФинансовыхУсловий    = Ложь;
	ЕстьОтклоненияОтЛогистическихУсловий = Ложь;
	
	РезультатыСогласования.Очистить();
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	ШаблонСообщений = НСтр("ru='Не указан %РольСогласующего%. Указать можно в разделе НСИ и Администрирование - Продажи - Согласование'");
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийКоммерческиеУсловияПродаж) Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщений, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийКоммерческиеУсловияПродаж);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЛогистическиеУсловияПродаж) Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщений, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийЛогистическиеУсловияПродаж);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийФинансовыеУсловияПродаж) Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщений, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийФинансовыеУсловияПродаж);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЦеновыеУсловияПродаж) Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщений, "%РольСогласующего", Справочники.РолиИсполнителей.СогласующийЦеновыеУсловияПродаж);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ПроверкаОтклоненияОтУсловийСоглашенияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ПродажиСервер.ПроверитьНеобходимостьСогласованияУсловийПродажи(
		Предмет,
		ЕстьОтклоненияОтЦеновыхУсловий,
		ЕстьОтклоненияОтФинансовыхУсловий,
		ЕстьОтклоненияОтЛогистическихУсловий);
	
	Записать();
	
КонецПроцедуры

Процедура ОбработкаРезультатовСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредметОбъект = Предмет.ПолучитьОбъект();
	
	НеобходимоСогласовать = Ложь;
	ТипПредмета = ТипЗнч(Предмет);
	Если ТипПредмета = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
		Если Не ПредметОбъект.ПометкаУдаления И Не ПредметОбъект.Согласован Тогда
			НеобходимоСогласовать = Истина;
		КонецЕсли;
	Иначе
		Если Не ПредметОбъект.ПометкаУдаления И Не (ПредметОбъект.Проведен И ПредметОбъект.Согласован) Тогда
			НеобходимоСогласовать = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Если документ уже согласован - ничего делать не требуется
	Если НеобходимоСогласовать Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Предмет);
		Исключение
			
			ТекстОшибки = НСтр("ru='В ходе обработки результатов согласования не удалось заблокировать %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		ПредметОбъект.Согласован = Истина;
		
		ТипПредмета = ТипЗнч(Предмет);
			
		Если ТипПредмета = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			Если ПредметОбъект.Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован Тогда
				
				ПредметОбъект.Статус = Перечисления.СтатусыЗаказовКлиентов.КОбеспечению;
				ПредметОбъект.ДатаСогласования = ТекущаяДатаСеанса();
				
				ЭтоЗаказСоСклада = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента")
					И Не ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
				
				Если ЭтоЗаказСоСклада Тогда
					ОбеспечениеСервер.ЗаполнитьВариантОбеспеченияПоУмолчанию(ПредметОбъект.Товары, Ложь, ПредметОбъект.Статус);
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ТипПредмета = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
			
			Если ПредметОбъект.Статус = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано Тогда
				ПредметОбъект.Статус = Перечисления.СтатусыСоглашенийСКлиентами.Действует;
			КонецЕсли;
			
		КонецЕсли;
		
		Попытка
			
			Если ТипПредмета = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
				ПредметОбъект.Записать();
			Иначе
				ПредметОбъект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			
			РазблокироватьДанныеДляРедактирования(Предмет);
			
		Исключение
			
			РазблокироватьДанныеДляРедактирования(Предмет);
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтЦеновыхУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтЦеновыхУсловий;
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтФинансовыхУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтФинансовыхУсловий;
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтЛогистическихУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтЛогистическихУсловий;
	
КонецПроцедуры

Процедура ДокументСогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	Задача.Исполнитель = Автор;
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура СогласоватьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура СогласоватьДокументОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьБизнесПроцессНаОснованииЗаказаКлиента(ДокументОснование)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка           КАК Предмет,
		|	ЗаказКлиента.ДатаСогласования КАК ДатаСогласования,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Приоритет В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					Приоритеты.Ссылка КАК Приоритет
		|				ИЗ
		|					Справочник.Приоритеты КАК Приоритеты
		|				УПОРЯДОЧИТЬ ПО
		|					Приоритеты.РеквизитДопУпорядочивания)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|		КОГДА ЗаказКлиента.Приоритет В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					Приоритеты.Ссылка КАК Приоритет
		|				ИЗ
		|					Справочник.Приоритеты КАК Приоритеты
		|				УПОРЯДОЧИТЬ ПО
		|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Обычная)
		|	КОНЕЦ                         КАК Важность,
		|	ЗаказКлиента.Статус           КАК Статус,
		|	НЕ ЗаказКлиента.Проведен      КАК ЕстьОшибкиПроведен,
		|	ВЫБОР
		|		КОГДА
		|			ЗаказКлиента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.НеСогласован)
		|		ТОГДА
		|			ЛОЖЬ
		|		ИНАЧЕ
		|			ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &ДокументОснование
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовКлиентов.НеСогласован);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Выборка.Предмет,
		Выборка.Статус,
		Выборка.ЕстьОшибкиПроведен,
		Выборка.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ЗаполнитьБизнесПроцессНаОснованииСоглашенияСКлиентом(ДокументОснование)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	СоглашениеСКлиентом.Ссылка           КАК Предмет,
		|	СоглашениеСКлиентом.Статус           КАК Статус,
		|	ВЫБОР
		|		КОГДА
		|			СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.НеСогласовано)
		|		ТОГДА
		|			ЛОЖЬ
		|		ИНАЧЕ
		|			ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашениеСКлиентом
		|ГДЕ
		|	СоглашениеСКлиентом.Ссылка = &ДокументОснование
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Выборка.Предмет,
		Выборка.Статус,
		,
		Выборка.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Предмет") Тогда
		
		ТипПредмета = ТипЗнч(ДанныеЗаполнения.Предмет);
		
		Если ТипПредмета = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			ЗаполнитьБизнесПроцессНаОснованииЗаказаКлиента(ДанныеЗаполнения.Предмет);
		ИначеЕсли ТипПредмета = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
			ЗаполнитьБизнесПроцессНаОснованииСоглашенияСКлиентом(ДанныеЗаполнения.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьБизнесПроцесс()
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция СоздатьЗадачу(Знач ТочкаМаршрутаБизнесПроцесса)
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	Задача.Дата                          = ТекущаяДатаСеанса();
	Задача.Автор                         = Автор;
	Задача.Наименование                  = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи;
	Задача.Описание                      = Наименование;
	Задача.Предмет                       = Предмет;
	Задача.Важность                      = Важность;
	Задача.РольИсполнителя               = ТочкаМаршрутаБизнесПроцесса.РольИсполнителя;
	Задача.ОсновнойОбъектАдресации       = ТочкаМаршрутаБизнесПроцесса.ОсновнойОбъектАдресации;
	Задача.ДополнительныйОбъектАдресации = ТочкаМаршрутаБизнесПроцесса.ДополнительныйОбъектАдресации;
	Задача.БизнесПроцесс                 = Ссылка;
	Задача.СрокИсполнения                = ДатаСогласования;
	Задача.ТочкаМаршрута                 = ТочкаМаршрутаБизнесПроцесса;
	
	Возврат Задача;

КонецФункции

#КонецОбласти

#КонецОбласти


#КонецЕсли
