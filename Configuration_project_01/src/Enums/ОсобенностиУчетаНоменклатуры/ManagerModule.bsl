#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает текст подсказки по особенностям учета номенклатуры.
//
// Параметры:
//	ОсобенностьУчета - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры	 - особенность учета номенклатуры.
//
// Возвращаемое значение:
//	Строка - подсказка по особенности учета номенклатуры.
//
Функция ПодсказкаПоОсобенностиУчетаНоменклатуры(ОсобенностьУчета) Экспорт
	
	Если ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.БезОсобенностейУчета Тогда
		Возврат "";
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция Тогда
		Возврат НСтр("ru = 'Формируются декларации по алкогольной продукции и осуществляется обмен с ЕГАИС информацией по обороту.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС Тогда
		Возврат НСтр("ru='Осуществляется обмен с ВетИС информацией по обороту продукции животного происхождения.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.СодержитДрагоценныеМатериалы Тогда
		Возврат НСтр("ru = 'Статистическая отчетность по содержанию драгоценных материалов.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ Тогда
		Возврат НСтр("ru = 'Продукция маркируется специальными контрольными идентификационными знаками (КиЗ) и осуществляется обмен с ГИСМ (информационной системой маркировки товаров) информацией по обороту.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ Тогда
		Возврат НСтр("ru = 'Контрольные идентификационные знаки (КИЗ), которыми маркируется продукция, учитываемая в ГИСМ (информационной системе маркировки товаров).'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПродавцом Тогда
		Возврат НСтр("ru = 'Услуга выполняется собственной организацией, продается ей же.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме Тогда
		Возврат НСтр("ru = 'Услуга выполняется собственной организацией (принципалом), продается по агентскому договору.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером Тогда
		Возврат НСтр("ru = 'Услуга выполняется сторонним исполнителем (принципалом), продается по агентскому договору.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МОТП информацией по обороту табачной продукции.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОбувнаяПродукция Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту обувной продукции.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ЛегкаяПромышленность Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту товаров легкой промышленности и одежды.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП и ВетИС информацией по обороту молока и молочной продукции.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияБезВЕТИС Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту молока и молочной продукции.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Шины Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту шин и автопокрышек.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Фотоаппараты Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту фотоаппаратов и ламп-вспышек.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Велосипеды Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту велосипедов и велосипедных рам.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.КреслаКоляски Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту кресла-колясок.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Духи Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту духов и туалетной воды.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АльтернативныйТабак Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту альтернативного табака.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.УпакованнаяВода Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МП информацией по обороту упакованной воды.'");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Связь особенностей учета и функциональных опций. Если связь не указана, то особенность учета по умолчанию скрывается.
//
// Возвращаемое значение:
//	Соответствие: Ключ - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры.
//					Значение - Строка - имена функциональных опций через запятую, значения опций объединяются по И.
//
Функция СвязьОсобенностейУчетаИФО() Экспорт
	
	СвязьОсобенностейУчетаИФО = Новый Соответствие;
	
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПродавцом, "ИспользоватьПродажуАгентскихУслуг");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме, "ИспользоватьПродажуАгентскихУслуг,ИспользоватьНесколькоОрганизаций");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.Партнером, "ИспользоватьПродажуАгентскихУслуг");
	
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция, "ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.СодержитДрагоценныеМатериалы, "ИспользоватьУчетДрагоценныхМатериалов");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ, "ВестиУчетМаркировкиПродукцииВГИСМ");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ, "ВестиУчетМаркировкиПродукцииВГИСМ");
	СвязьОсобенностейУчетаИФО.Вставить(Перечисления.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС, "ВестиУчетПодконтрольныхТоваровВЕТИС");
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидПродукции КАК ВидПродукции
		|ИЗ
		|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП
		|ГДЕ
		|	ВестиУчетПродукции";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ОсобенностьУчета = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(Выборка.ВидПродукции);
			Если ЗначениеЗаполнено(ОсобенностьУчета) Тогда
				СвязьОсобенностейУчетаИФО.Вставить(ОсобенностьУчета, "ВестиУчетМаркируемойПродукцииИСМП");
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СвязьОсобенностейУчетаИФО;
	
КонецФункции

#КонецОбласти

#КонецЕсли

