#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Обработчик обновления БЭД 1.1.3.7.
// Изменился тип реквизита СтатусЭД в РС ЖурналСобытийЭД со строки на ПеречислениеСсылка.
Процедура ОбновитьСтатусыЭД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД,
	|	ЖурналСобытийЭД.ПрисоединенныйФайл,
	|	ЖурналСобытийЭД.НомерЗаписи
	|ИЗ
	|	РегистрСведений.ЖурналСобытийЭД КАК ЖурналСобытийЭД
	|ГДЕ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД <> """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.УдалитьСтатусЭД = НСтр("ru = 'Доставлен получателю'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Доставлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = '<Не получен>'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеПолучен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = '<Не сформирован>'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеСформирован;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = 'Отправлен получателю'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = 'Отправлено уведомление об уточнении'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ОтправленоУведомление;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = 'Отправлен оператору ЭДО'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПереданОператору;
		ИначеЕсли Выборка.УдалитьСтатусЭД = НСтр("ru = 'Получено уведомление об уточнении'") Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПолученоУведомление;
		Иначе
			УдалитьСтатусЭД = СтрЗаменить(Выборка.УдалитьСтатусЭД, " ", "");
			УдалитьСтатусЭД = Перечисления.СтатусыЭД[УдалитьСтатусЭД];
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ЖурналСобытийЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(Выборка.ПрисоединенныйФайл);
		НаборЗаписей.Отбор.НомерЗаписи.Установить(Выборка.НомерЗаписи);
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.СтатусЭД = УдалитьСтатусЭД;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.3.6.35.
// Ресурс заполняется значением реквизита ВладелецЭД для присоединенного файла.
Процедура ЗаполнитьРесурсВладелецЭД(Параметры) Экспорт
	
	Если Не Параметры.Свойство("ОбработаноЗаписей") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЖурналСобытийЭД.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|	ЖурналСобытийЭД.НомерЗаписи КАК НомерЗаписи,
		|	СУММА(1) КАК ВсегоЗаписей
		|ИЗ
		|	РегистрСведений.ЖурналСобытийЭД КАК ЖурналСобытийЭД
		|ГДЕ
		|	НЕ ЖурналСобытийЭД.ВладелецЭД ССЫЛКА Документ.ЭлектронныйДокументВходящий
		|	И НЕ ЖурналСобытийЭД.ВладелецЭД ССЫЛКА Документ.ЭлектронныйДокументИсходящий
		|	И (ЖурналСобытийЭД.ПрисоединенныйФайл.ВладелецФайла ССЫЛКА Документ.ЭлектронныйДокументВходящий
		|			ИЛИ ЖурналСобытийЭД.ПрисоединенныйФайл.ВладелецФайла ССЫЛКА Документ.ЭлектронныйДокументИсходящий)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЖурналСобытийЭД.ПрисоединенныйФайл,
		|	ЖурналСобытийЭД.НомерЗаписи";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Параметры.Вставить("ВсегоЗаписей", Выборка.ВсегоЗаписей);
		Иначе
			Параметры.Вставить("ВсегоЗаписей", 0);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ЖурналСобытийЭД.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
	|	ЖурналСобытийЭД.НомерЗаписи КАК НомерЗаписи,
	|	ЖурналСобытийЭД.ПрисоединенныйФайл.ВладелецФайла КАК ВладелецФайла
	|ИЗ
	|	РегистрСведений.ЖурналСобытийЭД КАК ЖурналСобытийЭД
	|ГДЕ
	|	НЕ ЖурналСобытийЭД.ВладелецЭД ССЫЛКА Документ.ЭлектронныйДокументВходящий
	|	И НЕ ЖурналСобытийЭД.ВладелецЭД ССЫЛКА Документ.ЭлектронныйДокументИсходящий
	|	И (ЖурналСобытийЭД.ПрисоединенныйФайл.ВладелецФайла ССЫЛКА Документ.ЭлектронныйДокументВходящий
	|			ИЛИ ЖурналСобытийЭД.ПрисоединенныйФайл.ВладелецФайла ССЫЛКА Документ.ЭлектронныйДокументИсходящий)";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Если Параметры.Свойство("ОбработаноЗаписей") Тогда
			Параметры.ОбработаноЗаписей = Параметры.ОбработаноЗаписей + Выборка.Количество();
		Иначе
			Параметры.Вставить("ОбработаноЗаписей", Выборка.Количество());
		КонецЕсли;
		
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.ЖурналСобытийЭД.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(Выборка.ПрисоединенныйФайл);
			НаборЗаписей.Отбор.НомерЗаписи.Установить(Выборка.НомерЗаписи);
			НаборЗаписей.Прочитать();
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.ВладелецЭД = Выборка.ВладелецФайла;
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
		КонецЦикла;
		
		Параметры.ОбработкаЗавершена = Ложь;
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Параметры.ВсегоЗаписей;
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ОбработаноЗаписей;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли