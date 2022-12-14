#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	ВалютаВзаиморасчетов = УсловияЗакупок.ВалютаВзаиморасчетов;
	НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Склад) Тогда
		Склад = УсловияЗакупок.Склад;
		СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
		Если СтруктураОтветственного <> Неопределено Тогда
			Принял = СтруктураОтветственного.Ответственный;
			ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		
		ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
		ДопПараметры.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
			ЭтотОбъект,
			Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика,
			ДопПараметры);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов) 
		ИЛИ НЕ УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокОплаты = УсловияЗакупок.ПорядокОплаты;
	Иначе
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокОплаты");
	КонецЕсли;
	
	ФормаОплаты = УсловияЗакупок.ФормаОплаты;
	
	ЗначениеДатыПлатежа = ЗакупкиСервер.ПолучитьПоследнююДатуПоГрафику(Дата, УсловияЗакупок.Соглашение);
	Если ЗначениеЗаполнено(ЗначениеДатыПлатежа) Тогда
		ДатаПлатежа = ЗначениеДатыПлатежа;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЦенаВключаетНДС         = УсловияЗакупок.ЦенаВключаетНДС;
	ПредусмотренЗалогЗаТару = УсловияЗакупок.ТребуетсяЗалогЗаТару;
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа.
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию(ПересчитатьЦены = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			Новый Структура("ВыбранноеСоглашение", Соглашение));
		
		ЦеныЗаполнены = Ложь;
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
			
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
				ПараметрыЗаполнения = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
				УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
				
				Если ПересчитатьЦены И ЗначениеЗаполнено(Соглашение) Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					ПараметрыЗаполнения = Новый Структура;
					ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦеныПоставщика");
					ПараметрыЗаполнения.Вставить("Дата", Дата);
					ПараметрыЗаполнения.Вставить("Валюта", Валюта);
					ПараметрыЗаполнения.Вставить("Соглашение", Соглашение);
					ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
					СтруктураДействий = Новый Структура;
					СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуРучнойСкидки", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
					
					ЦеныЗаполнены = ЗакупкиСервер.ЗаполнитьЦены(
						Товары,
						Неопределено, // Массив строк
						ПараметрыЗаполнения,
						СтруктураДействий);
					
				КонецЕсли;
								
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в заказе поставщику
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа.
//
Процедура ЗаполнитьУсловияЗакупокПоСоглашению(ПересчитатьЦены = Истина) Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение, Истина, Истина);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	
	ПараметрыЗаполнения = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	Если ПересчитатьЦены Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦеныПоставщика");
		ПараметрыЗаполнения.Вставить("Дата", Дата);
		ПараметрыЗаполнения.Вставить("Валюта", Валюта);
		ПараметрыЗаполнения.Вставить("Соглашение", Соглашение);
		ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		
		ЗакупкиСервер.ЗаполнитьЦены(
			Товары,
			Неопределено, // Массив строк
			ПараметрыЗаполнения,
			СтруктураДействий);
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) ИЛИ
		 Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	Если ПредусмотренЗалогЗаТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаВзаиморасчетов");
	КонецЕсли;
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗакупкиСервер.ПроверитьКорректностьЗаполненияДокументаЗакупки(ЭтотОбъект,Отказ);
																		
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Перем СкладПоступления;
	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПринятойТаре") Тогда
			ЗаполнитьДокументНаОснованииПринятойТары(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент();
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	СтруктураКурса = РаботаСКурсамиВалютУТ.СтруктураКурсаВалюты(Курс,Кратность);
	
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВПоступлении(ЭтотОбъект, "Товары", СтруктураКурса);
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураКурса);
	ВзаиморасчетыСервер.ЗаполнитьСуммуНДСВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Товары");
	
	ПараметрыРегистрации = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если СуммаДокумента > 0 
			И НЕ ПредусмотренЗалогЗаТару
			И НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаВзаиморасчетов, РасшифровкаПлатежа);
		Иначе
			Если РасшифровкаПлатежа.Количество() <> 0 Тогда
				РасшифровкаПлатежа.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		НоменклатураПартнеровСервер.ЗаполнитьПустоеСопоставлениеВНоменклатуреПартнераПоНоменклатуреИБ(Товары, Отказ);
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ВыкупВозвратнойТарыУПоставщика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	МногооборотнаяТараСервер.ОтразитьПринятуюВозвратнуюТару(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	ВыкупВозвратнойТарыУПоставщикаЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ВыкупВозвратнойТарыУПоставщикаЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ДатаПлатежа     = Дата(1,1,1);
	Согласован      = Ложь;
	ВидЗапасов      = Неопределено;
	ДатаВходящегоДокумента = Дата(1,1,1);
	НомерВходящегоДокумента = "";
	
	РасшифровкаПлатежа.Очистить();
	
	ИнициализироватьДокумент();
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка ИЛИ ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Возврат;
	КонецЕсли;
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииПринятойТары(Знач РеквизитыЗаполнения)
	
	Если РеквизитыЗаполнения.РеквизитыШапки.Свойство("Соглашение", Соглашение) И ЗначениеЗаполнено(Соглашение) Тогда
		ЗаполнитьУсловияЗакупокПоСоглашению(Ложь);
	Иначе
		ЗаполнитьУсловияЗакупокПоУмолчанию(Ложь);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения.РеквизитыШапки);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		НалогообложениеНДС = Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.Реквизиты.НалогообложениеНДС.ЗначениеЗаполнения;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище) Тогда
		
		ПринятаяТара = ПолучитьИзВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище);
		Товары.Загрузить(ПринятаяТара);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", Новый Структура("НалогообложениеНДС, Дата", НалогообложениеНДС, Дата));
		
		Для каждого ТекущаяСтрока Из Товары Цикл
			
			ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
			ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
			
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
			Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПриобретениеТоваровУслуг.Ссылка                       КАК ДокументОснование,
		|	ПриобретениеТоваровУслуг.Валюта                       КАК Валюта,
		|	ПриобретениеТоваровУслуг.Партнер                      КАК Партнер,
		|	ПриобретениеТоваровУслуг.Соглашение                   КАК Соглашение,
		|	ПриобретениеТоваровУслуг.Организация                  КАК Организация,
		|	ПриобретениеТоваровУслуг.Контрагент                   КАК Контрагент,
		|	ПриобретениеТоваровУслуг.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
		|	ПриобретениеТоваровУслуг.НалогообложениеНДС           КАК НалогообложениеНДС,
		|	ПриобретениеТоваровУслуг.ВалютаВзаиморасчетов         КАК ВалютаВзаиморасчетов,
		|	ПриобретениеТоваровУслуг.ФормаОплаты                  КАК ФормаОплаты,
		|	ПриобретениеТоваровУслуг.ТребуетсяЗалогЗаТару         КАК ПредусмотренЗалогЗаТару,
		|	ПриобретениеТоваровУслуг.ПорядокРасчетов              КАК ПорядокРасчетов,
		|	НЕ ПриобретениеТоваровУслуг.Проведен                  КАК ЕстьОшибкиПроведен,
		|	НЕ ПриобретениеТоваровУслуг.ВернутьМногооборотнуюТару КАК ЕстьОшибкиВернутьМногооборотнуюТару,
		|	ПриобретениеТоваровУслуг.НаправлениеДеятельности      КАК НаправлениеДеятельности,
		|	ПриобретениеТоваровУслуг.ПорядокОплаты                КАК ПорядокОплаты
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
		|ГДЕ
		|	ПриобретениеТоваровУслуг.Ссылка = &ДокументОснование
		|;
		|ВЫБРАТЬ
		|	ПринятаяВозвратнаяТараОстатки.Номенклатура        КАК Номенклатура,
		|	ПринятаяВозвратнаяТараОстатки.Характеристика      КАК Характеристика,
		|	ПринятаяВозвратнаяТараОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ПринятаяВозвратнаяТараОстатки.СуммаОстаток        КАК Сумма,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК Количество,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК КоличествоУпаковок
		|ИЗ
		|	РегистрНакопления.ПринятаяВозвратнаяТара.Остатки(, ДокументПоступления = &ДокументОснование) КАК ПринятаяВозвратнаяТараОстатки
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	УстановитьПривилегированныйРежим(Истина);
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = ПакетЗапросов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииВыкупаТары(
		ДокументОснование,
		ВыборкаШапка.ЕстьОшибкиПроведен,
		ВыборкаШапка.ЕстьОшибкиВернутьМногооборотнуюТару);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(ПакетЗапросов[1].Выгрузить());
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", Новый Структура("НалогообложениеНДС, Дата", НалогообложениеНДС, Дата));
	
	Для каждого ТекущаяСтрока Из Товары Цикл
		
		ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
		ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
		Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияЗакупокПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент()
	
	Менеджер                  = Пользователи.ТекущийПользователь();
	Валюта                    = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	ВалютаВзаиморасчетов      = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаВзаиморасчетов);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение             = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);
	
	ПараметрыЗаполнения = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	ПорядокОплаты   = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов,НалогообложениеНДС,ВалютаВзаиморасчетов);
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ПринятаяВозвратнаяТара);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
