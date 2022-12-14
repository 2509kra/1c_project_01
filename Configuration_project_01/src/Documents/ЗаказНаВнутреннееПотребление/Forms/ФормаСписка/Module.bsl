
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеЗаказов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСсылки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), НСтр("ru = 'К выполнению'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОбеспечениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), НСтр("ru = 'К обеспечению'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	
	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаВнутреннееПотребление.Ссылка,
		|	ДокументЗаказНаВнутреннееПотребление.ПометкаУдаления,
		|	ДокументЗаказНаВнутреннееПотребление.Номер,
		|	ДокументЗаказНаВнутреннееПотребление.Дата,
		|	ДокументЗаказНаВнутреннееПотребление.Проведен,
		|	ДокументЗаказНаВнутреннееПотребление.ЖелаемаяДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.Комментарий,
		|	ДокументЗаказНаВнутреннееПотребление.Организация,
		|	ДокументЗаказНаВнутреннееПотребление.Ответственный,
		|	ДокументЗаказНаВнутреннееПотребление.Подразделение,
		|	ДокументЗаказНаВнутреннееПотребление.Склад,
		|	ДокументЗаказНаВнутреннееПотребление.Статус,
		|	ДокументЗаказНаВнутреннееПотребление.МаксимальныйКодСтроки,
		|	ДокументЗаказНаВнутреннееПотребление.Сделка,
		|	ДокументЗаказНаВнутреннееПотребление.ХозяйственнаяОперация,
		|	ДокументЗаказНаВнутреннееПотребление.ДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.НеОтгружатьЧастями,
		|	ДокументЗаказНаВнутреннееПотребление.Назначение,
		|	ДокументЗаказНаВнутреннееПотребление.ДокументОснование,
		|	ДокументЗаказНаВнутреннееПотребление.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаВнутреннееПотребление.МоментВремени,
		|	ДокументЗаказНаВнутреннееПотребление.Товары,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаВнутреннееПотребление.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументЗаказНаВнутреннееПотребление
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаВнутреннееПотребление.Ссылка)";
		
	Иначе
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаВнутреннееПотребление.Ссылка,
		|	ДокументЗаказНаВнутреннееПотребление.ПометкаУдаления,
		|	ДокументЗаказНаВнутреннееПотребление.Номер,
		|	ДокументЗаказНаВнутреннееПотребление.Дата,
		|	ДокументЗаказНаВнутреннееПотребление.Проведен,
		|	ДокументЗаказНаВнутреннееПотребление.ЖелаемаяДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.Комментарий,
		|	ДокументЗаказНаВнутреннееПотребление.Организация,
		|	ДокументЗаказНаВнутреннееПотребление.Ответственный,
		|	ДокументЗаказНаВнутреннееПотребление.Подразделение,
		|	ДокументЗаказНаВнутреннееПотребление.Склад,
		|	ДокументЗаказНаВнутреннееПотребление.Статус,
		|	ДокументЗаказНаВнутреннееПотребление.МаксимальныйКодСтроки,
		|	ДокументЗаказНаВнутреннееПотребление.Сделка,
		|	ДокументЗаказНаВнутреннееПотребление.ХозяйственнаяОперация,
		|	ДокументЗаказНаВнутреннееПотребление.ДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.НеОтгружатьЧастями,
		|	ДокументЗаказНаВнутреннееПотребление.Назначение,
		|	ДокументЗаказНаВнутреннееПотребление.ДокументОснование,
		|	ДокументЗаказНаВнутреннееПотребление.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаВнутреннееПотребление.МоментВремени,
		|	ДокументЗаказНаВнутреннееПотребление.Товары
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументЗаказНаВнутреннееПотребление";
		
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ИспользоватьСтатусы = ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаВнутреннееПотребление);
	Элементы.ГруппаУстановитьСтатус.Видимость = ИспользоватьСтатусы;
	
	Если ИспользоватьСтатусы Тогда
		ИспользоватьСтатусЗакрыт = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузки");
		Элементы.УстановитьСтатусЗакрыт.Видимость = ИспользоватьСтатусЗакрыт;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		Элементы.ГруппаОтгрузка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаВнутреннееПотребление.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
