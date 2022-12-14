#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(ЭтотОбъект.Метаданные(), ЭтотОбъект.Отбор);
	
	Запрос = Новый Запрос;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
	СФормироватьТаблицуОбъектовОплаты();
	РегистрыСведений.ГрафикПлатежей.УстановитьБлокировкиДанныхДляРасчетаГрафика(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты, "РегистрНакопления.РасчетыПоФинансовымИнструментам", "Договор");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу для последующей записи в регистрах заданий.
	Запрос = Новый Запрос;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);	
	Запрос.УстановитьПараметр("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	
	Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов() +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ТаблицаИзменений.Регистратор КАК Документ,
	|	Аналитика.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ПереоценкаДенежныхСредствИФинансовыхИнструментов) КАК Операция
	|ПОМЕСТИТЬ РасчетыПоФинансовымИнструментамЗаданияКЗакрытиюМесяца
	|ИЗ
	|	ТаблицаИзмененийРасчетыПоФинансовымИнструментам КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|		ПО ТаблицаИзменений.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
	|ГДЕ
	|	(ТИПЗНАЧЕНИЯ(ТаблицаИзменений.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
	|			ИЛИ ТаблицаИзменений.Договор.ВалютаВзаиморасчетов <> &ВалютаУпр
	|			ИЛИ ТаблицаИзменений.Договор.ВалютаВзаиморасчетов <> &ВалютаРегл)
	|	И (ТаблицаИзменений.Сумма <> 0
	|		ИЛИ ТаблицаИзменений.СуммаУпр <> 0
	|		ИЛИ ТаблицаИзменений.СуммаРегл <> 0)";
	
	Запрос.Выполнить();
	
	
	// Уничтожаем таблицу изменений регистра:
	РасчетСебестоимостиПрикладныеАлгоритмы.УничтожитьВременныеТаблицы(Запрос, "ТаблицаИзмененийРасчетыПоФинансовымИнструментам");

	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоФинансовымИнструментам(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты.ВыгрузитьКолонку("ОбъектОплаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу заказов, которые были раньше в движениях и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуОбъектовОплаты()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Договор КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И Таблица.Договор <> НЕОПРЕДЕЛЕНО
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = Выгрузить(, "Договор");
	ТаблицаНовыхОбъектовОплаты.Свернуть("Договор");
	Для Каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		Если Не ЗначениеЗаполнено(Запись.Договор) Тогда
			Продолжить;
		КонецЕсли;
		Если ТаблицаОбъектовОплаты.Найти(Запись.Договор, "ОбъектОплаты") = Неопределено Тогда
			ТаблицаОбъектовОплаты.Добавить().ОбъектОплаты = Запись.Договор;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли