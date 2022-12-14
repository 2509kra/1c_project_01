#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетФактураКомиссионеру") Тогда
		// Это исправление счета-фактуры
		ЗаполнитьПоСчетуФактуреОснованию(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
			ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Дата") Тогда
			Дата = ДанныеЗаполнения.Дата;
		КонецЕсли;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ЗначениеЗаполнено(ДокументОснование) И НЕ ЗначениеЗаполнено(Дата) Тогда
		
		ДатаДокументаОснования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Дата");
		Дата = ?(ДатаДокументаОснования = КонецДня(ДатаДокументаОснования), ДатаДокументаОснования, ДатаДокументаОснования + 1);
		
	КонецЕсли; 
	
	Если ЭтоНовый() Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	Сводный = (Покупатели.Количество() > 1); 
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		РучнаяКорректировкаЖурналаСФ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.СчетФактураКомиссионеру.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДокументОснование)
		И НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Проведен") Тогда
		
		ТекстСообщения = НСтр("ru = 'Счет-фактуру можно провести только на основании проведенного документа.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"ДокументОснование",
			, // ПутьКДанным 
			Отказ);
	
	КонецЕсли;
	
	Если Организация = Комиссионер Тогда
		
		ТекстСообщения = НСтр("ru = 'Комиссионер не должен совпадать с организацией.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"Комиссионер",
			, // ПутьКДанным 
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетФактураОснование");
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("Покупатель");
	КлючевыеРеквизиты.Добавить("НомерСчетаФактуры");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "Покупатели", КлючевыеРеквизиты, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетыКомиссионеров = Новый Массив;
	ОтчетыКомиссионеров.Добавить(ЭтотОбъект.ДокументОснование);
	РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ОбновитьСостояние(ОтчетыКомиссионеров);
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Если Исправление Тогда
		
		// Установка номера по исходному документу.
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсходныеДокументы.Номер КАК Номер,
		|	ЕСТЬNULL(Исправления.НомерИсправления, 0) КАК НомерИсправления
		|ИЗ
		|	Документ.СчетФактураКомиссионеру КАК ИсходныеДокументы
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ 
		|		Документ.СчетФактураКомиссионеру КАК Исправления
		|	ПО 
		|		Исправления.ДокументОснование = ИсходныеДокументы.ДокументОснование
		|		И Исправления.Проведен
		|		И Исправления.Исправление
		|ГДЕ
		|	ИсходныеДокументы.Ссылка = &СчетФактураОснование
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерИсправления УБЫВ
		|";
		
		Запрос.УстановитьПараметр("Основание", ДокументОснование);
		Запрос.УстановитьПараметр("СчетФактураОснование", СчетФактураОснование);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			СтандартнаяОбработка = Ложь;
			
			// Установка номера и переопределение префикса информационной базы.
			Префикс = "И";
			ПрефиксацияОбъектовСобытия.УстановитьПрефиксИнформационнойБазыИОрганизации(ЭтотОбъект, СтандартнаяОбработка, Префикс);
			
			НомерБезПрефикса = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(Выборка.Номер, Истина, Истина);
			Если СтрДлина(СокрП(НомерБезПрефикса)) = 7 Тогда
				НомерБезПрефикса = Прав(НомерБезПрефикса, СтрДлина(НомерБезПрефикса)-1);
			КонецЕсли;
			Номер = Префикс + НомерБезПрефикса;
			
			НомерИсправления = Формат(Число(Выборка.НомерИсправления)+1, "ЧЦ=10; ЧДЦ=0; ЧГ=0");
			
		КонецЕсли;
		
	Иначе
		
		Префикс = "0";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Валюта") Тогда
		Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("КодВидаОперации") Тогда
		КодВидаОперации = КодВидаОперации();
	КонецЕсли;
	
КонецПроцедуры

Функция КодВидаОперации() Экспорт
	
	ВерсияКодовВидовОпераций = УчетНДСКлиентСервер.ВерсияКодовВидовОпераций(Дата);
	КодВидаОперации = ?(ВерсияКодовВидовОпераций >= 3, "01", "04");
	
	Если Покупатели.Количество() > 1 Тогда
		КодВидаОперации = "27";
	ИначеЕсли Покупатели.Количество() = 1 
		И Покупатели[0].Покупатель = Справочники.Контрагенты.РозничныйПокупатель Тогда
		КодВидаОперации = "26";
	КонецЕсли;
	
	Возврат КодВидаОперации;
	
КонецФункции

Процедура ЗаполнитьПоСчетуФактуреОснованию(СчетФактураОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА КАК Исправление,
	|	ВЫБОР 
	|		КОГДА СчетФактураКомиссионеру.Исправление 
	|			ТОГДА СчетФактураКомиссионеру.СчетФактураОснование
	|		ИНАЧЕ СчетФактураКомиссионеру.Ссылка
	|	КОНЕЦ КАК СчетФактураОснование,
	|	СчетФактураКомиссионеру.ДокументОснование КАК ДокументОснование,
	|	СчетФактураКомиссионеру.Организация КАК Организация,
	|	СчетФактураКомиссионеру.Комиссионер КАК Комиссионер,
	|	СчетФактураКомиссионеру.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	СчетФактураКомиссионеру.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СчетФактураКомиссионеру.Контрагент КАК Контрагент,
	|	СчетФактураКомиссионеру.Партнер КАК Партнер,
	|	СчетФактураКомиссионеру.Договор КАК Договор,
	|	СчетФактураКомиссионеру.КодВидаОперации КАК КодВидаОперации,
	|	СчетФактураКомиссионеру.Валюта КАК Валюта
	|ИЗ
	|	Документ.СчетФактураКомиссионеру КАК СчетФактураКомиссионеру
	|ГДЕ
	|	СчетФактураКомиссионеру.Ссылка = &Ссылка
	|;
	|/////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	Покупатели.Покупатель КАК Покупатель,
	|	Покупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	Покупатели.КПППокупателя КАК КПППокупателя,
	|	Покупатели.ИННПокупателя КАК ИННПокупателя
	|ИЗ
	|	Документ.СчетФактураКомиссионеру.Покупатели КАК Покупатели
	|ГДЕ
	|	Покупатели.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", СчетФактураОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	ЭтотОбъект.Покупатели.Загрузить(РезультатЗапроса[1].Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)
	
	ПараметрыСчетаФактуры = ПолучитьПараметрыСчетаФактурыПоОснованиям(ДанныеЗаполнения);
	
	Если Не ПараметрыСчетаФактуры.ХозяйственнаяОперация = Неопределено Тогда
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ПараметрыСчетаФактуры.ХозяйственнаяОперация);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Подразделение = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Подразделение", ПараметрыСчетаФактуры.Подразделение);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Партнер = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Партнер", ПараметрыСчетаФактуры.Партнер);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Контрагент = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Контрагент", ПараметрыСчетаФактуры.Контрагент);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Договор = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Договор", ПараметрыСчетаФактуры.Договор);
	КонецЕсли;
		
	Если Не ПараметрыСчетаФактуры.НаправлениеДеятельности = Неопределено Тогда
		ДанныеЗаполнения.Вставить("НаправлениеДеятельности", ПараметрыСчетаФактуры.НаправлениеДеятельности);
	КонецЕсли;
	
КонецПроцедуры

// Определяет реквизиты счета-фактуры на основании выбранных документов-оснований
//
// Возвращаемое значение:
//	Структура - реквизиты счета-фактуры.
//
Функция ПолучитьПараметрыСчетаФактурыПоОснованиям(ДанныеЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("ХозяйственнаяОперация, НаправлениеДеятельности,
		|Контрагент, Партнер, Договор, Подразделение, Ответственный");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеОснования.Подразделение,
	|	ДанныеОснования.НаправлениеДеятельности,
	|	ДанныеОснования.Контрагент,
	|	ДанныеОснования.Партнер,
	|	ДанныеОснования.Договор,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ДанныеОснования
	|ГДЕ
	|	ДанныеОснования.Ссылка = &ДокументОснование";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения.ДокументОснование);
	
	Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Документ.ОтчетКомиссионера", "Документ.ОтчетПоКомиссииМеждуОрганизациями");
	Иначе
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОтчетКомиссионера);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Результат.Ответственный = Пользователи.ТекущийПользователь();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
