#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСКлиентом" Тогда
			
			СформироватьПараметрыСостояниеРасчетовСКлиентом(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСКлиентомПоДокументам" Тогда
			
			ПараметрКоманды = Параметры.ПараметрКоманды;
			
			СтруктураНастроек = НастройкиОтчета(ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;
			
			СтрокаБазовая = ?(ЗначенияФункциональныхОпций.БазоваяВерсия, "Базовая", "");
			РасширенныйЗаказ = ЗначенияФункциональныхОпций.ИспользоватьРасширенныеВозможностиЗаказаКлиента;
			
			КлючВарианта = "ЗадолженностьКлиентовПоОбъектуРасчетовКонтекст" + СтрокаБазовая;
			
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
			
			СформироватьПараметрыОтчета(ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
			Параметры.КлючВарианта = КлючВарианта;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
КонецПроцедуры

Функция НастройкиОтчета(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура;
	ЗначенияФункциональныхОпций.Вставить("ИспользоватьРасширенныеВозможностиЗаказаКлиента", 
	                                     ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	ЗначенияФункциональныхОпций.Вставить("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	Типы.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом"));
	Типы.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	СтруктураНастроек.Вставить("СтруктураОтборов",
	                           ВзаиморасчетыСервер.СтруктураОтборовОтчетовРасчетыСКлиентами(ПараметрКоманды,
	                                                                                        "ЗадолженностьКлиентов",
	                                                                                         "СостояниеРасчетовСКлиентомПоДокументам", 
	                                                                                         Типы));
	
	Возврат СтруктураНастроек;
	
КонецФункции

Процедура СформироватьПараметрыОтчета(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
		Если ЭтоМассив Тогда
			ЕстьПодчиненныеПартнеры = Ложь;
			Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
				Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
					ЕстьПодчиненныеПартнеры = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
		КонецЕсли;
		
		Если ЕстьПодчиненныеПартнеры Тогда
			ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
			ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
			ЗначениеОтбора = ПараметрКоманды;
			Если ЭтоМассив Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(ПараметрКоманды);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
			ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
			Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
			ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
			Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		Иначе
			ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
			ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		ИЛИ ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		ПараметрыФормы.Отбор = Новый Структура("Договор", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
	Иначе
		ОбъектРасчетов = ВзаиморасчетыСервер.ОбъектРасчетовПоСсылке(ПервыйЭлемент);
		ПараметрыФормы.Отбор = Новый Структура("ОбъектРасчетов", ОбъектРасчетов);
		ПараметрыФормы.КлючНазначенияИспользования = ОбъектРасчетов;
		Параметры.КлючНазначенияИспользования = ОбъектРасчетов;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПараметрыСостояниеРасчетовСКлиентом(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ЭтоМассив Тогда
		ЕстьПодчиненныеПартнеры = Ложь;
		Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
			Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
				ЕстьПодчиненныеПартнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
	КонецЕсли;
	
	СтрокаБазовая = ?(ПолучитьФункциональнуюОпцию("БазоваяВерсия"), "Базовая", "");
	
	Если ЕстьПодчиненныеПартнеры Тогда
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		ЗначениеОтбора = ПараметрКоманды;
			Если ЭтоМассив Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(ПараметрКоманды);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
		Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		
		Параметры.КлючВарианта = "ЗадолженностьКлиентовКонтекст" + СтрокаБазовая;
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			Параметры.КлючВарианта = "ЗадолженностьКлиентаКонтекст" + СтрокаБазовая;
		Иначе
			Параметры.КлючВарианта = "ЗадолженностьКлиентовКонтекст" + СтрокаБазовая;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = ТекстЗапроса();
	
	ВзаиморасчетыСервер.ДобавитьОтборыВыбранныхПолейВЗапрос(ТекстЗапроса, НастройкиОтчета, СхемаКомпоновкиДанных.ВычисляемыеПоля, "Расчеты");
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрДатаОстатков.Использование = Истина;
	
	ПараметрДатаОтчетаГраница = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчетаГраница");
	ПараметрДатаОтчетаГраница.Использование = Истина;
	
	Если ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение.Дата) Тогда
			ПараметрДатаОстатков.Значение.Дата = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение.Дата), ВидГраницы.Включая);
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение) Тогда
			ПараметрДатаОстатков.Значение = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение), ВидГраницы.Включая);
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

Функция ТекстЗапроса()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Расчеты.Организация                       КАК Организация,
	|	Расчеты.Партнер                           КАК Партнер,
	|	Расчеты.Контрагент                        КАК Контрагент,
	|	Расчеты.Договор                           КАК Договор,
	|	Расчеты.НаправлениеДеятельности           КАК НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов                    КАК ОбъектРасчетов,
	|	Расчеты.Валюта                            КАК Валюта,
	|	Расчеты.РасчетныйДокумент                 КАК РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения            КАК ДатаПлановогоПогашения,
	|	Расчеты.ДатаВозникновения                 КАК ДатаВозникновения,
	|	СУММА(Расчеты.НашДолг)                    КАК НашДолг,
	|	СУММА(Расчеты.ДолгКлиента)                КАК ДолгКлиента,
	|	СУММА(Расчеты.ДолгКлиентаПросрочено)      КАК ДолгКлиентаПросрочено,
	|	
	|	СУММА(Расчеты.ПлановаяОплатаАванс)        КАК ПлановаяОплатаАванс,
	|	СУММА(Расчеты.ПлановаяОплатаПредоплата)   КАК ПлановаяОплатаПредоплата,
	|	СУММА(Расчеты.ПлановаяОплатаКредит)       КАК ПлановаяОплатаКредит,
	|	СУММА(Расчеты.ПлановаяОплатаПросрочено)   КАК ПлановаяОплатаПросрочено,
	|	СУММА(Расчеты.Оплачивается)               КАК Оплачивается,
	|	
	|	СУММА(Расчеты.ПлановаяОтгрузка)           КАК ПлановаяОтгрузка,
	|	СУММА(Расчеты.ПлановаяОтгрузкаПросрочено) КАК ПлановаяОтгрузкаПросрочено,
	|	СУММА(Расчеты.Отгружается)                КАК Отгружается
	|ПОМЕСТИТЬ ВтРасчеты
	|ИЗ (
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                     КАК Организация,
	|		АналитикаУчета.Партнер                                         КАК Партнер,
	|		АналитикаУчета.Контрагент                                      КАК Контрагент,
	|		АналитикаУчета.Договор                                         КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|		РасчетыПоСрокам.ОбъектРасчетов                                 КАК ОбъектРасчетов,
	|		РасчетыПоСрокам.Валюта                                         КАК Валюта,
	|		РасчетыПоСрокам.РасчетныйДокумент                              КАК РасчетныйДокумент,
	|		РасчетыПоСрокам.ДатаПлановогоПогашения                         КАК ДатаПлановогоПогашения,
	|		РасчетыПоСрокам.ДатаВозникновения                              КАК ДатаВозникновения,
	|		РасчетыПоСрокам.ПредоплатаОстаток                              КАК НашДолг,
	|		РасчетыПоСрокам.ДолгОстаток                                    КАК ДолгКлиента,
	|		ВЫБОР 
	|			КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета,ДЕНЬ)
	|				ТОГДА РасчетыПоСрокам.ДолгОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ДолгКлиентаПросрочено,
	|		
	|		0                                                              КАК ПлановаяОплатаАванс,
	|		0                                                              КАК ПлановаяОплатаПредоплата,
	|		0                                                              КАК ПлановаяОплатаКредит,
	|		0                                                              КАК ПлановаяОплатаПросрочено,
	|		0                                                              КАК Оплачивается,
	|		
	|		0                                                              КАК ПлановаяОтгрузка,
	|		0                                                              КАК ПлановаяОтгрузкаПросрочено,
	|		0                                                              КАК Отгружается
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки(&ДатаОтчетаГраница) КАК РасчетыПоСрокам
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПоСрокам.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                    КАК Организация,
	|		АналитикаУчета.Партнер                                        КАК Партнер,
	|		АналитикаУчета.Контрагент                                     КАК Контрагент,
	|		АналитикаУчета.Договор                                        КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                        КАК НаправлениеДеятельности,
	|		РасчетыПланОплат.ОбъектРасчетов                               КАК ОбъектРасчетов,
	|		РасчетыПланОплат.Валюта                                       КАК Валюта,
	|		РасчетыПланОплат.ДокументПлан                                 КАК ДокументПлан,
	|		РасчетыПланОплат.ДатаПлановогоПогашения                       КАК ДатаПлановогоПогашения,
	|		РасчетыПланОплат.ДатаВозникновения                            КАК ДатаВозникновения,
	|		0                                                             КАК НашДолг,
	|		0                                                             КАК ДолгКлиента,
	|		0                                                             КАК ДолгКлиентаПросрочено,
	|		
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.АвансДоОбеспечения)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                         КАК ПлановаяОплатаАванс,
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                         КАК ПлановаяОплатаПредоплата,
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки)
	|				ИЛИ РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ПлановаяОплатаКредит,
	|		ВЫБОР 
	|			КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета,ДЕНЬ)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ПлановаяОплатаПросрочено,
	|		0                                                              КАК Оплачивается,
	|		
	|		0                                                              КАК ПлановаяОтгрузка,
	|		0                                                              КАК ПлановаяОтгрузкаПросрочено,
	|		0                                                              КАК Отгружается
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПланОплат.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланОплат
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОплат.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                  КАК Организация,
	|		АналитикаУчета.Партнер                      КАК Партнер,
	|		АналитикаУчета.Контрагент                   КАК Контрагент,
	|		АналитикаУчета.Договор                      КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|		РасчетыПланОтгрузок.ОбъектРасчетов          КАК ОбъектРасчетов,
	|		РасчетыПланОтгрузок.Валюта                  КАК Валюта,
	|		РасчетыПланОтгрузок.ДокументПлан            КАК ДокументПлан,
	|		РасчетыПланОтгрузок.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|		РасчетыПланОтгрузок.ДатаВозникновения       КАК ДатаВозникновения,
	|		0                                           КАК НашДолг,
	|		0                                           КАК ДолгКлиента,
	|		0                                           КАК ДолгКлиентаПросрочено,
	|		
	|		0                                           КАК ПлановаяОплатаАванс,
	|		0                                           КАК ПлановаяОплатаПредоплата,
	|		0                                           КАК ПлановаяОплатаКредит,
	|		0                                           КАК ПлановаяОплатаПросрочено,
	|		0                                           КАК Оплачивается,
	|		
	|		РасчетыПланОтгрузок.СуммаОстаток            КАК ПлановаяОтгрузка,
	|		ВЫБОР 
	|			КОГДА РасчетыПланОтгрузок.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета,ДЕНЬ)
	|				ТОГДА РасчетыПланОтгрузок.СуммаОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                       КАК ПлановаяОтгрузкаПросрочено,
	|		0                                           КАК Отгружается
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПланОтгрузок.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланОтгрузок
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОтгрузок.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация             КАК Организация,
	|		АналитикаУчета.Партнер                 КАК Партнер,
	|		АналитикаУчета.Контрагент              КАК Контрагент,
	|		АналитикаУчета.Договор                 КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		РасчетыСКлиентами.ЗаказКлиента         КАК ОбъектРасчетов,
	|		РасчетыСКлиентами.Валюта               КАК Валюта,
	|		Неопределено                           КАК ДокументПлан,
	|		ДАТАВРЕМЯ(1,1,1)                       КАК ДатаПлановогоПогашения,
	|		ДАТАВРЕМЯ(1,1,1)                       КАК ДатаВозникновения,
	|		0                                      КАК НашДолг,
	|		0                                      КАК ДолгКлиента,
	|		0                                      КАК ДолгКлиентаПросрочено,
	|		
	|		0                                      КАК ПлановаяОплатаАванс,
	|		0                                      КАК ПлановаяОплатаПредоплата,
	|		0                                      КАК ПлановаяОплатаКредит,
	|		0                                      КАК ПлановаяОплатаПросрочено,
	|		РасчетыСКлиентами.ОплачиваетсяОстаток  КАК Оплачивается,
	|		
	|		0                                      КАК ПлановаяОтгрузка,
	|		0                                      КАК ПлановаяОтгрузкаПросрочено,
	|		РасчетыСКлиентами.ОтгружаетсяОстаток   КАК Отгружается
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами.Остатки(&ДатаОтчетаГраница) КАК РасчетыСКлиентами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыСКлиентами.АналитикаУчетаПоПартнерам
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}) КАК Расчеты
	|СГРУППИРОВАТЬ ПО
	|	Расчеты.Организация,
	|	Расчеты.Партнер,
	|	Расчеты.Контрагент,
	|	Расчеты.Договор,
	|	Расчеты.НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения,
	|	Расчеты.ДатаВозникновения
	|ИМЕЮЩИЕ
	|	(&ОтборыВыбранныхПолей)
	|;
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Расчеты.Организация                КАК Организация,
	|	Расчеты.Партнер                    КАК Партнер,
	|	Расчеты.Контрагент                 КАК Контрагент,
	|	Расчеты.Договор                    КАК Договор,
	|	Расчеты.НаправлениеДеятельности    КАК НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов             КАК ОбъектРасчетов,
	|	Расчеты.Валюта                     КАК Валюта,
	|	Расчеты.РасчетныйДокумент          КАК РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения     КАК ДатаПлановогоПогашения,
	|	Расчеты.ДатаВозникновения          КАК ДатаВозникновения,
	|	Расчеты.НашДолг                    КАК НашДолг,
	|	Расчеты.ДолгКлиента                КАК ДолгКлиента,
	|	Расчеты.ДолгКлиентаПросрочено      КАК ДолгКлиентаПросрочено,
	|	
	|	Расчеты.ПлановаяОплатаАванс        КАК ПлановаяОплатаАванс,
	|	Расчеты.ПлановаяОплатаПредоплата   КАК ПлановаяОплатаПредоплата,
	|	Расчеты.ПлановаяОплатаКредит       КАК ПлановаяОплатаКредит,
	|	Расчеты.ПлановаяОплатаПросрочено   КАК ПлановаяОплатаПросрочено,
	|	Расчеты.Оплачивается               КАК Оплачивается,
	|	
	|	Расчеты.ПлановаяОтгрузка           КАК ПлановаяОтгрузка,
	|	Расчеты.ПлановаяОтгрузкаПросрочено КАК ПлановаяОтгрузкаПросрочено,
	|	Расчеты.Отгружается                КАК Отгружается,
	|
	|	ЕСТЬNULL(Договоры.ЗапрещаетсяПросроченнаяЗадолженность, ЛОЖЬ) КАК ЗапрещаетсяПросроченнаяЗадолженность,
	|	ЕСТЬNULL(Договоры.ОграничиватьСуммуЗадолженности, ЛОЖЬ)       КАК ОграничиватьСуммуЗадолженности,
	|	ЕСТЬNULL(Договоры.ДопустимаяСуммаЗадолженности, 0)            КАК ДопустимаяСуммаЗадолженности
	|
	|ИЗ ВтРасчеты КАК Расчеты
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
	|		ПО Договоры.Ссылка = Расчеты.Договор
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НаДату","&ДатаОтчета");
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецЕсли