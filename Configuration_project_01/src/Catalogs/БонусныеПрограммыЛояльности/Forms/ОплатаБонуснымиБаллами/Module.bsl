
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыборкаБонуснаяПрограммаЛояльности = БонусныеБаллыСервер.БонуснаяПрограммаКартыЛояльности(Параметры.КартаЛояльности);
	БонуснаяПрограммаЛояльности = ВыборкаБонуснаяПрограммаЛояльности.БонуснаяПрограммаЛояльности;
	Партнер                     = Параметры.Партнер;
	
	ВалютаДокумента         = Параметры.Валюта;
	ВалютаБонуснойПрограммы = ВыборкаБонуснаяПрограммаЛояльности.Валюта;
	
	СтруктураКурсовВалютыДокумента         = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента,         ТекущаяДатаСеанса());
	СтруктураКурсовВалютыБонуснойПрограммы = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаБонуснойПрограммы, ТекущаяДатаСеанса());
	КурсКонвертацииБонусовВВалюту          = ВыборкаБонуснаяПрограммаЛояльности.КурсКонвертацииБонусовВВалюту;

	// Расчет максимальной суммы оплаты бонусами
	ТабличнаяЧастьТовары = ПолучитьИзВременногоХранилища(Параметры.АдресТабличнойЧастиТовары);
	ТабличнаяЧастьТовары.Колонки.Добавить("МаксимальнаяСуммаОплаты", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	ТабличнаяЧастьТовары.Колонки.Добавить("МаксимальнаяСуммаОплатыВБаллах", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.КлючСвязи КАК КлючСвязи,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Цена КАК ЦенаЗаУпаковку,
	|	Товары.ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки
	|ПОМЕСТИТЬ ВременнаяТаблицаТовары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.КлючСвязи КАК КлючСвязи,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ЕСТЬNULL(ЕСТЬNULL(ТабличнаяЧастьЦеновыеГруппы.МаксимальныйПроцентОплатыБонусами, БонусныеПрограммыЛояльности.МаксимальныйПроцентОплатыБонусами), 0) КАК МаксимальныйПроцентОплатыБонусами,
	|	Товары.КоличествоУпаковок * Товары.ЦенаЗаУпаковку КАК Сумма,
	|	Товары.ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|	ВЫБОР КОГДА БонусныеПрограммыЛояльности.СегментНоменклатуры <> ЗНАЧЕНИЕ(Справочник.СегментыНоменклатуры.ПустаяСсылка) ТОГДА
	|		ВЫБОР КОГДА НоменклатураСегмента.Сегмент = БонусныеПрограммыЛояльности.СегментНоменклатуры ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК ВходитВДоступныйСегмент
	|ИЗ
	|	ВременнаяТаблицаТовары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БонусныеПрограммыЛояльности.ЦеновыеГруппы КАК ТабличнаяЧастьЦеновыеГруппы
	|		ПО (ТабличнаяЧастьЦеновыеГруппы.Ссылка = &БонуснаяПрограммаЛояльности)
	|			И (ТабличнаяЧастьЦеновыеГруппы.ЦеноваяГруппа = Товары.Номенклатура.ЦеноваяГруппа)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БонусныеПрограммыЛояльности КАК БонусныеПрограммыЛояльности
	|		ПО (БонусныеПрограммыЛояльности.Ссылка = &БонуснаяПрограммаЛояльности)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	|		ПО Товары.Номенклатура = НоменклатураСегмента.Номенклатура
	|			И Товары.Характеристика = НоменклатураСегмента.Характеристика
	|			И НоменклатураСегмента.Сегмент = БонусныеПрограммыЛояльности.СегментНоменклатуры
	|");
	
	Запрос.УстановитьПараметр("Товары", ТабличнаяЧастьТовары);
	Запрос.УстановитьПараметр("БонуснаяПрограммаЛояльности", БонуснаяПрограммаЛояльности);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.МаксимальныйПроцентОплатыБонусами > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не Выборка.ВходитВДоступныйСегмент Тогда
			Продолжить;
		КонецЕсли;
		
		Если Выборка.ПроцентАвтоматическойСкидки > Выборка.МаксимальныйПроцентОплатыБонусами Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЧ = ТабличнаяЧастьТовары.Найти(Выборка.НомерСтроки, "НомерСтроки");
		
		СтрокаТЧ.МаксимальнаяСуммаОплаты = ((Выборка.МаксимальныйПроцентОплатыБонусами - Выборка.ПроцентАвтоматическойСкидки) / 100) * Выборка.Сумма;
		
		СтрокаТЧ.МаксимальнаяСуммаОплатыВБаллах = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТЧ.МаксимальнаяСуммаОплаты,
			СтруктураКурсовВалютыДокумента,
			СтруктураКурсовВалютыБонуснойПрограммы) / КурсКонвертацииБонусовВВалюту;
		
	КонецЦикла;
	
	ОстаткиБонусныхБаллов.Загрузить(БонусныеБаллыСервер.ОстаткиИДвиженияБонусныхБаллов(БонуснаяПрограммаЛояльности, Параметры.Партнер));
	НачальныйОстатокВБаллах = ОстаткиБонусныхБаллов[0].Сумма;
	
	НачальныйОстаток = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		НачальныйОстатокВБаллах * КурсКонвертацииБонусовВВалюту,
		СтруктураКурсовВалютыБонуснойПрограммы,
		СтруктураКурсовВалютыДокумента);
	
	МаксимальнаяСуммаОплаты        = Мин(ТабличнаяЧастьТовары.Итог("МаксимальнаяСуммаОплаты"), НачальныйОстаток);
	МаксимальнаяСуммаОплатыВБаллах = Мин(ТабличнаяЧастьТовары.Итог("МаксимальнаяСуммаОплатыВБаллах"), НачальныйОстатокВБаллах);
	
	ОписаниеМаксимальнаяСуммаОплаты = НСтр("ru = 'Максимальная сумма оплаты составляет %1 %2 или %3'");
	ОписаниеМаксимальнаяСуммаОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ОписаниеМаксимальнаяСуммаОплаты,
		МаксимальнаяСуммаОплаты,
		ВалютаДокумента,
		СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			МаксимальнаяСуммаОплатыВБаллах,
			НСтр("ru = 'балл, балла, баллов'")));
	
	Элементы.СуммаОплаты.МаксимальноеЗначение = МаксимальнаяСуммаОплаты;
	Элементы.СуммаОплатыВБаллах.МаксимальноеЗначение = МаксимальнаяСуммаОплатыВБаллах;
	
	Если МаксимальнаяСуммаОплаты = 0 Тогда
		Элементы.СуммаОплаты.Доступность = Ложь;
		Элементы.СуммаОплатыВБаллах.Доступность = Ложь;
		Элементы.ФормаОплатитьБаллами.Доступность = Ложь;
	КонецЕсли;
	
	СуммаОплаты        = МаксимальнаяСуммаОплаты;
	СуммаОплатыВБаллах = МаксимальнаяСуммаОплатыВБаллах;
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ТабличнаяЧастьТовары, УникальныйИдентификатор);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаОплатыПриИзменении(Элемент)
	
	СуммаОплатыВБаллах = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		СуммаОплаты,
		СтруктураКурсовВалютыДокумента,
		СтруктураКурсовВалютыБонуснойПрограммы) / КурсКонвертацииБонусовВВалюту;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаОплатыВБаллахПриИзменении(Элемент)
	
	СуммаОплаты = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		СуммаОплатыВБаллах * КурсКонвертацииБонусовВВалюту,
		СтруктураКурсовВалютыБонуснойПрограммы,
		СтруктураКурсовВалютыДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОплатитьБаллами(Команда)
	
	ПараметрыДанных = Новый Структура;
	ПараметрыДанных.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище(ВладелецФормы.УникальныйИдентификатор));
	
	Закрыть(ПараметрыДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресВоВременномХранилище(УникальныйИдентификаторВладельцаФормы)
	
	СтрокиТабличнойЧасти = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	СуммаКРаспределению = СуммаОплатыВБаллах;
	
	МаксимальнаяСуммаОплатыВБаллах = СтрокиТабличнойЧасти.Итог("МаксимальнаяСуммаОплатыВБаллах");
	
	Для каждого СтрокаТЧ Из СтрокиТабличнойЧасти Цикл
		
		Если МаксимальнаяСуммаОплатыВБаллах <= 0 Тогда
			Прервать;
		КонецЕсли;
		
		СтрокаТЧ.СуммаБонусныхБалловКСписанию = СтрокаТЧ.МаксимальнаяСуммаОплатыВБаллах * (СуммаКРаспределению / МаксимальнаяСуммаОплатыВБаллах);
		
		СтрокаТЧ.СуммаБонусныхБалловКСписаниюВВалюте = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТЧ.СуммаБонусныхБалловКСписанию * КурсКонвертацииБонусовВВалюту,
			СтруктураКурсовВалютыБонуснойПрограммы,
			СтруктураКурсовВалютыДокумента);
		
		СуммаКРаспределению = СуммаКРаспределению - СтрокаТЧ.СуммаБонусныхБалловКСписанию;
		МаксимальнаяСуммаОплатыВБаллах = МаксимальнаяСуммаОплатыВБаллах - СтрокаТЧ.МаксимальнаяСуммаОплатыВБаллах;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(СтрокиТабличнойЧасти, УникальныйИдентификаторВладельцаФормы);
	
КонецФункции

#КонецОбласти
