#Область СлужебныйПрограммныйИнтерфейс

#Область Локализация

//Обработчик события вызывается на сервере при открытии формы конфигурации.
//   Выполняется определение необходимости встраивания подсистем (с учетом их наличия) в форму.
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - форма конфигурации
//   МодулиИнтеграции - Массив           - используемые модули интеграции
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПрикладногоОбъекта(Форма, МодулиИнтеграции) Экспорт
	
	//++ НЕ ГОСИС
	Модули = Новый Соответствие;
	
	ИмяФормы = Форма.ИмяФормы;
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВнутреннееПотреблениеТоваров.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ЗаказПоставщику.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента"
		Тогда
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ") Тогда
			Модули.Вставить("СобытияФормГИСМ");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.КорректировкаПриобретения.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента" Тогда
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
			Модули.Вставить("СобытияФормИСМП");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ПомощникНового"
		Или ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников" Тогда
			Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
				Модули.Вставить("СобытияФормЕГАИС");
			КонецЕсли;
			Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
				Модули.Вставить("СобытияФормИСМП");
			КонецЕсли;
	КонецЕсли;
	
	Если ИмяФормы = "Справочник.НастройкиРМК.Форма.ФормаЭлемента" Тогда
		Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийАлкоВРознице") Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяФормы = "Обработка.ПодборСерийВДокументы.Форма.УказаниеСерииВСтрокеТоваров" Тогда
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПодконтрольныхТоваровВЕТИС") Тогда
			Модули.Вставить("СобытияФормВЕТИС");
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") 
		И ТипЗнч(Форма.Объект) = Тип("ДанныеФормыСтруктура") Тогда
		
		Если ИнтеграцияЕГАИС.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
		
		Если ИнтеграцияВЕТИС.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормВЕТИС");
		КонецЕсли;
		
		Если ИнтеграцияИСМП.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормИСМП");
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Модули Цикл
		МодулиИнтеграции.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Серверные обработчики БГосИС элементов прикладных форм
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Элемент = "Товары" Тогда
			
			ПроверкаИПодборПродукцииИС.ПрименитьКешШтрихкодовУпаковок(Форма, ПроверкаИПодборПродукцииИСМПУТ.НастройкиИсточникаКешаЧека(), Истина);
			ШтрихкодированиеИС.ОбновитьКэшМаркируемойПродукции(Форма);
			
		ИначеЕсли Элемент = "ЗавершенаПроверкаКоличества" Тогда
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(
				ДополнительныеПараметры, "АкцизныеМарки") Тогда
				АкцизныеМарки = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АкцизныеМарки);
				Форма.Объект.АкцизныеМарки.Загрузить(АкцизныеМарки);
			КонецЕсли;
			ПроверкаИПодборПродукцииИС.ЗаполнитьКешШтрихкодовУпаковок(Форма, ПроверкаИПодборПродукцииИСМПУТ.НастройкиИсточникаКешаЧека());
			ПроверкаИПодборПродукцииИС.ПрименитьКешШтрихкодовУпаковок(Форма, ПроверкаИПодборПродукцииИСМПУТ.НастройкиИсточникаКешаЧека());
			ШтрихкодированиеИС.ОбновитьКэшМаркируемойПродукции(Форма);
			
		ИначеЕсли Элемент = "Серии" Тогда
			
			ИнтеграцияЕГАИСУТ.ЗаполнитьАлкогольнуюПродукцию(Форма.Объект.Товары, Форма.Объект.Серии);
			ПроверкаИПодборПродукцииИС.ПрименитьКешШтрихкодовУпаковок(Форма, ПроверкаИПодборПродукцииИСМПУТ.НастройкиИсточникаКешаЧека(), Истина);
			
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ПомощникНового" Тогда
		
		Если Элемент = "Назначение" Тогда
			
			Если Форма.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок Тогда
				Форма.ДляЧего = Документы.ЗапросАкцизныхМарокЕГАИС.ПустаяСсылка();
				Форма.Элементы.ДляЧего.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.ЗапросАкцизныхМарокЕГАИС");
				Форма.Элементы.ДляЧего.Видимость = Истина;
			ИначеЕсли Форма.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок Тогда
				Форма.ДляЧего = Справочники.ШтрихкодыУпаковокТоваров.ПустаяСсылка();
				Форма.Элементы.ДляЧего.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров");
				Форма.Элементы.ДляЧего.Видимость = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников" Тогда
		
		Если Элемент = "Назначение" Тогда
			
			Если Форма.Объект.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок Тогда
				Если ДополнительныеПараметры.ОчищатьНазначение ИЛИ Форма.Объект.ДляЧего = Неопределено Тогда
					Форма.Объект.ДляЧего = Документы.ЗапросАкцизныхМарокЕГАИС.ПустаяСсылка();
				КонецЕсли;
				Форма.Элементы.ДляЧего.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.ЗапросАкцизныхМарокЕГАИС");
			ИначеЕсли Форма.Объект.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок Тогда
				Если ДополнительныеПараметры.ОчищатьНазначение ИЛИ Форма.Объект.ДляЧего = Неопределено Тогда
					Форма.Объект.ДляЧего = Справочники.ШтрихкодыУпаковокТоваров.ПустаяСсылка();
				КонецЕсли;
				Форма.Элементы.ДляЧего.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров");
			КонецЕсли;
			
		КонецЕсли;
		
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Вызывается после записи объекта на сервере.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - источник вызова
Процедура ПослеЗаписиНаСервереФормыПрикладногоОбъекта(Форма) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуРМК(Форма);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервереВФормеПрикладногоОбъекта(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ПомощникНового" Тогда
		
		Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок);
		Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
			Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
			Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП);
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников" Тогда
		
		Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок);
		Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
			Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
			Форма.Элементы.Назначение.СписокВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП);
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Обработка.ПодборСерийВДокументы.Форма.УказаниеСерииВСтрокеТоваров" Тогда
		
		Если ДополнительныеПараметры.Свойство("ДатаПроизводстваНачалоПериода") Тогда
			Форма.ДатаПроизводства = ДополнительныеПараметры.ДатаПроизводстваНачалоПериода;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("СрокГодностиНачалоПериода") Тогда
			Форма.ГоденДо = ДополнительныеПараметры.СрокГодностиНачалоПериода;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("ЗаписьСкладскогоЖурнала") Тогда
			Форма.ЗаписьСкладскогоЖурналаВЕТИС = ДополнительныеПараметры.ЗаписьСкладскогоЖурнала;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("ИдентификаторПартии") Тогда
			Форма.ИдентификаторПартииВЕТИС = ДополнительныеПараметры.ЗаписьСкладскогоЖурнала;
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента" Тогда 
		ОбщегоНазначенияУТ.ИнициализироватьКешТекущейСтроки(Форма, "Товары");
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъектов

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяСправочника - Строка - имя справочника, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыСправочника(ИмяСправочника, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра сведений, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыРегистраСведений(ИмяРегистра, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Возникает на сервере при создании формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - создаваемая форма,
//  Отказ - Булево - признак отказа от создания формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.МаркировкаТоваровГИСМ.Форма.ФормаСписка"
	 ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровГИСМ.Форма.ФормаСписка" Тогда
		ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(Форма);
	ИначеЕсли ИмяФормы = "Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов" Тогда
		Форма.Элементы.СтраницаКОформлению.Видимость = Ложь;
		Форма.Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	ИначеЕсли ИмяФормы = "Обработка.ПанельАдминистрированияЕГАИС.Форма.НастройкиЕГАИС" Тогда
		
		НоваяСтрока           = Форма.ДополнительныеКонстанты.Добавить();
		НоваяСтрока.Имя       = "РазрешатьПродажуАлкогольнойПродукцииБезСопоставленияЕГАИС";
		НоваяСтрока.Заголовок = НСтр("ru = 'Продажа без сопоставления классификаторов с ЕГАИС'");
		НоваяСтрока.Описание  = НСтр("ru = 'Разрешать продажу алкогольной продукции без сопоставления классификаторов номенклатуры с ЕГАИС.'");
		
		НоваяСтрока           = Форма.ДополнительныеКонстанты.Добавить();
		НоваяСтрока.Имя       = "ДатаНачалаПримененияПриказа164";
		НоваяСтрока.Заголовок = НСтр("ru = 'Дата начала применения приказа ФСРАР №164'");
		НоваяСтрока.Описание  = НСтр("ru = 'Дата начала применения приказа ФСРАР №164 ""О форме журнала учета объема розничной продажи алкогольной и спиртосодержащей продукции и порядке его заполнения"".'");
		
		НоваяСтрока           = Форма.ДополнительныеКонстанты.Добавить();
		НоваяСтрока.Имя       = "ДатаНачалаРегистрацииЗакупокПоЕГАИС";
		НоваяСтрока.Заголовок = НСтр("ru = 'Дата начала регистрации закупок по ЕГАИС'");
		НоваяСтрока.Описание  = НСтр("ru = 'Дата начала оформления закупок по ЕГАИС: получение ТТН ЕГАИС, ввод накладных с отправкой ответа в ЕГАИС.'");
		
	ИначеЕсли ИмяФормы = "Обработка.ПанельОбменИСМП.Форма.Форма" Тогда
		ИнтеграцияИСКлиентСервер.НастроитьОтборПоОрганизации(Форма, Форма.Организации, Неопределено, "Отбор");
	
	ИначеЕсли ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ЗагрузкаВходящихДокументов" Тогда
		Если Форма.Организации.Количество() = 0 Тогда
			ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
			Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
				ЭлементСписка = Форма.Организации.Добавить();
				ЭлементСписка.Значение = ОрганизацияПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		
		Если ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СтраницыКОформлениюОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СписокКОформлениюОрганизация.Видимость = Ложь;
			Форма.Элементы.Организация.Видимость = Ложь;
			Форма.Элементы.СписокКОформлениюОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Обработка.ПанельОбменИСМП.Форма.Форма" Тогда
			
			Форма.Элементы.СтраницыОтборОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаДокумента" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
		ИначеЕсли ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ЗагрузкаВходящихДокументов"
			И Форма.Организации.Количество() Тогда
			Форма.Элементы.Организация.Видимость = Ложь;
		ИначеЕсли ИмяФормы = "Справочник.ШаблоныЭтикетокСУЗ.Форма.ФормаСписка"
			Или ИмяФормы = "Справочник.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Справочник.ШаблоныЭтикетокСУЗ.Форма.ФормаЭлемента"
			Или ИмяФормы = "Справочник.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.Форма.ФормаЭлемента" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "РегистрСведений.СогласиеОПредоставленииИнформацииГИСМТ.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.СтраницыОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СписокОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "РегистрСведений.СогласиеОПредоставленииИнформацииГИСМТ.Форма.ФормаЗаписи" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
#Область ОграничениеТипаОпределяемыйТипСтавкаНДС
	Если ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
			Форма.Элементы.ТоварыСтавкаНДС.ОграничениеТипа = Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС");
	КонецЕсли;
#КонецОбласти
	
	СобытияФорм.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Вызывается при чтении объекта на сервере.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма читаемого объекта,
//  ТекущийОбъект - ДокументОбъект, СправочникОбъект - читаемый объект.
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	//++ НЕ ГОСИС
	СобытияФорм.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма - форма, из обработчика события которой происходит вызов процедуры.
//          См. справочную информацию по событиям управляемой формы.
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	//++ НЕ ГОСИС
	СобытияФорм.ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая часть обработки проверки заполнения формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма.
//   Отказ - Булево - Истина если проверка заполнения не пройдена
//   ПроверяемыеРеквизиты - Массив Из Строка - реквизиты формы, отмеченные для проверки
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "ОбщаяФорма.ФормаУточненияДанныхИС" Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		Если Не Форма.ХарактеристикиИспользуются Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
		КонецЕсли;
		Если Не (Форма.ТребуетсяУказаниеСерии И ЗначениеЗаполнено(Форма.Склад)) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Серия");
		КонецЕсли;
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДействийФорм

// Возникает на сервере при записи константы в формах настроек
// если запись одной константы может повлечь изменение других отображаемых в этой же форме.
//
// Параметры:
//  Форма             - ФормаКлиентскогоПриложения - форма,
//  КонстантаИмя      - Строка           - записываемая константа,
//  КонстантаЗначение - Произвольный     - значение константы.
Процедура ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(Форма, КонстантаИмя, КонстантаЗначение) Экспорт
	
	//++ НЕ ГОСИС
	Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
		Форма.Прочитать();
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Устанавливается свойство ОтображениеПредупрежденияПриРедактировании элемента формы.
//
Процедура ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать) Экспорт

	//++ НЕ ГОСИС
	ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать);
	//-- НЕ ГОСИС
	Возврат
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление для поля "Характеристика".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаХарактеристики - Строка - имя элемента формы "Характеристика",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Характеристики используются".
Процедура УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
	Форма,
	ИмяПоляВводаХарактеристики = "ТоварыХарактеристика",
	ПутьКПолюОтбора = "Объект.Товары.ХарактеристикиИспользуются") Экспорт
	
	//++ НЕ ГОСИС
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		Форма.Элементы[ИмяПоляВводаХарактеристики].Видимость = Ложь;
	КонецЕсли;
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(Форма, ИмяПоляВводаХарактеристики, ПутьКПолюОтбора);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Единица измерения".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаЕдиницИзмерения - Строка - имя элемента формы "Единица измерения",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Упаковка".
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
	                                                  ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураЕдиницаИзмерения",
	                                                  ПутьКПолюОтбора = "Объект.Товары.Упаковка") Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(Форма, ИмяПоляВводаЕдиницИзмерения, ПутьКПолюОтбора);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Серия".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма, в которой нужно установить условное оформление,
//   ИмяПоляВводаСерии - Строка - Имя элемента формы для указания серии
//   ПутьКПолюОтбораСтатусУказанияСерий - Строка - Имя реквизита формы со статусом указания серии
//   ПутьКПолюОтбораТипНоменклатуры - Строка - Имя реквизита формы с указанием типа номенклатуры
//
Процедура УстановитьУсловноеОформлениеСерийНоменклатуры(Форма,
														ИмяПоляВводаСерии = "ТоварыСерия",
														ПутьКПолюОтбораСтатусУказанияСерий = "Объект.Товары.СтатусУказанияСерий",
														ПутьКПолюОтбораТипНоменклатуры = "Объект.Товары.ТипНоменклатуры") Экспорт
	
	//++ НЕ ГОСИС
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		Форма.Элементы[ИмяПоляВводаСерии].Видимость = Ложь;
	КонецЕсли;
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(
		Форма, "СерииВсегдаВТЧТовары", ИмяПоляВводаСерии, ПутьКПолюОтбораСтатусУказанияСерий, ПутьКПолюОтбораТипНоменклатуры);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		Возврат;
	КонецЕсли;
	
	// Статусы FEFO
	СписокСтатусовСерий = Новый СписокЗначений;
	СписокСтатусовСерий.Добавить(5);
	СписокСтатусовСерий.Добавить(6);
	СписокСтатусовСерий.Добавить(25);
	ЭлементУсловногоОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляВводаСерии);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюОтбораСтатусУказанияСерий);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусовСерий;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Автозаполнение FEFO>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СвязиПараметровВыбора

// Устанавливает связь элемента формы с полем ввода номенклатуры.
//
// Параметры:
//	Форма					- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода			- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымНоменклатуры	- Строка			- Путь к данным текущей номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСНоменклатурой(Форма, ИмяПоляВвода,
	ПутьКДаннымНоменклатуры = "Элементы.Товары.ТекущиеДанные.Номенклатура") Экспорт
	
	//++ НЕ ГОСИС
	СвязиПараметровВыбора = ОбщегоНазначения.СкопироватьРекурсивно(
		Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора, Ложь);
	СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Номенклатура", ПутьКДаннымНоменклатуры));
	
	Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем ввода характеристики номенклатуры.
//
// Параметры:
//	Форма						- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода				- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымХарактеристики	- Строка			- Путь к данным текущей характеристики номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСХарактеристикой(Форма, ИмяПоляВвода,
	ПутьКДаннымХарактеристики = "Элементы.Товары.ТекущиеДанные.Характеристика") Экспорт
	
	//++ НЕ ГОСИС
	СвязиПараметровВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора, Ложь);
	СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Характеристика", ПутьКДаннымХарактеристики));
	
	Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает у элемента формы Упаковка подсказку ввода для соответствующей номенклатуры
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
//
Процедура УстановитьИнформациюОЕдиницеХранения(Форма) Экспорт
	
	//++ НЕ ГОСИС
	Справочники.УпаковкиЕдиницыИзмерения.ОтобразитьИнформациюОЕдиницеХранения(Форма.Объект.Номенклатура, Форма.Элементы.Упаковка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИзмененияОпределяемыхТипов

// Выполняет действия при изменении номенклатуры в объекте (форме, строке табличной части итп).
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - Произвольный - контекст редактирования (текущая строка таблицы, шапка объекта, форма)
//  КэшированныеЗначения   - Неопределено, Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - Произвольный - параметры указания серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения = Неопределено, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Характеристика") Тогда
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",
			ТекущаяСтрока.Характеристика);
			
		СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",
			Новый Структура("Номенклатура", "ТипНоменклатуры"));
		
		Если ПараметрыУказанияСерий <> Неопределено Тогда
			
			Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
				ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
			Иначе
				ИсточникЗначенийВФорме = Форма;
			КонецЕсли;
			
			ПараметрыУказанияСерийКопия = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыУказанияСерий, Ложь);
			Если СтрНачинаетсяС(Форма.ИмяФормы, "Обработка.ПроверкаИПодбор") Тогда
				ПараметрыУказанияСерийКопия.ИмяТЧТовары = "Товары";
				ПараметрыУказанияСерийКопия.ИмяТЧСерии = "Товары";
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Удалить(
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Найти("КоличествоПодобрано"));
			КонецЕсли;
			
			Склад = Неопределено;
			Если Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
				Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
			КонецЕсли;
			
			СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
				Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерийКопия, Склад));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Артикул") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмерения") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",   Новый Структура("НалогообложениеНДС, Дата", 
			ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС")));
	КонецЕсли;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Сумма") Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда
		СтруктураДействий.Вставить("ЗаполнитьКодТНВЭД");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти