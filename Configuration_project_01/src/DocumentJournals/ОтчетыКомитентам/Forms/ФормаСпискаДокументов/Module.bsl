
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("ВариантПериода") Тогда
			Период.Вариант = СтруктураБыстрогоОтбора.ВариантПериода;
		Иначе
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Период") И ЗначениеЗаполнено(Параметры.Период) Тогда
		Период = Параметры.Период;
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") И ЗначениеЗаполнено(Параметры.ПериодРегистрации) Тогда
		// Форма открыта из формы операций закрытия месяца.
		Период.ДатаНачала 	 = НачалоМесяца(Параметры.ПериодРегистрации);
		Период.ДатаОкончания = КонецМесяца(Параметры.ПериодРегистрации);
	КонецЕсли;
	
	ТоварыКОформлению.Параметры.УстановитьЗначениеПараметра("ОтчетКомитентуОПродажах", НСтр("ru='Отчет комитенту о продажах'"));
	ТоварыКОформлению.Параметры.УстановитьЗначениеПараметра("ОтчетКомитентуОСписании", НСтр("ru='Отчет комитенту о списании'"));
	
	Элементы.ТоварыКОформлениюСоздатьОтчетКомитенту.Видимость =
		ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомитенту);
	
	Элементы.ТоварыКОформлениюОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ТоварыКОформлениюВалюта.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
		
	УстановитьПараметрыДинамическихСписков();
	
	УстановитьТекущуюСтраницу();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыПриСозданииНаСервере.КолонкаСостоянияЭДО = Элементы.ПредставлениеСостояния;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОтчетКомитенту" ИЛИ ИмяСобытия = "Запись_ОтчетКомитентуОСписании" Тогда
		Элементы.ТоварыКОформлению.Обновить();
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновленияВидимостиСостоянияЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Комитент", Комитент);
		
		Если СтруктураБыстрогоОтбора.Свойство("ВариантПериода") Тогда
			Период.Вариант = СтруктураБыстрогоОтбора.ВариантПериода;
		Иначе
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		КонецЕсли;
		
		Настройки.Удалить("Комитент");
		Настройки.Удалить("Период.Вариант");
	Иначе
		Комитент = Настройки.Получить("Комитент");
		Вариант = Настройки.Получить("Период.Вариант");
		Если Вариант <> Неопределено Тогда
			Период.Вариант = Вариант;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомитентПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаОкончания = Период.ДатаНачала;
	КонецЕсли;

	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаНачала = Период.ДатаОкончания;
	КонецЕсли;
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаОформление Тогда
		Элементы.ТоварыКОформлению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписков

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОтчетКомитенту(Команда)
	
	Строка = Элементы.ТоварыКОформлению.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("Партнер", Строка.Комитент);
		СтруктураОснование.Вставить("Организация", Строка.Организация);
		СтруктураОснование.Вставить("Контрагент", Строка.Контрагент);
		СтруктураОснование.Вставить("Соглашение", Строка.Соглашение);
		СтруктураОснование.Вставить("Договор", Строка.Договор);
		СтруктураОснование.Вставить("НалогообложениеНДС", Строка.НалогообложениеНДС);
		СтруктураОснование.Вставить("Валюта", Строка.Валюта);
		СтруктураОснование.Вставить("НачалоПериода", Период.ДатаНачала);
		СтруктураОснование.Вставить("КонецПериода", Период.ДатаОкончания);
		СтруктураОснование.Вставить("ЗаполнятьПоТоварамКОформлению", Истина);
		
		СтруктураПараметры = Новый Структура;
		СтруктураПараметры.Вставить("Основание", СтруктураОснование);
		Если Строка.СуммаВыручки <> 0 ИЛИ Строка.СуммаВозврата <> 0 ИЛИ Строка.КоличествоСписаноОстаток = 0 Тогда
			ОткрытьФорму("Документ.ОтчетКомитенту.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		Иначе
			ОткрытьФорму("Документ.ОтчетКомитентуОСписании.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		КонецЕсли;
	Иначе
		ОткрытьФорму("Документ.ОтчетКомитенту.ФормаОбъекта", , Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВидимостьСостоянияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(ЭтотОбъект, Элементы.ПредставлениеСостояния);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредставлениеСостояния Тогда
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбменСКонтрагентамиКлиент.ДекорацияСостояниеЭДОФормаСпискаНажатие(ВыбраннаяСтрока, СтандартнаяОбработка);
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	КонецЕсли;
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомитенту.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомитентуОСписании.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Неопределено, Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ДатаОстатков = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2399, 1, 1));
	Граница = Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая);
	
	ТоварыКОформлению.Параметры.УстановитьЗначениеПараметра("КонГраница", КонецДня(ДатаОстатков));
	ТоварыКОформлению.Параметры.УстановитьЗначениеПараметра("НачГраница", НачалоДня(Период.ДатаНачала));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Комитент, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Комитент));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТоварыКОформлению, "Комитент", Комитент, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Комитент));
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		// Форма открыта из формы операций закрытия месяца.
		ИмяТекущейСтраницы = Элементы.СтраницаРаспоряженияНаОформление.Имя;
	Иначе
		Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
		ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
