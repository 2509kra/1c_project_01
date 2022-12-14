#Область СобытияЭлементовФорм

// Клиентская переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" Тогда
		
		Если Элемент = Форма.Элементы.Товары Тогда
		
			ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
			Если ТекущаяСтрока = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			НужноПересчитатьКеш = ПроверкаИПодборПродукцииИСКлиент.ПрименитьКешПоСтроке(
				Форма,
				Форма.Объект.Товары,
				ТекущаяСтрока,
				Форма.ТоварыКешТекущейСтроки);
			
			Если НужноПересчитатьКеш Тогда
				ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
// 
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "Выбор".
//   ВыбраннаяСтрока         - ДанныеФормыЭлементКоллекции - выбранный элемент коллекции.
//   Поле                    - ПолеФормы - поле формы события "Выбор".
//   СтандартнаяОбработка    - Булево - установить ложь, если требуется отказываться от выполнения стандартной обработки.
//   ДополнительныеПараметры - Структура  - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	
	Если  Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента" Тогда
		
		Если Элемент = Форма.Элементы.Товары
			И Поле = Форма.Элементы.ТоварыРасхожденияПоКодамМаркировки Тогда
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Номенклатура", ВыбраннаяСтрока.Номенклатура);
			ПараметрыОтбора.Вставить("Характеристика", ВыбраннаяСтрока.Характеристика);
			ПараметрыОтбора.Вставить("Представление", "");
			Если ДополнительныеПараметры = Неопределено Тогда
				ДополнительныеПараметры = Новый Структура;
			КонецЕсли;
			ДополнительныеПараметры.Вставить("ДанныеВыбораПоМаркируемойПродукции",  ПараметрыОтбора);
			ДополнительныеПараметры.Вставить("СохраненВыборПоМаркируемойПродукции", Истина);
			
			СтандартнаяОбработка = Ложь;
			
			СверкаКодовМаркировкиИСМПКлиент.ОткрытьФормуРезультатовСверкиКодовМаркировки(Форма, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт

	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
// 
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "ПриАктивизации".
//   ДополнительныеПараметры - Структура  - значения дополнительных параметров влияющих на обработку.
Процедура ПриАктивизацииСтроки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	
	Если (Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента")
		И Элемент = Форма.Элементы.Товары Тогда
		
		ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ДоступностьКнопкиРазбитьСтроку = НЕ (ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущиеДанные, "МаркируемаяПродукция")
											     И ТекущиеДанные.МаркируемаяПродукция);
			Форма.Элементы.ТоварыРазбитьСтроку.Доступность = ДоступностьКнопкиРазбитьСтроку;
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(ИмяСобытия, "ЗакрытиеФормыПроверкиИПодбораГосИС") Тогда
		Если ДополнительныеПараметры = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если Источник = Форма.УникальныйИдентификатор Тогда
			ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
			ДополнительныеПараметры.ТребуетсяСерверныйВызов = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если СтрНачинаетсяС(ИмяСобытия, "ОбновитьСостояниеЭД")
		И (Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
			Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента") Тогда
		// требуется обновить гиперссылки ИСМП
		СобытияФормИСМПКлиент.ОбработкаОповещения(Форма,
			ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен("ИСМП"),
			Неопределено, Неопределено, Неопределено);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, для которой выполняется команда
//  Команда                 - Произвольный     - команда формы
//  ДополнительныеПараметры - Произвольный     - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСТСД

// В процедуре нужно реализовать алгоритм передачи данных в ТСД.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, инициировавшая выгрузку.
Процедура ВыгрузитьДанныеВТСД(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - ФормаКлиентскогоПриложения - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - (См. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании).
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	//++ НЕ ГОСИС
	Если РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения.ТаблицаТоваров);
		
	Иначе
		
		СобытияФормИСКлиент.СообщитьОбОшибке(РезультатВыполнения);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Номенклатура

// Выполняется при создании номенклатуры из формы МОТП. Требуется определить и открыть форму (диалога) создания номенклатуры.
//
// Параметры:
//  Владелец     - ФормаКлиентскогоПриложения            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
Процедура ПриСозданииНоменклатуры(Владелец, ДанныеСтроки, СтандартнаяОбработка, ВидПродукцииИС) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	
	ОсобенностьУчета = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидПродукцииИС);
	
	Если ОсобенностьУчета <> Неопределено Тогда
		ПараметрыФормы.Вставить("ОсобенностьУчета", ОсобенностьУчета);
	КонецЕсли;
	
	Если ДанныеСтроки.Свойство("ПредставлениеНоменклатуры") Тогда
		ПараметрыФормы.Вставить("Наименование", ДанныеСтроки.ПредставлениеНоменклатуры);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Владелец);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора номенклатуры.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип..Номенклатура - Результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Номенклатура") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Количество = Неопределено;
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
			
		ИсточникЗначенийВФорме = Форма;
		Если ПараметрыУказанияСерий <> Неопределено Тогда
			Если ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ТекущиеДанные" Тогда
				ИсточникЗначенийВФорме = ТекущаяСтрока;
			ИначеЕсли ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
				ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
			КонецЕсли;
		КонецЕсли;
	
		Склад = Неопределено;
		Если ПараметрыУказанияСерий <> Неопределено И Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
		КонецЕсли;
		
		ПараметрыУказанияСерийКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыУказанияСерий, Ложь);
		
		Если СтрНачинаетсяС(Форма.ИмяФормы, "Обработка.ПроверкаИПодбор") Тогда
			ПараметрыУказанияСерийКопия.ИмяТЧТовары = "Товары";
			ПараметрыУказанияСерийКопия.ИмяТЧСерии = "Товары";
			ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Удалить(
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Найти("КоличествоПодобрано"));
			ТекущаяСтрока.Склад = Форма.Склад;
			// Количество сохраняется и восстановливается при завершении обработки
			// для корректного расчета статусов указания серий.
			Количество = ТекущаяСтрока.Количество;
			ТекущаяСтрока.Количество = ТекущаяСтрока.КоличествоПодобрано;
		ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "ОбщаяФорма.УточнениеСоставаУпаковкиИС") Тогда
			ПараметрыУказанияСерийКопия.ИмяТЧТовары = "Товары";
			ПараметрыУказанияСерийКопия.ИмяТЧСерии = "Товары";
			ТекущаяСтрока.Склад = Форма.Склад;
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
			Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерийКопия, Склад));
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
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС") Тогда
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
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если Количество <> Неопределено Тогда
		
		ТекущаяСтрока.Количество = Количество;
		// Для обхода ошибки расчета статуса указания серий
		Если ТекущаяСтрока.СтатусУказанияСерий = 1
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 2;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 3
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 4;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 5
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 6;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 7
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 8;
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки подбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%'");
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Форма.Объект.Ссылка);
	Иначе
		Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Маркировка товаров ИС МП'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Заказ на эмиссию кодов маркировки СУЗ ИС МП'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ОтгрузкаТоваровИСМП") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Отгрузка товаров ИС МП'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.СписаниеКодовМаркировкиИСМП") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Списание кодов маркировки ИС МП'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ВыводИзОборотаИСМП") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Вывод из оборота ИС МП'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Перемаркировка товаров ИС МП'"));
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОсобенностьУчета",                        ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(Форма.Объект.ВидПродукции));
	ПараметрыФормы.Вставить("РежимПодбораБезКоличественныхПараметров", Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",       Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуЗапрашиватьКоличество",     Истина);
	ПараметрыФормы.Вставить("Заголовок",                               ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",                                    Форма.Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                Форма.Объект.Ссылка);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	
	ОткрытьФорму(
		"Обработка.ПодборТоваровВДокументПродажи.Форма",
		ПараметрыФормы,
		Форма,
		Форма.УникальныйИдентификатор,,,
		ОповещениеПриЗавершении);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Обрабатывает результат выбора в форму документа ИСМП (например из формы подбора номенклатуры,
//   при использовании множественного выбора вместо закрытия формы подбора с общим результатом).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки сопоставления,
//  ВыбранноеЗначение - Произвольный - результат выбора.
//  ИсточникВыбора    - ФормаКлиентскогоПриложения - форма, в которой произведен выбор.
Процедура ОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область ПараметрыВыбора

// Устанавливает параметры выбора контрагента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора.
//   ТолькоЮрЛицаНерезиденты - Неопределено, Булево - Признак нерезидента.
//   ИмяПоляВвода            - Строка               - имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораКонтрагента(Форма, ТолькоЮрЛицаНерезиденты = Неопределено, ИмяПоляВвода = "Контрагент") Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = Новый Массив;
	
	Если ТолькоЮрЛицаНерезиденты = Истина Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ЮрФизЛицо", ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент")));
	КонецЕсли;
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Открывает форму подбора контрагентов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки подбора,
//  ПараметрыФормы - Структура - Параметры формы,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораКонтрагента(Форма, ПараметрыФормы = Неопределено, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора", ПараметрыФормы, Форма,,,, ОповещениеПриЗавершении);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора контрагента.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.КонтрагентГосИС - Результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораКонтрагента(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Контрагенты") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ХарактеристикиНоменклатуры

// Выполняется при начале выбора характеристики. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - ФормаКлиентскогоПриложения            - форма, в которой вызывается команда выбора характеристики.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
//  СтандартнаяОбработка - Булево - Выключается в переопределении
//  Описание - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//
Процедура ПриНачалеВыбораХарактеристики(
	Владелец, ДанныеСтроки, СтандартнаяОбработка, ИмяКолонкиНоменклатура="Номенклатура", Описание=Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	ПараметрыХарактеристики = Новый Структура;
	ПараметрыХарактеристики.Вставить("Номенклатура", ДанныеСтроки[ИмяКолонкиНоменклатура]);
	
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыХарактеристики, Владелец,,,, Описание);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняется при создании характеристики из формы МОТП. Требуется пепеопределить и открыть форму (диалога)
// создания характеристики при необходимости.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения            - Форма владелец.
//  ДанныеСтроки         - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
//  Элемент              - ПолеВвода                   - элемент в котором создается характеристика.
//  СтандартнаяОбработка - Булево                      - Признак стандартной обработки.
Процедура ПриСозданииХарактеристики(Владелец, ДанныеСтроки, Элемент, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора характеристики.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.ХарактеристикаНоменклатуры - результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораХарактеристики(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.ХарактеристикиНоменклатуры") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении характеристики номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

// Выполняет действия при изменении серии номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииСерии(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение                   = ТекущаяСтрока.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора серии.
// 
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.СерияНоменклатуры - результат выбора.
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
Процедура ОбработкаВыбораСерии(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Количество

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		
		Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
			ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
		Иначе
			ИсточникЗначенийВФорме = Форма;
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			ПараметрыУказанияСерийКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыУказанияСерий, Ложь);
			
			Если СтрНачинаетсяС(Форма.ИмяФормы, "Обработка.ПроверкаИПодбор") Тогда
				ПараметрыУказанияСерийКопия.ИмяТЧТовары = "Товары";
				ПараметрыУказанияСерийКопия.ИмяТЧСерии = "Товары";
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Удалить(
					ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Найти("КоличествоПодобрано"));
			КонецЕсли;
			
			Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
			СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
				Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерийКопия, Склад));
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Сумма") Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СуммаИНДС

// Выполняет действия при изменении ставки НДС в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСтавкиНДС(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Сумма") Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении суммы в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСуммы(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении суммы НДС в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСуммыНДС(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	
	СтруктураДействий = Новый Структура;
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

Процедура ПриНачалеВыбораКодТНВЭД(Владелец, ДанныеСтроки, СтандартнаяОбработка, Описание = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Если ДанныеСтроки <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("ТекущаяСтрока", ДанныеСтроки.КодТНВЭД);
		ПараметрыФормы.Вставить("ВидПродукции",  ДанныеСтроки.ВидПродукции);
		ПараметрыФормы.Вставить("Организация",   ДанныеСтроки.Организация);
		ПараметрыФормы.Вставить("РежимВыбора",   Истина);
		
		ПараметрыФормы.Вставить("ВозвращатьСсылкуНаЭлементКлассификатора", ДанныеСтроки.ВозвращатьСсылкуНаЭлементКлассификатора);
		
		ОткрытьФорму("РегистрСведений.КодыТНВЭДИСМП.Форма.ФормаСписка", ПараметрыФормы, Владелец,,,, Описание);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаУправляемогоПриложения - форма-владелец.
//  Реквизиты     - Структура        - (См. ИнтеграцияИСМПКлиентСервер.РеквизитыСозданияКонтрагента)
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	//++ НЕ ГОСИС
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                     Реквизиты.ИНН);
	Основание.Вставить("КПП",                     Реквизиты.КПП);
	Основание.Вставить("Наименование",            СокрЛП(Реквизиты.Наименование));
	Основание.Вставить("СокращенноеНаименование", СокрЛП(Реквизиты.НаименованиеПолное));
	Основание.Вставить("ЮридическийАдрес",        Реквизиты.ЮридическийАдрес);
	
	ПравовыеФормы = Новый Соответствие;
	ПравовыеФормы.Вставить("Общество с ограниченной ответственностью", "ООО");
	ПравовыеФормы.Вставить("Закрытое акционерное общество", "ЗАО");
	ПравовыеФормы.Вставить("Открытое акционерное общество", "ОАО");
	ПравовыеФормы.Вставить("Публичное акционерное общество", "ПАО");
	ПравовыеФормы.Вставить("Акционерное общество", "АО");
	
	Если НЕ ЗначениеЗаполнено(Основание.СокращенноеНаименование) 
		ИЛИ НЕ ЗначениеЗаполнено(СтрЗаменить(Основание.СокращенноеНаименование, "-", "")) 
		ИЛИ ВРег(Основание.СокращенноеНаименование) = "НЕТ" Тогда
		Основание.СокращенноеНаименование = Основание.Наименование;
	КонецЕсли;
	
	Для каждого ПравоваяФорма Из ПравовыеФормы Цикл
		
		Поз = СтрНайти(ВРег(Основание.Наименование), ВРег(ПравоваяФорма.Ключ));
		Если Поз > 0 Тогда
			Основание.Наименование = СокрЛП(
				Лев(Основание.Наименование, Поз - 1)
				+ Сред(Основание.Наименование, Поз + СтрДлина(ПравоваяФорма.Ключ) + 1)
				 + " " + ПравоваяФорма.Значение);
		КонецЕсли;
		
		Поз = СтрНайти(ВРег(Основание.СокращенноеНаименование), ВРег(ПравоваяФорма.Ключ));
		Если Поз > 0 Тогда
			Основание.СокращенноеНаименование = СокрЛП(
				ПравоваяФорма.Значение + " " + 
				Лев(Основание.СокращенноеНаименование, Поз - 1)
				+ Сред(Основание.СокращенноеНаименование, Поз + СтрДлина(ПравоваяФорма.Ключ) + 1));
		КонецЕсли;
		
	КонецЦикла;
	
	Поз = СтрНайти(Основание.Наименование, """");
	Если Поз > 0 И Поз <= 10 Тогда
		Основание.Наименование = СокрП(Сред(Основание.Наименование, Поз)) + " " + СокрП(Лев(Основание.Наименование, Поз-1));
		Основание.Наименование = СтрЗаменить(Основание.Наименование, """", "");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Основание", Основание);
	ПараметрыФормы.Вставить("ВернутьСсылкуНаКонтрагента", Истина);
	
	ОткрытьФорму(ПартнерыИКонтрагентыВызовСервера.ИмяФормыСозданияКонтрагента(), ПараметрыФормы, ФормаВладелец);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти