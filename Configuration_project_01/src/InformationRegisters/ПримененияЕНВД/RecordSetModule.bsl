#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
		
	Организация = ЭтотОбъект.Отбор.Организация.Значение;
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОбособленноеПодразделение") = Истина
		И ЭтотОбъект.ДополнительныеСвойства.Свойство("СинхронизацияНастроек") <> Истина Тогда
		
		ТекстОшибки = НСтр("ru='Изменение настроек применения ЕНВД необходимо выполнять из головной организации.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	СинхронизироватьНастройкиОбособленныхПодразделений(ЭтотОбъект, Отказ);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура СинхронизироватьНастройкиОбособленныхПодразделений(НастройкиГоловнойОрганизации, Отказ)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс")
		Или ЭтотОбъект.ДополнительныеСвойства.Свойство("СинхронизацияНастроек") = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Ссылка";
		
	Запрос.УстановитьПараметр("Ссылка", НастройкиГоловнойОрганизации.Отбор.Организация.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НастройкиОбособленногоПодразделения = РегистрыСведений.ПримененияЕНВД.СоздатьНаборЗаписей();
		НастройкиОбособленногоПодразделения.Отбор.Организация.Установить(Выборка.Ссылка);
		
		ОтборСклад = НастройкиГоловнойОрганизации.Отбор.Склад;
		Если ОтборСклад.Использование Тогда
			НастройкиОбособленногоПодразделения.Отбор.Склад.Установить(ОтборСклад.Значение);
		КонецЕсли;
		
		ОтборПериод = НастройкиГоловнойОрганизации.Отбор.Период;
		Если ОтборПериод.Использование Тогда
			НастройкиОбособленногоПодразделения.Отбор.Период.Установить(ОтборПериод.Значение);
		КонецЕсли;
		
		Для Каждого НастройкаГоловнойОрганизации Из НастройкиГоловнойОрганизации Цикл
			
			НастройкаОбособленногоПодразделения = НастройкиОбособленногоПодразделения.Добавить();
			ЗаполнитьЗначенияСвойств(НастройкаОбособленногоПодразделения, НастройкаГоловнойОрганизации);
			НастройкаОбособленногоПодразделения.Организация = Выборка.Ссылка;
			
		КонецЦикла;
		
		Попытка
			
			НастройкиОбособленногоПодразделения.ДополнительныеСвойства.Вставить("СинхронизацияНастроек", Истина);
			НастройкиОбособленногоПодразделения.Записать();
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось изменить настройки применения ЕНВД. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
			Возврат;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли