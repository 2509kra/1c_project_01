
#Область ПрограммныйИнтерфейс

#Область ФункцииРаботыСВесамиСПечатьюЭтикеток

// Выгружает измененные данные в весы с печатью этикеток.
//
// Параметры:
//  ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения о завершении,
//                                                    вызывается после окончания выгрузки товаров в весы.
//  МассивУстройств - Массив - ссылки СправочникСсылка.ПодключаемоеОборудование на устройства в которые
//                             требуется выгрузить данные.
//  ПоказыватьПредупреждение - Булево  - Флаг, определяющий возможность показа предупреждения об окончании действия.
//
Процедура ВыгрузитьТоварыВВесы(ОписаниеОповещенияЗавершение, МассивУстройств, ПоказыватьПредупреждение = Истина) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется выгрузка товаров в весы с печатью этикеток...'"));
	
	СостояниеВыполнения = Новый Структура;
	СостояниеВыполнения.Вставить("ОписаниеОшибок", "");
	СостояниеВыполнения.Вставить("Выполнено",      0);
	СостояниеВыполнения.Вставить("Обработано",     0);
	СостояниеВыполнения.Вставить("ТребуетсяВыполнить",           МассивУстройств.Количество());
	СостояниеВыполнения.Вставить("ПоказыватьПредупреждение",     ПоказыватьПредупреждение);
	СостояниеВыполнения.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	
	Для Каждого ИдентификаторУстройства Из МассивУстройств Цикл
		
		СтруктураДанные = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьДанныеДляВесов(ИдентификаторУстройства, Истина);
		Если СтруктураДанные.Данные.Количество() = 0 Тогда
			
			Результат = Ложь;
			
			Если СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками = 0 Тогда
				СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
					ИдентификаторУстройства,
					Неопределено,
					СостояниеВыполнения.ОписаниеОшибок,
					НСтр("ru = 'Нет данных для выгрузки.'"));
			Иначе
				СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
					ИдентификаторУстройства,
					Неопределено,
					СостояниеВыполнения.ОписаниеОшибок,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Данные не выгружены. Обнаружено ошибок: %1'"),
						СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками));
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СостояниеВыполнения", СостояниеВыполнения);
		ДополнительныеПараметры.Вставить("СтруктураДанные", СтруктураДанные);
		МенеджерОборудованияКлиент.НачатьВыгрузкуДанныеВВесыСПечатьюЭтикеток(
			Новый ОписаниеОповещения("ВыгрузитьТоварыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			Новый УникальныйИдентификатор,
			СтруктураДанные.Данные,
			ИдентификаторУстройства,
			СтруктураДанные.ЧастичнаяВыгрузка,
			Ложь); // Отображать сообщения
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик оповещения при завершении операции выгрузки товаров.
//
// Параметры:
//  РезультатВыполнения - Булево - результат выполнения операции.
//  Параметры - Структура - Параметры обработчика оповещения
//
Процедура ВыгрузитьТоварыЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	СостояниеВыполнения = Параметры.СостояниеВыполнения;
	СтруктураДанные = Параметры.СтруктураДанные;
	
	РасширеннаяВыгрузка = ?(Параметры.СтруктураДанные.Свойство("РасширеннаяВыгрузка"), 
		Параметры.СтруктураДанные.РасширеннаяВыгрузка,
		Ложь);
	
	СостояниеВыполнения.Обработано = СостояниеВыполнения.Обработано + 1;
	
	Если Не РезультатВыполнения.Результат Тогда
		СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
			РезультатВыполнения.ИдентификаторУстройства,
			Неопределено,
			СостояниеВыполнения.ОписаниеОшибок,
			РезультатВыполнения.ОписаниеОшибки);
	Иначе
		СостояниеВыполнения.Выполнено = СостояниеВыполнения.Выполнено + 1;
		Если СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками > 0 Тогда
			СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
				РезультатВыполнения.ИдентификаторУстройства,
				Неопределено,
				СостояниеВыполнения.ОписаниеОшибок,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не выгружены данные о %1 товарах.'"),
					СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками));
		КонецЕсли;
	КонецЕсли;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ПриВыгрузкеТоваровВУстройство(
		РезультатВыполнения.ИдентификаторУстройства,
		СтруктураДанные,
		РезультатВыполнения.Результат,
		РасширеннаяВыгрузка);

	Если СостояниеВыполнения.Обработано = СостояниеВыполнения.ТребуетсяВыполнить Тогда
		
		Если СостояниеВыполнения.Выполнено = СостояниеВыполнения.ТребуетсяВыполнить И Не ЗначениеЗаполнено(СостояниеВыполнения.ОписаниеОшибок) Тогда
			ТекстСообщения = НСтр("ru = 'Товары успешно выгружены!'");
		ИначеЕсли СостояниеВыполнения.Выполнено > 0 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Товары выгружены для %1 устройств из %2.'"),
				СостояниеВыполнения.Выполнено,
				СостояниеВыполнения.ТребуетсяВыполнить) + СостояниеВыполнения.ОписаниеОшибок;
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выгрузить товары не удалось: %1'"),
				СостояниеВыполнения.ОписаниеОшибок);
		КонецЕсли;
		
		Если СостояниеВыполнения.ПоказыватьПредупреждение Тогда
			ПоказатьПредупреждение(,ТекстСообщения, 10);
		Иначе
			Если СостояниеВыполнения.ОписаниеОповещенияЗавершение <> Неопределено Тогда
				ВозвращаемоеЗначение = Новый Структура;
				ВозвращаемоеЗначение.Вставить("Выполнено", СостояниеВыполнения.Выполнено);
				ВозвращаемоеЗначение.Вставить("ТребуетсяВыполнить", СостояниеВыполнения.ТребуетсяВыполнить);
				ВозвращаемоеЗначение.Вставить("ТекстСообщения", ТекстСообщения);
				ВыполнитьОбработкуОповещения(СостояниеВыполнения.ОписаниеОповещенияЗавершение, ВозвращаемоеЗначение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выгружает полный список товаров в весы с печатью этикеток.
//
// Параметры:
//  ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения о завершении,
//                                                      вызывается после окончания выгрузки товаров в весы.
//  МассивУстройств - Массив - ссылки СправочникСсылка.ПодключаемоеОборудование на устройства в которые
//                             требуется выгрузить изменения.
//  ПоказыватьПредупреждение - Булево - Флаг, определяющий возможность показа предупреждения об окончании действия.
//
Процедура ВыгрузитьПолныйСписокТоваровВВесы(ОписаниеОповещенияЗавершение, МассивУстройств, ПоказыватьПредупреждение = Истина) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется выгрузка товаров в весы с печатью этикеток...'"));
	
	СостояниеВыполнения = Новый Структура;
	СостояниеВыполнения.Вставить("ОписаниеОшибок", "");
	СостояниеВыполнения.Вставить("Выполнено",      0);
	СостояниеВыполнения.Вставить("Обработано",     0);
	СостояниеВыполнения.Вставить("ТребуетсяВыполнить",           МассивУстройств.Количество());
	СостояниеВыполнения.Вставить("ПоказыватьПредупреждение",     ПоказыватьПредупреждение);
	СостояниеВыполнения.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	
	Для Каждого ИдентификаторУстройства Из МассивУстройств Цикл
		
		СтруктураДанные = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьДанныеДляВесов(ИдентификаторУстройства, Ложь);
		Если СтруктураДанные.Данные.Количество() = 0 Тогда
			
			Результат = Ложь;
			
			Если СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками = 0 Тогда
				СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
					ИдентификаторУстройства,
					Неопределено,
					СостояниеВыполнения.ОписаниеОшибок,
					НСтр("ru = 'Нет данных для выгрузки.'"));
			Иначе
				СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
					ИдентификаторУстройства,
					Неопределено,
					СостояниеВыполнения.ОписаниеОшибок,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Данные не выгружены. Обнаружено ошибок: %1'"),
						СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками));
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СостояниеВыполнения", СостояниеВыполнения);
		ДополнительныеПараметры.Вставить("СтруктураДанные", СтруктураДанные);
		МенеджерОборудованияКлиент.НачатьВыгрузкуДанныеВВесыСПечатьюЭтикеток(
			Новый ОписаниеОповещения("ВыгрузитьТоварыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			Новый УникальныйИдентификатор,
			СтруктураДанные.Данные,
			ИдентификаторУстройства,
			Ложь, // Частичная выгрузка
			Ложь); // Отображать сообщения
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура очищает список товаров в весах с печатью этикеток.
//
// Параметры:
//  ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения о завершении,
//                                                      вызывается после окончания очистки товаров в весах.
//  МассивУстройств - Массив - ссылки СправочникСсылка.ПодключаемоеОборудование на устройства в которых
//                             необходимо очистить список товаров.
//  ПоказыватьПредупреждение - Булево - Флаг, определяющий возможность показа предупреждения об окончании действия.
//
Процедура ОчиститьТоварыВВесах(ОписаниеОповещенияЗавершение, МассивУстройств, ПоказыватьПредупреждение = Истина) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется очистка товаров в весы с печатью этикеток...'"));
	
	СостояниеВыполнения = Новый Структура;
	СостояниеВыполнения.Вставить("ОписаниеОшибок", "");
	СостояниеВыполнения.Вставить("Выполнено",      0);
	СостояниеВыполнения.Вставить("Обработано",     0);
	СостояниеВыполнения.Вставить("ТребуетсяВыполнить",           МассивУстройств.Количество());
	СостояниеВыполнения.Вставить("ПоказыватьПредупреждение",     ПоказыватьПредупреждение);
	СостояниеВыполнения.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	
	Для Каждого ИдентификаторУстройства Из МассивУстройств Цикл
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СостояниеВыполнения", СостояниеВыполнения);
		МенеджерОборудованияКлиент.НачатьОчисткуТоваровВВесахСПечатьюЭтикеток(
			Новый ОписаниеОповещения("ОчиститьТоварыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			Новый УникальныйИдентификатор,
			ИдентификаторУстройства,
			Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик оповещения при завершении операции очистки товаров.
//
// Параметры:
//  РезультатВыполнения - Булево - результат выполнения операции.
//  Параметры - Структура - Параметры обработчика оповещения.
//
Процедура ОчиститьТоварыЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	СостояниеВыполнения = Параметры.СостояниеВыполнения;
	
	СостояниеВыполнения.Обработано = СостояниеВыполнения.Обработано + 1;
	
	Если Не РезультатВыполнения.Результат Тогда
		СостояниеВыполнения.ОписаниеОшибок = СформироватьОписаниеОшибкиДляУстройства(
			РезультатВыполнения.ИдентификаторУстройства,
			Неопределено,
			СостояниеВыполнения.ОписаниеОшибок,
			РезультатВыполнения.ОписаниеОшибки);
	Иначе
		СостояниеВыполнения.Выполнено = СостояниеВыполнения.Выполнено + 1;
	КонецЕсли;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ПриОчисткеТоваровВУстройстве(РезультатВыполнения.ИдентификаторУстройства, РезультатВыполнения.Результат);

	Если СостояниеВыполнения.Обработано = СостояниеВыполнения.ТребуетсяВыполнить Тогда
		
		Если СостояниеВыполнения.Выполнено = СостояниеВыполнения.ТребуетсяВыполнить И Не ЗначениеЗаполнено(СостояниеВыполнения.ОписаниеОшибок) Тогда
			ТекстСообщения = НСтр("ru = 'Товары успешно очищены!'");
		ИначеЕсли СостояниеВыполнения.Выполнено > 0 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Товары успешно очищены для %1 устройств из %2.'"),
				СостояниеВыполнения.Выполнено,
				СостояниеВыполнения.ТребуетсяВыполнить) + СостояниеВыполнения.ОписаниеОшибок;
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Очистить товары не удалось: %1'"),
				СостояниеВыполнения.ОписаниеОшибок);
		КонецЕсли;
		
		Если СостояниеВыполнения.ПоказыватьПредупреждение Тогда
			ПоказатьПредупреждение(,ТекстСообщения, 10);
		Иначе
			Если СостояниеВыполнения.ОписаниеОповещенияЗавершение <> Неопределено Тогда
				ВозвращаемоеЗначение = Новый Структура;
				ВозвращаемоеЗначение.Вставить("Выполнено", СостояниеВыполнения.Выполнено);
				ВозвращаемоеЗначение.Вставить("ТребуетсяВыполнить", СостояниеВыполнения.ТребуетсяВыполнить);
				ВозвращаемоеЗначение.Вставить("ТекстСообщения", ТекстСообщения);
				ВыполнитьОбработкуОповещения(СостояниеВыполнения.ОписаниеОповещенияЗавершение, ВозвращаемоеЗначение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьОписаниеОшибкиДляУстройства(ИдентификаторУстройства, ВыходныеПараметры, ОписаниеОшибок, ОписаниеОшибки)
	
	Если СтрНайти(ОписаниеОшибок, ОписаниеОшибки) Тогда
		Возврат ОписаниеОшибок;
	КонецЕсли;
	
	Возврат ОписаниеОшибок
	      + Символы.ПС
	      + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Описание ошибок для устройства %1: %2'"), ИдентификаторУстройства, ОписаниеОшибки)
	      + ?(ВыходныеПараметры <> Неопределено, Символы.ПС + ВыходныеПараметры[1], "");
	
КонецФункции

#КонецОбласти
