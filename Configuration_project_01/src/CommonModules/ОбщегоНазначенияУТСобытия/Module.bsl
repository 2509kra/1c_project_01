
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИсключенияПоискаСсылокПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ТипИсточника = ТипЗнч(Источник);
	
	Если ТипИсточника = Тип("ПланВидовХарактеристикОбъект.ДополнительныеРеквизитыИСведения") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Реквизиты.Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка КАК Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляНоменклатуры КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляХарактеристик КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляСерий КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыБыстрогоОтбораНоменклатуры КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыБыстрогоОтбораХарактеристик КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство) КАК Реквизиты";
		
		Запрос.УстановитьПараметр("УдаляемоеСвойство", Источник.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НачатьТранзакцию();
			
		Попытка
			
			Пока Выборка.Следующий() Цикл
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ВидыНоменклатуры");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
				
				Блокировка.Заблокировать();
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ОбъектССсылкой = Выборка.Ссылка.ПолучитьОбъект();
				
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляНоменклатуры,     Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляХарактеристик,    Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляСерий,            Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыБыстрогоОтбораНоменклатуры,  Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыБыстрогоОтбораХарактеристик, Источник.Ссылка, "Свойство");
				
				ОбъектССсылкой.Записать();
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОписаниеОшибки = ОписаниеОшибки();
			ВызватьИсключение ОписаниеОшибки;
			
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьВхожденияЭлементаИзТабличнойЧасти(ТабличнаяЧасть, Ссылка, Колонка)
	
	Отбор = Новый Структура(Колонка, Ссылка);
	
	Строки = ТабличнаяЧасть.НайтиСтроки(Отбор);
	Для Каждого ТекСтр Из Строки Цикл
		ТабличнаяЧасть.Удалить(ТекСтр);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьОтветственногоВСправочникахОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйВДокументах = ПолучитьФункциональнуюОпцию("ОтветственныйВДокументах");
	СтандартнаяСсылка 		 = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор("aa00559e-ad84-4494-88fd-f0826edc46f0"));
	ТекущийПользователь		 = ПользователиКлиентСервер.АвторизованныйПользователь();
	МетаданныеДокумента 	 = Источник.Метаданные();
	
	Если Не ОтветственныйВДокументах ИЛИ (СтандартнаяСсылка = ТекущийПользователь И ТекущийПользователь.Служебный) Тогда
		
		Если Не Источник.ЭтоГруппа Тогда 
			Если МетаданныеДокумента.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
				Источник.Ответственный = Неопределено;
			КонецЕсли;
			
			Если МетаданныеДокумента.Реквизиты.Найти("Менеджер") <> Неопределено Тогда
				Источник.Менеджер = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьОтветственногоВДокументахОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйВДокументах = ПолучитьФункциональнуюОпцию("ОтветственныйВДокументах");
	СтандартнаяСсылка 		 = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор("aa00559e-ad84-4494-88fd-f0826edc46f0"));
	ТекущийПользователь		 = ПользователиКлиентСервер.АвторизованныйПользователь();
	МетаданныеДокумента 	 = Источник.Метаданные();
	
	Если Не ОтветственныйВДокументах ИЛИ (СтандартнаяСсылка = ТекущийПользователь И ТекущийПользователь.Служебный) Тогда
		
		Если МетаданныеДокумента.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
			Источник.Ответственный = Неопределено;
		КонецЕсли;
			
		Если МетаданныеДокумента.Реквизиты.Найти("Менеджер") <> Неопределено Тогда
			Источник.Менеджер = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

// Обработчик подписки на событие ЗарегистрироватьДанныеПервичныхДокументов
Процедура ПриЗаписиДокументаРегистрацияДанныхПервичныхДокументов(Источник, Отказ) Экспорт
	Перем НомерДокумента, ДатаДокумента;
	 
	Если Источник.ОбменДанными.Загрузка = Истина
		И Источник.ДополнительныеСвойства.Свойство("РегистрироватьДанныеПервичныхДокументов")
		И Источник.ДополнительныеСвойства.РегистрироватьДанныеПервичныхДокументов = Ложь Тогда
		// Регистр ДанныеПервичныхДокументов по сути содержит в себе данные документа.
		// При обменах формирование регистра также необходимо выполнить. Без этого данные не будут корректными.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Источник.Ссылка;
	МетаданныеДокумента = Источник.Метаданные();
	
	ИменаРеквизитов = "Номер, Дата";
	
	ЭтоДокументИнтеркампани     = ОбщегоНазначения.ЕстьРеквизитОбъекта("РасчетыЧерезОтдельногоКонтрагента", МетаданныеДокумента);
	ЕстьНомерВходящегоДокумента = ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерВходящегоДокумента", МетаданныеДокумента);
	ЕстьПредставлениеНомера     = ОбщегоНазначения.ЕстьРеквизитОбъекта("ПредставлениеНомера", МетаданныеДокумента);
	ЕстьДатаВходящегоДокумента  = ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаВходящегоДокумента", МетаданныеДокумента); 
	
	Если ?(ЭтоДокументИнтеркампани, Источник["РасчетыЧерезОтдельногоКонтрагента"], Истина) 
		 И ЕстьНомерВходящегоДокумента Тогда
		 
		ИменаРеквизитов = ИменаРеквизитов + ", НомерВходящегоДокумента";
		Если ЕстьДатаВходящегоДокумента Тогда
			ИменаРеквизитов = ИменаРеквизитов + ", ДатаВходящегоДокумента";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьПредставлениеНомера Тогда
		ИменаРеквизитов = ИменаРеквизитов + ", ПредставлениеНомера";
	КонецЕсли;
	
	Реквизиты = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(Реквизиты, Источник);
	
	// Установка управляемой блокировки.
	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ДанныеПервичныхДокументов");
	ЭлементБлокировки.УстановитьЗначение("Документ", Ссылка);
	БлокировкаДанных.Заблокировать();
	
	НомерДокумента	= "";
	ДатаДокумента	= '00010101';
	
	Если Реквизиты.Свойство("НомерВходящегоДокумента") Тогда
		НомерДокумента	= СокрЛП(Реквизиты.НомерВходящегоДокумента);
		Если Реквизиты.Свойство("ДатаВходящегоДокумента") Тогда
			ДатаДокумента = Реквизиты.ДатаВходящегоДокумента;
		КонецЕсли;
	ИначеЕсли Реквизиты.Свойство("ПредставлениеНомера") Тогда
		НомерДокумента	= СокрЛП(Реквизиты.ПредставлениеНомера);
		ДатаДокумента	= Реквизиты.Дата;
	Иначе
		НомерДокумента	= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер, Ложь, Истина);
		ДатаДокумента	= Реквизиты.Дата;
	КонецЕсли;
	
	ОрганизацииКРегистрации = Новый Соответствие;
	
	// Дополним МассивОрганизаций организациями из шапки документа
	МассивРеквизитовОрганизация = ИменаРеквизитовОрганизаций(МетаданныеДокумента);
	Для каждого РеквизитОрганизация Из МассивРеквизитовОрганизация Цикл
		ДобавитьОрганизацию(ОрганизацииКРегистрации, Источник, РеквизитОрганизация);
	КонецЦикла;
	
	// Дополним МассивОрганизаций организациями из табличных частей
	Для каждого ТабличнаяЧасть Из МетаданныеДокумента.ТабличныеЧасти Цикл
		
		МассивРеквизитовОрганизация = ИменаРеквизитовОрганизаций(ТабличнаяЧасть);
		Если МассивРеквизитовОрганизация.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого Строка Из Источник[ТабличнаяЧасть.Имя] Цикл
			Для каждого РеквизитОрганизация Из МассивРеквизитовОрганизация Цикл
				ДобавитьОрганизацию(ОрганизацииКРегистрации, Строка, РеквизитОрганизация);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	НаборЗаписейРегистра = РегистрыСведений.ДанныеПервичныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписейРегистра.Отбор.Документ.Установить(Ссылка);
	
	Для каждого КлючИЗначение Из ОрганизацииКРегистрации Цикл
		
		Организация = КлючИЗначение.Ключ;
		ИмяРеквизита = КлючИЗначение.Значение;
		
		НоваяЗапись = НаборЗаписейРегистра.Добавить();
		НоваяЗапись.Организация = Организация;
		НоваяЗапись.Документ    = Ссылка;
		
		Если ЭтоДокументИнтеркампани И ИмяРеквизита = "Организация" Тогда
			НоваяЗапись.Номер    = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер, Истина, Истина);
			НоваяЗапись.Дата     = Реквизиты.Дата;
		Иначе
			НоваяЗапись.Номер    = НомерДокумента;
			НоваяЗапись.Дата     = ДатаДокумента;
		КонецЕсли;
		
		НоваяЗапись.НомерРегистратора = Реквизиты.Номер;
		НоваяЗапись.ДатаРегистратора = Реквизиты.Дата;
		
	КонецЦикла;
	
	НаборЗаписейРегистра.Записать(Истина);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИменаРеквизитовОрганизаций(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	ТипОрганизация = Тип("СправочникСсылка.Организации");
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Если Реквизит.Тип.СодержитТип(ТипОрганизация) Тогда
			Результат.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьОрганизацию(ОрганизацииКРегистрации, Данные, ИмяРеквизита)
	
	ЗначениеРеквизита = Данные[ИмяРеквизита];
	
	Если ЗначениеЗаполнено(ЗначениеРеквизита) 
		И ТипЗнч(ЗначениеРеквизита) = Тип("СправочникСсылка.Организации") Тогда
		
		ОрганизацииКРегистрации.Вставить(ЗначениеРеквизита, ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти