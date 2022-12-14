#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС 
		 ИЛИ НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Расходы.СтавкаНДС");
	КонецЕсли;
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ПриобретениеУслугПрочихАктивов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если МассивНепроверяемыхРеквизитов.Найти("Расходы.АналитикаРасходов") = Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, Новый Структура("Расходы"), МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
		МассивНепроверяемыхРеквизитов.Добавить("Расходы.НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	
	ПараметрыПроверки = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыПроверкиЗаполнениеДокументаПоНалогообложениюНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ПроверитьЗаполнениеДокументаЗакупкиПоНалогообложениюНДС(ЭтотОбъект, НалогообложениеНДС, ПараметрыПроверки, Отказ);
	
	ПараметрыПроверки = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыПроверкиЗаполненияДокументаПоВидуДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ПроверитьЗаполнениеДокументаПоВидуДеятельностиНДС(ЭтотОбъект, ЗакупкаПодДеятельность, ПараметрыПроверки, Отказ);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПриобретениеУслугПрочихАктивовЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	
	ПараметрыЗаполнения = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	ПараметрыЗаполнения = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ЗакупкаПодДеятельность, ПараметрыЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ПриобретениеУслугПрочихАктивовЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЕстьКорректировки = Ложь;
		ЗакупкиСервер.ПроверитьНаличиеКорректировокИСчетовФактур(Ссылка, Ссылка, ЕстьКорректировки, Неопределено);
		Если ЕстьКорректировки Тогда
			ЗакупкиСервер.СообщитьОбОшибкахОтменаПроведенияЕстьКорректировки(Ссылка,Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Расходы, ЦенаВключаетНДС);
	
	СтруктураКурса = РаботаСКурсамиВалютУТ.СтруктураКурсаВалюты(Курс, Кратность);
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВПоступлении(ЭтотОбъект, "Расходы", СтруктураКурса);
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Расходы", СтруктураКурса);
	ВзаиморасчетыСервер.ЗаполнитьСуммуНДСВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Расходы");
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если СуммаДокумента > 0 И НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаВзаиморасчетов, РасшифровкаПлатежа);
		Иначе
			Если РасшифровкаПлатежа.Количество() <> 0 Тогда
				РасшифровкаПлатежа.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Расходы);
	КонецЕсли;
	
	ПараметрыРегистрации = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(Расходы, "СтатьяРасходов");
	
	ПриобретениеУслугПрочихАктивовЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ПриобретениеУслугПрочихАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПриобретениеУслугПрочихАктивовЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	
	ПриобретениеУслугПрочихАктивовЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();
	
	ДатаПлатежа				= Дата(1,1,1);
	ДатаВходящегоДокумента	= Дата(1,1,1);
	НомерВходящегоДокумента	= "";
	
	РасшифровкаПлатежа.Очистить();
	
	ПараметрыЗаполнения = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	ПараметрыЗаполнения = Документы.ПриобретениеУслугПрочихАктивов.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ЗакупкаПодДеятельность, ПараметрыЗаполнения);
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьЗначенияСвойствКоллекции(Расходы, 0, "СуммаВзаиморасчетов");
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Расходы);
	
	ПриобретениеУслугПрочихАктивовЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СписокРегистров = "РеестрДокументов";
		
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ПриобретениеУслугПрочихАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, СписокРегистров);
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	ПриобретениеУслугПрочихАктивовЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Заполняет условия закупок в документе.
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта               = УсловияЗакупок.Валюта;
	ВалютаВзаиморасчетов = УсловияЗакупок.ВалютаВзаиморасчетов;
	НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    			= Организация;
		СтруктураПараметров.НаправлениеДеятельности	= НаправлениеДеятельности;
		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда

		ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
		ДопПараметры.ВалютаВзаиморасчетов = Валюта;
		ДопПараметры.Налогообложение = НалогообложениеНДС;
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперация, ДопПараметры);
	
		ЗакупкиВызовСервера.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации);
		
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
	
	ЗначениеДатыПлатежа = ЗакупкиСервер.ПолучитьПоследнююДатуПоГрафику(Дата, УсловияЗакупок.Соглашение);
	Если ЗначениеЗаполнено(ЗначениеДатыПлатежа) Тогда
		ДатаПлатежа = ЗначениеДатыПлатежа;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЦенаВключаетНДС      = УсловияЗакупок.ЦенаВключаетНДС;
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком.
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить("УчитыватьГруппыСкладов", Истина);
		ПараметрыОтбора.Вставить("ИсключитьГруппыСкладовДоступныеВЗаказах", Истина);
		ПараметрыОтбора.Вставить("ХозяйственныеОперации", Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение", Соглашение);
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			ПараметрыОтбора);
			
		ЦеныЗаполнены = Ложь;
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			Соглашение = Неопределено;
		КонецЕсли;
		
		КонтрагентДоЗаполнения = Контрагент;
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		Если КонтрагентДоЗаполнения <> Контрагент Тогда
			БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер = Пользователи.ТекущийПользователь();
	
	Валюта                    = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ВалютаВзаиморасчетов      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение             = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Организация;
	СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	ПорядокРасчетов           = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ДатаПлатежа = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(Расходы, "СтатьяРасходов");
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
	ВалютаОплаты  = ДенежныеСредстваСервер.ПолучитьВалютуОплаты(ФормаОплаты, БанковскийСчетОрганизации);
	ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов,НалогообложениеНДС,ВалютаОплаты);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);

КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
