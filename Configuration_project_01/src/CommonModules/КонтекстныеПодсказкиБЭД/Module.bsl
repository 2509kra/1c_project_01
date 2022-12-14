////////////////////////////////////////////////////////////////////////////////
// КонтекстныеПодсказкиБЭД: механизм контекстных подсказок.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение категории по ее коду.
//
// Параметры:
//  КодКатегории - Строка - код категории.
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция КатегорияПоКоду(КодКатегории) Экспорт
	
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду(КодКатегории);
	
КонецФункции

// Возвращает значение признака доступности механизма контекстных подсказок.
//
// Возвращаемое значение:
//  Булево - значение признака доступности механизма контекстных подсказок.
//
Функция ФункционалКонтекстныхПодсказокДоступен() Экспорт
	
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.ФункционалКонтекстныхПодсказокДоступен();

КонецФункции

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФорм

// Обработчик события "ПриСозданииНаСервере" формы документа.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма.
//   МестоРазмещенияПанели - ЭлементФормы - элемент формы "группа", в котором будут отображаться элементы 
//                            панели контекстных подсказок, необязательный параметр. 
//                            Если параметр не заполнен, элементы должны быть добавлены вручную. 
//                            Список необходимых элементов см. в  КонтекстныеПодсказкиБЭД.СформироватьПанельКонтекстныхНовостей()
//   МестоРазмещенияКоманд - ЭлементФормы, Массив из ЭлементФормы - элемент формы "группа", в котором должны отображаться 
//                            команды управления контекстными подсказками, необязательный параметр.
//   СоздаватьРеквизитыКешаАвтоматически - Булево - признак автоматического формирования элементов кеша, необязательный параметр.
//                                         Если значение = Ложь, на форме должны быть созданы реквизиты "Новости" и
//                                         "КешКонтекстныхПодсказок" с типом "Произвольный"
//
Процедура КонтекстныеПодсказки_ПриСозданииНаСервере(Форма, МестоРазмещенияПанели = Неопределено, 
													 МестаРазмещенияКоманд = Неопределено, 
													 СоздаватьРеквизитыКешаАвтоматически = Истина) Экспорт
	
	Если Не КонтекстныеПодсказкиБЭДПовтИсп.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Форма.Элементы.ПанельКонтекстныхНовостей.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Не МеханизмПодсказокПоддерживается(Форма.ИмяФормы) Тогда
		ВызватьИсключение НСтр("ru='Имя формы не добавлено в метод КонтекстныеПодсказкиБЭД.ФормыСПоддержкойКонтекстныхПодсказок'");
	КонецЕсли;
	
	КлючеваяОперация = "КонтекстныеПодсказкиБЭД.ИнициализацияФормы"; 
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(КлючеваяОперация);
		
	Если СоздаватьРеквизитыКешаАвтоматически Тогда
		СформироватьКешДанныхКонтекстныхПодсказок(Форма);
	КонецЕсли; 
	
	ИнициализироватьКешДанныхКонтекстныхПодсказок(Форма);
	
	Если МестоРазмещенияПанели <> Неопределено Тогда
		СформироватьПанельКонтекстныхНовостей(Форма, МестоРазмещенияПанели);
	КонецЕсли;
	
	ИнициализироватьМеханизмУправленияНовостями(Форма);
	
	КоличествоНовостей = Форма.Новости.Новости.Количество();
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоНовостей);
	
	ИзменитьПорядокНовостей(Форма.Новости.Новости, "Прочтена Возр, ДатаПубликации Убыв");
	
	ДобавитьПодключаемыеКоманды(Форма, МестаРазмещенияКоманд);
	
КонецПроцедуры

#КонецОбласти

// Выбирает статьи соответствующие контексту формы и отображает их на панели
// контекстных новостей.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура ОтобразитьАктуальныеДляКонтекстаНовости(Форма) Экспорт
	
	Если Не КонтекстныеПодсказкиБЭДПовтИсп.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = "КонтекстныеПодсказкиБЭД.ПолучениеАктуальныхКонтекстныхНовостей";
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(КлючеваяОперация); 	
	
	АктуальныеКонтекстныеНовости = АктуальныеДляКонтекстаСтатьи(Форма);
	
	КоличествоНовостей = Форма.Новости.Новости.Количество();
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоНовостей);
	
	УстановитьСписокКонтекстныхНовостейФормы(Форма, АктуальныеКонтекстныеНовости);
	ЗадатьЗначениеСчетчикаКоличестваНепрочитанныхСтатей(Форма);  
	ПоказатьКонтекстныеПодсказки(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает признак поддержки формой механизма контекстных подсказок.
//
// Параметры:
//  ПолноеИмяФормы - Имя формы - форма. Например "Документ.ПакетЭД.Форма.ФормаДокумента".
//
// Возвращаемое значение:
//  Булево - признак поддержки формой механизма контекстных подсказок.
//
Функция МеханизмПодсказокПоддерживается(ПолноеИмяФормы)
	
	ФормыСПоддержкойКонтекстныхПодсказок = ФормыСПоддержкойКонтекстныхПодсказок();
	 
	Возврат ФормыСПоддержкойКонтекстныхПодсказок.Получить(ПолноеИмяФормы) <> Неопределено; 
	
КонецФункции

// Возвращает список форм поддерживающих механизм контекстных подсказок.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
// Возвращаемое значение:
//  Соответствие - контекст формы.
//    * Ключ - Строка - имя метаданных формы;
//    * Значение - Строка - имя метаданных объекта-владельца.
//
Функция ФормыСПоддержкойКонтекстныхПодсказок()
	
	СписокФорм = Новый Соответствие;
	
	СписокФорм.Вставить("Документ.ПакетЭД.Форма.ФормаДокумента", "Документ.ПакетЭД");
	СписокФорм.Вставить("Документ.ЭлектронныйДокументВходящий.Форма.ФормаПросмотраЭД", "Документ.ЭлектронныйДокументВходящий");
	СписокФорм.Вставить("Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПросмотраЭД", "Документ.ЭлектронныйДокументИсходящий");
	СписокФорм.Вставить("Обработка.ОбменСКонтрагентами.Форма.АрхивЭлектронныхДокументов", "Обработка.ОбменСКонтрагентами");
	СписокФорм.Вставить("Обработка.ОбменСКонтрагентами.Форма.НастройкаОбменаСКонтрагентом", "Обработка.ОбменСКонтрагентами");
	СписокФорм.Вставить("Обработка.ОбменСКонтрагентами.Форма.СписокПроизвольныхЭлектронныхДокументов", "Обработка.ОбменСКонтрагентами");
	СписокФорм.Вставить("Обработка.ОбменСКонтрагентами.Форма.ТекущиеДелаПоЭДО", "Обработка.ОбменСКонтрагентами");
	СписокФорм.Вставить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Форма.НастройкиЭДО", "РегистрСведений.НастройкиОтправкиЭлектронныхДокументов");
	СписокФорм.Вставить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументов", "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам");
	СписокФорм.Вставить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовИнтеркампани", "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам");
	СписокФорм.Вставить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовПрямойОбмен", "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам");
	СписокФорм.Вставить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиРегламентаПрямогоОбмена", "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам");
	СписокФорм.Вставить("РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Форма.НастройкиОтраженияДокументовВУчете", "РегистрСведений.НастройкиПолученияЭлектронныхДокументов");
	СписокФорм.Вставить("РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами.Форма.ФормаПриглашения", "РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами");
	СписокФорм.Вставить("РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами.Форма.ПомощникОтправкиПриглашения", "РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами");
	СписокФорм.Вставить("РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗапись", "РегистрСведений.УчетныеЗаписиЭДО");
	СписокФорм.Вставить("РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗаписьПрямогоОбмена", "РегистрСведений.УчетныеЗаписиЭДО");
	СписокФорм.Вставить("РегистрСведений.УчетныеЗаписиЭДО.Форма.ФормаСписка", "РегистрСведений.УчетныеЗаписиЭДО");
	СписокФорм.Вставить("РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО", "РегистрСведений.УчетныеЗаписиЭДО"); 
	
	Возврат СписокФорм;
	
КонецФункции

// Подключает механизм отображения новостей подсистемы "ИнтернетПоддержкаПользователей.Новости"
// с параметрами для отображения контекстных подсказок.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура ИнициализироватьМеханизмУправленияНовостями(Форма)
	    
	НастройкиОтображенияНовостей = Новый Структура;
	НастройкиОтображенияНовостей.Вставить("СпособОтображенияПанелиКонтекстныхНовостей", "СписокНовостей");
	
	НастройкиЗаполненияНовостями = Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере, ПолучатьКатегорииНовостей", 
														Истина, Ложь, Истина);
	
	ЗаголовокФормы = НСтр("ru='Контекстные подсказки'");
	
	ИдентификаторФормы = КонтекстныеПодсказкиБЭДПовтИсп.ИдентификаторИмениФормы(Форма.ИмяФормы);
	
	МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
	МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		Форма,
		ИдентификаторФормы,
		"", НастройкиОтображенияНовостей,
		ЗаголовокФормы, Ложь, НастройкиЗаполненияНовостями);
		
КонецПроцедуры  

// Формирует кеш контекстных подсказок формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура СформироватьКешДанныхКонтекстныхПодсказок(Форма)

	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("КешКонтекстныхПодсказок", Новый ОписаниеТипов(Новый Массив))); 
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Новости", Новый ОписаниеТипов(Новый Массив))); 
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);

КонецПроцедуры

// Инициализирует кеш контекстных подсказок формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура ИнициализироватьКешДанныхКонтекстныхПодсказок(Форма)

	Форма.КешКонтекстныхПодсказок = Новый Структура("КонтекстФормы, АктуальныеДляТекущегоКонтекстаПодсказки");
	Форма.КешКонтекстныхПодсказок.КонтекстФормы = Новый Соответствие;

КонецПроцедуры

// Выполняет упорядочивание списка новостей согласно выражению упорядочивания.
//
// Параметры:
//  СписокНовостей - Массив из Структура - список новостей.
//  ВыражениеУпорядочивания - Строка - выражение упорядочивания. Например, "Прочтена Возр, ДатаПубликации Убыв".
//
Процедура ИзменитьПорядокНовостей(СписокНовостей, ВыражениеУпорядочивания)
	
	 Буфер = Новый ТаблицаЗначений;
	 Буфер.Колонки.Добавить("Значение");
	 
	 СтрокаПолейВыражения = СтрЗаменить(НРег(ВыражениеУпорядочивания), "убыв", "");
	 СтрокаПолейВыражения = СтрЗаменить(СтрокаПолейВыражения, "возр", "");

	 ПоляСортировки = СтрРазделить(СокрЛП(СтрокаПолейВыражения), ",");
	 
	 Для Каждого ПолеСортировки Из ПоляСортировки Цикл
		 Буфер.Колонки.Добавить(СокрЛП(ПолеСортировки)); 
	 КонецЦикла;
	 
	 Для Каждого Новость Из СписокНовостей Цикл
 
		СтрокаБуфера = Буфер.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаБуфера, Новость);
		СтрокаБуфера.Значение = Новость;

	 КонецЦикла;  
	 
	 Буфер.Сортировать(ВыражениеУпорядочивания);
	 
	 СписокНовостей = Буфер.ВыгрузитьКолонку("Значение"); 
	 
КонецПроцедуры

// Устанавливает значение для счетчика количества непрочитанных статей на панели контекстных новостей.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура ЗадатьЗначениеСчетчикаКоличестваНепрочитанныхСтатей(Форма)
	
	КоличествоНовостейДляСчетчика = КоличествоНовостейДляСчетчика(Форма);

	Форма.Элементы.ПанельКонтекстныхНовостей_СчетчикНепрочитанных.Заголовок = "";
	
	Если КоличествоНовостейДляСчетчика > 0 Тогда
		
		ШаблонСтроки = НСтр("ru = ';%1 совет;;%1 совета;%1 советов;%1 советов'");
		Представление = СтрокаСЧислом(ШаблонСтроки, КоличествоНовостейДляСчетчика, ВидЧисловогоЗначения.Количественное);
			
		Форма.Элементы.ПанельКонтекстныхНовостей_СчетчикНепрочитанных.Заголовок = НСтр("ru = 'еще '") + Представление;		
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает количество непрочитанных статей для формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
// Возвращаемое значение:
//  Число - количество непрочитанных статей.
//
Функция КоличествоНовостейДляСчетчика(Форма)
	
	КоличествоНеПрочитанныхНовостей = КоличествоНеПрочитанныхНовостей(Форма.КешКонтекстныхПодсказок.АктуальныеДляТекущегоКонтекстаПодсказки);  
	
	Если КоличествоНеПрочитанныхНовостей > 3 Тогда 
		КоличествоНовостейНаПанели = 3;
	Иначе
		КоличествоНовостейНаПанели = КоличествоНеПрочитанныхНовостей;
	КонецЕсли;
	
	КоличествоНовостейДляСчетчика = Форма.КешКонтекстныхПодсказок.АктуальныеДляТекущегоКонтекстаПодсказки.Количество() - КоличествоНовостейНаПанели;
	
	Возврат КоличествоНовостейДляСчетчика; 
	
КонецФункции

Функция КоличествоНеПрочитанныхНовостей(СписокНовостей)
	
	Количество = 0;  	
	
	Для Каждого Новость Из СписокНовостей Цикл
		
		Если Не Новость.Прочтена Тогда 
			Количество = Количество + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Количество;
	
КонецФункции

// Выполняет отображение контекстных подсказок.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура ПоказатьКонтекстныеПодсказки(Форма)
	
	Форма.Новости.Вставить("ИндексТекущейНовостиДляПанелиКонтекстныхНовостей", 0);
	Форма.Новости.Вставить("КоличествоНовостейДляПанелиКонтекстныхНовостей", Форма.Новости.НовостиДляПанелиКонтекстныхНовостей.Количество());
	Форма.Новости.Вставить("ВидимостьПанелиКонтекстныхНовостей", Истина);

	МодульОбработкаНовостейКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостейКлиентСервер");
	МодульОбработкаНовостейКлиентСервер.ПанельКонтекстныхНовостей_ОтобразитьНовости(Форма);
	
КонецПроцедуры

// Возвращает актуальные для контекста формы статьи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
// Возвращаемое значение:
//  Массив из Структура - список актуальных для контекста формы статей.
//
Функция АктуальныеДляКонтекстаСтатьи(Форма)
	
	МассивАктуальныхНеПрочтенныхНовостей = Новый Массив;
	МассивАктуальныхНовостей = Новый Массив;
	
	ДанныеКонтекстаФормы = Новый ТаблицаЗначений;
	ДанныеКонтекстаФормы.Колонки.Добавить("Категория", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.КатегорииНовостей"));
	ДанныеКонтекстаФормы.Колонки.Добавить("Значение", Метаданные.ПланыВидовХарактеристик["КатегорииНовостей"].Тип);
	ДанныеКонтекстаФормы.Колонки.Добавить("ЗначениеПараметраРасчета", Метаданные.ПланыВидовХарактеристик["КатегорииНовостей"].Тип);
	ДанныеКонтекстаФормы.Индексы.Добавить("Категория, ЗначениеПараметраРасчета");
	
	Для Каждого ЭлементКонтекста Из Форма.КешКонтекстныхПодсказок.КонтекстФормы Цикл
		СтрокаДанныхКонтекстаФормы = ДанныеКонтекстаФормы.Добавить();
		СтрокаДанныхКонтекстаФормы.Категория = ЭлементКонтекста.Ключ;
		СтрокаДанныхКонтекстаФормы.Значение = ЭлементКонтекста.Значение;
	КонецЦикла;

	ДанныеКонтекстовНовостей = ТаблицаКонтекстовНовостей(); 
	
	Для Каждого Новость Из Форма.Новости.Новости Цикл
		
		Для Каждого ЭлементКонтекста Из Новость.ЗначенияКатегорий Цикл
			
			СтрокаДанныхКонтекстаНовости = ДанныеКонтекстовНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанныхКонтекстаНовости, ЭлементКонтекста); 
			СтрокаДанныхКонтекстаНовости.Новость = Новость.Новость; 
			
			Если КонтекстныеПодсказкиБЭДКатегоризация.ЭтоВнеконтекстнаяКатегория(ЭлементКонтекста.КатегорияНовостей) Тогда
				
				СтрокаДанныхКонтекстаНовости.ЗначениеКатегорииНовостей = Истина;
				СтрокаДанныхКонтекстаНовости.ЗначениеПараметраРасчета = ЭлементКонтекста.ЗначениеКатегорииНовостей;
				
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Категория", ЭлементКонтекста.КатегорияНовостей);
				СтруктураПоиска.Вставить("ЗначениеПараметраРасчета", ЭлементКонтекста.ЗначениеКатегорииНовостей);
				
				СтрокаТаблицаКонтекстаФормы = ДанныеКонтекстаФормы.НайтиСтроки(СтруктураПоиска);
				
				Если Не ЗначениеЗаполнено(СтрокаТаблицаКонтекстаФормы) Тогда 
					
					СтрокаДанныхКонтекстаФормы = ДанныеКонтекстаФормы.Добавить();

					СтрокаДанныхКонтекстаФормы.Категория = ЭлементКонтекста.КатегорияНовостей;
					СтрокаДанныхКонтекстаФормы.Значение = КонтекстныеПодсказкиБЭДКатегоризация.УдовлетворяетОбщемуКонтексту(ЭлементКонтекста.КатегорияНовостей, ЭлементКонтекста.ЗначениеКатегорииНовостей);
					СтрокаДанныхКонтекстаФормы.ЗначениеПараметраРасчета = ЭлементКонтекста.ЗначениеКатегорииНовостей;
					
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла; 
	
	АктуальныеНовости = СопоставитьКонтекстПолучитьНовости(ДанныеКонтекстаФормы, ДанныеКонтекстовНовостей);
	АктуальныеНовости.Индексы.Добавить("Новость");
	
	Для Каждого Новость Из Форма.Новости.Новости Цикл
		
		Если (АктуальныеНовости.Найти(Новость.Новость, "Новость") <> Неопределено
				Или Не ЗначениеЗаполнено(Новость.ЗначенияКатегорий)) Тогда
				
				Если Не Новость.Прочтена Тогда
				
					МассивАктуальныхНеПрочтенныхНовостей.Добавить(Новость);
					
				КонецЕсли;
				
				МассивАктуальныхНовостей.Добавить(Новость);
			
		КонецЕсли;

	КонецЦикла;
	
	Форма.КешКонтекстныхПодсказок.Вставить("АктуальныеДляТекущегоКонтекстаПодсказки", МассивАктуальныхНовостей);
	
	Возврат МассивАктуальныхНеПрочтенныхНовостей;
	
КонецФункции

Функция ТаблицаКонтекстовНовостей()
	
	ДанныеВнеконтекстныхКатегорийНовостей = Новый ТаблицаЗначений;
	ДанныеВнеконтекстныхКатегорийНовостей.Колонки.Добавить("Новость", Новый ОписаниеТипов("СправочникСсылка.Новости"));
	ДанныеВнеконтекстныхКатегорийНовостей.Колонки.Добавить("КатегорияНовостей", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.КатегорииНовостей"));
	ДанныеВнеконтекстныхКатегорийНовостей.Колонки.Добавить("ЗначениеКатегорииНовостей", Метаданные.ПланыВидовХарактеристик.КатегорииНовостей.Тип);
	ДанныеВнеконтекстныхКатегорийНовостей.Колонки.Добавить("ЗначениеПараметраРасчета", Метаданные.ПланыВидовХарактеристик.КатегорииНовостей.Тип);
	
	Возврат ДанныеВнеконтекстныхКатегорийНовостей;

КонецФункции

Функция СопоставитьКонтекстПолучитьНовости(ДанныеКонтекста, ДанныеКонтекстовНовостей)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеКонтекста.Категория КАК КатегорияНовостей,
	|	ДанныеКонтекста.Значение КАК ЗначениеКатегорииНовостей,
	|	ДанныеКонтекста.ЗначениеПараметраРасчета КАК ЗначениеПараметраРасчета
	|ПОМЕСТИТЬ ДанныеКонтекста
	|ИЗ
	|	&ДанныеКонтекста КАК ДанныеКонтекста
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КатегорияНовостей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КатегорииНовостей.Новость КАК Новость,
	|	КатегорииНовостей.КатегорияНовостей КАК КатегорияНовостей,
	|	КатегорииНовостей.ЗначениеКатегорииНовостей КАК ЗначениеКатегорииНовостей,
	|	КатегорииНовостей.ЗначениеПараметраРасчета КАК ЗначениеПараметраРасчета
	|ПОМЕСТИТЬ КатегорииНовостей
	|ИЗ
	|	&ДанныеКонтекстовНовостей КАК КатегорииНовостей
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КатегорияНовостей,
	|	Новость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КатегорииНовостей.Новость КАК Новость,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЗначенияКатегории.ЗначениеКатегорииНовостей ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК ЗначениеКатегорииНовостейСовпадает,
	|	КатегорииНовостей.КатегорияНовостей КАК КоличествоКатегорийНовости
	|ПОМЕСТИТЬ ИтоговаяТаблицаСопоставления
	|ИЗ
	|	ДанныеКонтекста КАК ДанныеКонтекста
	|		ЛЕВОЕ СОЕДИНЕНИЕ КатегорииНовостей КАК КатегорииНовостей
	|		ПО (КатегорииНовостей.КатегорияНовостей = ДанныеКонтекста.КатегорияНовостей)
	|			И (КатегорииНовостей.ЗначениеПараметраРасчета = ДанныеКонтекста.ЗначениеПараметраРасчета)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КатегорииНовостей КАК ЗначенияКатегории
	|		ПО (ЗначенияКатегории.КатегорияНовостей = ДанныеКонтекста.КатегорияНовостей)
	|			И (ЗначенияКатегории.ЗначениеКатегорииНовостей = ДанныеКонтекста.ЗначениеКатегорииНовостей)
	|			И (ЗначенияКатегории.ЗначениеПараметраРасчета = ДанныеКонтекста.ЗначениеПараметраРасчета)
	|			И (ЗначенияКатегории.Новость = КатегорииНовостей.Новость)
	|ГДЕ
	|	НЕ КатегорииНовостей.Новость ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	КатегорииНовостей.Новость,
	|	КатегорииНовостей.КатегорияНовостей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИтоговаяТаблицаСопоставления.Новость КАК Новость
	|ИЗ
	|	ИтоговаяТаблицаСопоставления КАК ИтоговаяТаблицаСопоставления
	|
	|СГРУППИРОВАТЬ ПО
	|	ИтоговаяТаблицаСопоставления.Новость
	|
	|ИМЕЮЩИЕ
	|	СУММА(ИтоговаяТаблицаСопоставления.ЗначениеКатегорииНовостейСовпадает) = КОЛИЧЕСТВО(ИтоговаяТаблицаСопоставления.КоличествоКатегорийНовости)";
	
	Запрос.Параметры.Вставить("ДанныеКонтекста", ДанныеКонтекста);
	Запрос.Параметры.Вставить("ДанныеКонтекстовНовостей", ДанныеКонтекстовНовостей);
	 	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	Возврат РезультатЗапроса; 
	
КонецФункции

// Устанавливает список новостей для панели контекстных новостей формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//
Процедура УстановитьСписокКонтекстныхНовостейФормы(Форма, Новости)
	
	Форма.Новости.Вставить("НовостиДляПанелиКонтекстныхНовостей", Новости);

КонецПроцедуры

Процедура СформироватьПанельКонтекстныхНовостей(Форма, МестоРазмещения)
	
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево.Вид = ВидДекорацииФормы.Картинка;
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево.Картинка = БиблиотекаКартинок.ПерейтиНазад;
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВлево.Гиперссылка = Истина;
	
	ПанельКонтекстныхНовостей_КартинкаНовостиИнформация = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_КартинкаНовостиИнформация", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_КартинкаНовостиИнформация.Вид = ВидДекорацииФормы.Картинка;
	ПанельКонтекстныхНовостей_КартинкаНовостиИнформация.Картинка = БиблиотекаКартинок.ИнформацияНовости16Анимированная;
	ПанельКонтекстныхНовостей_КартинкаНовостиИнформация.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_КартинкаНовостиИнформация.Гиперссылка = Истина;
	
	ПанельКонтекстныхНовостей_СписокНовостей = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_СписокНовостей", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_СписокНовостей.Вид = ВидДекорацииФормы.Надпись;
	ПанельКонтекстныхНовостей_СписокНовостей.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ПанельКонтекстныхНовостейОбработкаНавигационнойСсылки");
	ПанельКонтекстныхНовостей_СписокНовостей.РастягиватьПоГоризонтали = Истина;
	ПанельКонтекстныхНовостей_СписокНовостей.АвтоМаксимальнаяШирина = Ложь;
	
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо.Вид = ВидДекорацииФормы.Картинка;
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо.Картинка = БиблиотекаКартинок.ПерейтиВперед;
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_КартинкаСтрелкаВправо.Гиперссылка = Истина;
	
	ПанельКонтекстныхНовостей_СчетчикНепрочитанных = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_СчетчикНепрочитанных", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_СчетчикНепрочитанных.Вид = ВидДекорацииФормы.Надпись;
	ПанельКонтекстныхНовостей_СчетчикНепрочитанных.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_СчетчикНепрочитанных.Гиперссылка = Истина;
	
	ПанельКонтекстныхНовостей_КартинкаВесьСписок = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_КартинкаВесьСписок", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_КартинкаВесьСписок.Вид = ВидДекорацииФормы.Картинка;
	ПанельКонтекстныхНовостей_КартинкаВесьСписок.Картинка = БиблиотекаКартинок.РежимПросмотраСпискаСписок;
	ПанельКонтекстныхНовостей_КартинкаВесьСписок.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_КартинкаВесьСписок.Гиперссылка = Истина;
	
	ПанельКонтекстныхНовостей_КартинкаЗакрыть = Форма.Элементы.Добавить(
		"ПанельКонтекстныхНовостей_КартинкаЗакрыть", 
		Тип("ДекорацияФормы"),
		МестоРазмещения);
		
	ПанельКонтекстныхНовостей_КартинкаЗакрыть.Вид = ВидДекорацииФормы.Картинка;
	ПанельКонтекстныхНовостей_КартинкаЗакрыть.Картинка = БиблиотекаКартинок.Закрыть;
	ПанельКонтекстныхНовостей_КартинкаЗакрыть.УстановитьДействие("Нажатие", "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие");
	ПанельКонтекстныхНовостей_КартинкаЗакрыть.Гиперссылка = Истина;
	
КонецПроцедуры

Процедура ДобавитьПодключаемыеКоманды(Форма, МестаРазмещения)
	
	Если МестаРазмещения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьКоманду(Форма, НСтр("ru='Все советы'"), "КомандаПоказатьВсеНовости");
	ДобавитьКоманду(Форма, НСтр("ru='Советы для текущего состояния'"), "КомандаПоказатьВсеКонтекстныеНовостиНовости");  
	ДобавитьКоманду(Форма, НСтр("ru='Панель советов'"), "ВидимостьПанелиКонтекстныхНовостей");
	
	Для Каждого МестоРазмещения Из МассивМестРазмещения(МестаРазмещения) Цикл
		МестоРазмещения.Заголовок = НСтр("ru='Советы'");
		ДобавитьКнопку(Форма, МестоРазмещения, "КомандаПоказатьВсеНовости");
		ДобавитьКнопку(Форма, МестоРазмещения, "КомандаПоказатьВсеКонтекстныеНовостиНовости");
		ДобавитьКнопку(Форма, МестоРазмещения, "ВидимостьПанелиКонтекстныхНовостей", Истина); 
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьКоманду(Форма, ЗаголовокКоманды, ИмяКоманды)
	
	Команда = Форма.Команды.Добавить(ИмяКоманды);
	Команда.Заголовок = ЗаголовокКоманды;
	Команда.Действие  = "Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие";	
		
КонецПроцедуры

Процедура ДобавитьКнопку(Форма, МестоРазмещения, ИмяКоманды, Пометка = Ложь)
	
	ИмяКнопки = МестоРазмещения.Имя + ИмяКоманды;
	
	КнопкаФормы = Форма.Элементы.Добавить(
		"Кнопка" + ИмяКнопки, 
		Тип("КнопкаФормы"),
		МестоРазмещения);
		
	КнопкаФормы.ИмяКоманды = ИмяКоманды;
	КнопкаФормы.Вид = ВидКнопкиФормы.ОбычнаяКнопка; 
	КнопкаФормы.Отображение = ОтображениеКнопки.Текст;
	КнопкаФормы.ТолькоВоВсехДействиях = Истина;
	КнопкаФормы.Пометка = Пометка;

КонецПроцедуры

Функция МассивМестРазмещения(МестаРазмещения)
	
	Если ТипЗнч(МестаРазмещения) <> Тип("Массив") Тогда
		МассивМестРазмещения = Новый Массив;
		МассивМестРазмещения.Добавить(МестаРазмещения);
		Возврат МассивМестРазмещения;
	Иначе
		Возврат МестаРазмещения;
	КонецЕсли;

КонецФункции

#Область ДляРасширения

Функция Подключаемый_ДоступныеКатегорииФормы(ПолноеИмяФормы) Экспорт
	
	ДоступныеКатегории = Новый Массив();
	
	Если ПолноеИмяФормы = "Документ.ПакетЭД.Форма.ФормаДокумента" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "Документ.ЭлектронныйДокументВходящий.Форма.ФормаПросмотраЭД" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СтатусЭлектронногоДокумента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СтатусДокументооборота());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_ВидЭлектронногоДокумента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СуществуютНеверныеПодписиФайла());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СтатусОтраженияЭДВУчете());
	ИначеЕсли ПолноеИмяФормы = "Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПросмотраЭД" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СтатусЭлектронногоДокумента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СтатусДокументооборота());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_ВидЭлектронногоДокумента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_СуществуютНеверныеПодписиФайла());
	ИначеЕсли ПолноеИмяФормы = "Обработка.ОбменСКонтрагентами.Форма.НастройкаОбменаСКонтрагентом" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Форма.НастройкиЭДО" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовПрямойОбмен" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиРегламентаПрямогоОбмена" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_ВидЭлектронногоДокумента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Форма.НастройкиОтраженияДокументовВУчете" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами.Форма.ФормаПриглашения" Тогда;
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами.Форма.ПомощникОтправкиПриглашения" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораКонтрагента());
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗапись" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗаписьПрямогоОбмена" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	ИначеЕсли ПолноеИмяФормы = "РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО" Тогда
		ДоступныеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	КонецЕсли;
	
	Возврат ДоступныеКатегории;
	
КонецФункции

#КонецОбласти


#КонецОбласти
