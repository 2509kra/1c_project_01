
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.КоммерческоеПредложениеПоставщика) Тогда
		
		ВызватьИсключение(НСтр("ru = 'Не указано документ, для которого требуется сформировать отчет.'"));
		
	КонецЕсли;
	
	КоммерческоеПредложениеПоставщика = Параметры.КоммерческоеПредложениеПоставщика;
	ТипИнформации                     = Параметры.ТипИнформации;
	
	Если ТипИнформации = "НеПолностьюЗакрытыеПозиции" Тогда
		
		Заголовок = НСтр("ru = 'Позиции, закрытые не полностью.'");
		СформироватьОтчетНеПолностьюЗакрытыеПозиции();
		
	ИначеЕсли ТипИнформации = "НеохваченныеПозиции" Тогда
		
		Заголовок = НСтр("ru = 'Позиции запроса, по которым не поступило предложений.'");
		СформироватьОтчетНеОхваченныеПозиции();
		
	Иначе
		
		ВызватьИсключение(НСтр("ru = 'Некорректно указан тип отчета.'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчетНеОхваченныеПозиции()

	ДанныеДляОтчета = ДанныеПоНеОхваченнымПозициям();
	
	Макет = Документы.КоммерческоеПредложениеПоставщика.ПолучитьМакет("НеОхваченныеПозицииПоЗапросу");
	
	ОбластьШапка                  = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовокСтрокПоставки = Макет.ПолучитьОбласть("ЗаголовокСрокПоставки");
	ОбластьСтрока                 = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрокаСрокПоставки     = Макет.ПолучитьОбласть("СтрокаСрокПоставки");
	ОбластьПустаяСтрока           = Макет.ПолучитьОбласть("ПустаяСтрока");
	
	ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьПустаяСтрока, "ПустаяСтрока");
	ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьШапка, "Шапка");
	
	ЗаголовокСрокПоставки = КоммерческиеПредложенияДокументыКлиентСервер.ЗаголовокСрокПоставки(ДанныеДляОтчета.ВариантУказанияСрокаПоставки); 

	Если ДанныеДляОтчета.ВариантУказанияСрокаПоставки <> Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается Тогда 
		ОбластьЗаголовокСтрокПоставки.Параметры.ЗаголовокСрокПоставки = ЗаголовокСрокПоставки;
		ТабличныйДокумент.Присоединить(ОбластьЗаголовокСтрокПоставки);
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из ДанныеДляОтчета.ДанныеПоНеОхваченнымПозициям Цикл
		
		ОбластьСтрока.Параметры.НомерСтрокиЗапроса                   = СтрокаТаблицы.НомерСтрокиЗапроса;
		ОбластьСтрока.Параметры.ЗапрошеннаяНоменклатураПредставление = СтрокаТаблицы.ЗапрошеннаяНоменклатураПредставление;
		ОбластьСтрока.Параметры.ЕдИзм                                = СтрокаТаблицы.ЕдИзм;
		ОбластьСтрока.Параметры.Количество                           = СтрокаТаблицы.Количество;
		ОбластьСтрока.Параметры.МаксимальнаяЦена                     = СтрокаТаблицы.МаксимальнаяЦена;
		ОбластьСтрока.Параметры.Количество                           = СтрокаТаблицы.Количество;
		
		ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьСтрока, "Строка");
		
		Если ДанныеДляОтчета.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа Тогда
			ОбластьСтрокаСрокПоставки.Параметры.СрокПоставки = СтрокаТаблицы.СрокПоставки;
		ИначеЕсли ДанныеДляОтчета.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату Тогда
			ОбластьСтрокаСрокПоставки.Параметры.СрокПоставки = Формат(СтрокаТаблицы.СрокПоставки,"ДЛФ=D" );
		КонецЕсли; 
		
		Если ДанныеДляОтчета.ВариантУказанияСрокаПоставки <> Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается Тогда 
			ТабличныйДокумент.Присоединить(ОбластьСтрокаСрокПоставки);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ДанныеПоНеОхваченнымПозициям()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.НомерСтроки         КАК НомерСтрокиЗапроса,
	|	Товары.НаименованиеСтрокой КАК ЗапрошеннаяНоменклатураПредставление,
	|	&УсловияЕдиницыИзмерения   КАК ЕдИзм,
	|	Товары.Количество          КАК Количество,
	|	Товары.МаксимальнаяЦена    КАК МаксимальнаяЦена,
	|	Товары.СрокПоставки        КАК СрокПоставки
	|ИЗ
	|	Документ.ЗапросКоммерческихПредложенийПоставщиков.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В
	|			(ВЫБРАТЬ
	|				КоммерческоеПредложениеПоставщика.ДокументОснование КАК Ссылка
	|			ИЗ
	|				Документ.КоммерческоеПредложениеПоставщика КАК КоммерческоеПредложениеПоставщика
	|			ГДЕ
	|				КоммерческоеПредложениеПоставщика.Ссылка = &КоммерческоеПредложениеПоставщика)
	|	И НЕ Товары.ИдентификаторСтрокиЗапроса В
	|				(ВЫБРАТЬ
	|					КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса
	|				ИЗ
	|					Документ.КоммерческоеПредложениеПоставщика.Товары КАК КоммерческоеПредложениеПоставщикаТовары
	|				ГДЕ
	|					КоммерческоеПредложениеПоставщикаТовары.Ссылка = &КоммерческоеПредложениеПоставщика)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КоммерческоеПредложениеПоставщикаТовары.СрокПоставки КАК СрокПоставки
	|ИЗ
	|	Документ.КоммерческоеПредложениеПоставщика.Товары КАК КоммерческоеПредложениеПоставщикаТовары
	|ГДЕ
	|	КоммерческоеПредложениеПоставщикаТовары.Ссылка = &КоммерческоеПредложениеПоставщика";
	
	УсловияЕдиницыИзмерения = "Товары.ЕдиницаИзмерения";
	КоммерческиеПредложенияДокументыПереопределяемый.ПолучитьТекстЗапросаПолученияЕдиницыИзмерения(УсловияЕдиницыИзмерения);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияЕдиницыИзмерения", УсловияЕдиницыИзмерения);
	
	Запрос.УстановитьПараметр("КоммерческоеПредложениеПоставщика", КоммерческоеПредложениеПоставщика);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДанныеПоНеОхваченнымПозициям", Результат[0].Выгрузить());
	
	ВыборкаСроки = Результат[1].Выбрать();
	ВыборкаСроки.Следующий();
	СтруктураВозврата.Вставить("ВариантУказанияСрокаПоставки", 
		КоммерческиеПредложенияДокументыКлиентСервер.ВариантУказанияСрокаПоставкиПоЗначениям(Результат[1].Выгрузить().ВыгрузитьКолонку("СрокПоставки")));
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура СформироватьОтчетНеПолностьюЗакрытыеПозиции()
	
	ДанныеДляОтчета = ДанныеПоНеполностьюЗакрытымПозициям();
	
	Макет = Документы.КоммерческоеПредложениеПоставщика.ПолучитьМакет("НеПолностьюЗакрытыеПозиции");
	
	ОбластьШапка                     = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока                    = Макет.ПолучитьОбласть("Строка");
	ОбластьПустаяСтрока              = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОбластьПустаяСтрокаГраницаСверху = Макет.ПолучитьОбласть("ПустаяСтрокаГраницаСверху");
	
	ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьПустаяСтрока, "ПустаяСтрока");
	ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьШапка, "Шапка");
	
	Для Каждого СтрокаДерева Из ДанныеДляОтчета.Строки Цикл
		
		ЭтоПерваяПозицияПредложения = Истина;
		
		Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
			
			Если ЭтоПерваяПозицияПредложения Тогда
				
				ОбластьСтрока.Параметры.ЗапросНомерСтроки     = ПодчиненнаяСтрока.ЗапросНомерСтроки;
				ОбластьСтрока.Параметры.ЗапросНоменклатура     = ПодчиненнаяСтрока.ЗапросНоменклатура;
				ОбластьСтрока.Параметры.ЗапросКоличествоЕдИзм = СтрШаблон("%1 (%2)", ПодчиненнаяСтрока.ЗапросКоличество, ПодчиненнаяСтрока.ЗапросЕдиницаИзмерения);
				ОбластьСтрока.Параметры.Нехватка              = ПодчиненнаяСтрока.ЗапросКоличество - ПодчиненнаяСтрока.ПредложениеКоличествоИтого;
				ОбластьСтрока.Области.СтрокаЗапрошено.ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
				
				ЭтоПерваяПозицияПредложения = Ложь;
				
			Иначе 
				
				ОбластьСтрока.Параметры.ЗапросНомерСтроки     = "";
				ОбластьСтрока.Параметры.ЗапросНоменклатура     = "";
				ОбластьСтрока.Параметры.ЗапросКоличествоЕдИзм = "";
				ОбластьСтрока.Параметры.Нехватка              = "";
				
				ОбластьСтрока.Области.СтрокаЗапрошено.ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
				
			КонецЕсли;
			
			ОбластьСтрока.Параметры.ПредложениеКоличествоВсего         = ПодчиненнаяСтрока.ПредложениеКоличествоИтого;
			ОбластьСтрока.Параметры.ПредложениеПоСтрокеКоличествоЕдИзм = СтрШаблон("%1 (%2)", ПодчиненнаяСтрока.ПредложениеКоличествоПоСтроке, ПодчиненнаяСтрока.ПредложениеЕдиницаИзмерения);
			ОбластьСтрока.Параметры.ПредложениеНоменклатура            = ПодчиненнаяСтрока.ПредложениеНоменклатураПоставщикаПредставление;
			ОбластьСтрока.Параметры.ПредложениеНомерСтроки             = ПодчиненнаяСтрока.ПредложениеНомерСтроки;
			
			ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьСтрока, "Строка");
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ОбластьПустаяСтрокаГраницаСверху, "ПустаяСтрокаГраницаСверху");
	
КонецПроцедуры

&НаСервере
Функция ДанныеПоНеполностьюЗакрытымПозициям()

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.НомерСтроки КАК НомерСтроки,
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.НаименованиеСтрокой КАК НаименованиеСтрокой,
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.Количество                 КАК Количество,
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса
	|ПОМЕСТИТЬ ДанныеЗапроса
	|ИЗ
	|	Документ.ЗапросКоммерческихПредложенийПоставщиков.Товары КАК ЗапросКоммерческихПредложенийПоставщиковТовары
	|ГДЕ
	|	ЗапросКоммерческихПредложенийПоставщиковТовары.Ссылка В
	|			(ВЫБРАТЬ
	|				КоммерческоеПредложениеПоставщика.ДокументОснование КАК Ссылка
	|			ИЗ
	|				Документ.КоммерческоеПредложениеПоставщика КАК КоммерческоеПредложениеПоставщика
	|			ГДЕ
	|				КоммерческоеПредложениеПоставщика.Ссылка = &КоммерческоеПредложениеПоставщика)
	|	И ЗапросКоммерческихПредложенийПоставщиковТовары.ИдентификаторСтрокиЗапроса В
	|			(ВЫБРАТЬ
	|				КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса
	|			ИЗ
	|				Документ.КоммерческоеПредложениеПоставщика.Товары КАК КоммерческоеПредложениеПоставщикаТовары
	|			ГДЕ
	|				КоммерческоеПредложениеПоставщикаТовары.Ссылка = &КоммерческоеПредложениеПоставщика)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса,
	|	СУММА(КоммерческоеПредложениеПоставщикаТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ ДанныеПредложения
	|ИЗ
	|	Документ.КоммерческоеПредложениеПоставщика.Товары КАК КоммерческоеПредложениеПоставщикаТовары
	|ГДЕ
	|	КоммерческоеПредложениеПоставщикаТовары.Ссылка = &КоммерческоеПредложениеПоставщика
	|	И КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса В
	|			(ВЫБРАТЬ
	|				ДанныеЗапроса.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса
	|			ИЗ
	|				ДанныеЗапроса КАК ДанныеЗапроса)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеЗапроса.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса,
	|	ДанныеЗапроса.Количество КАК ЗапросКоличество,
	|	ДанныеПредложения.Количество КАК ПредложениеКоличество,
	|	ДанныеЗапроса.НомерСтроки КАК ЗапросНомерСтроки,
	|	ДанныеЗапроса.НаименованиеСтрокой КАК ЗапросНоменклатура,
	|	ДанныеЗапроса.ЕдиницаИзмерения КАК ЗапросЕдиницаИзмерения
	|ПОМЕСТИТЬ НеполностьюЗакрытыеПозиции
	|ИЗ
	|	ДанныеЗапроса КАК ДанныеЗапроса
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеПредложения КАК ДанныеПредложения
	|		ПО ДанныеЗапроса.ИдентификаторСтрокиЗапроса = ДанныеПредложения.ИдентификаторСтрокиЗапроса
	|ГДЕ
	|	ДанныеЗапроса.Количество > ЕСТЬNULL(ДанныеПредложения.Количество, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НеполностьюЗакрытыеПозиции.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса,
	|	НеполностьюЗакрытыеПозиции.ЗапросНоменклатура КАК ЗапросНоменклатура,
	|	НеполностьюЗакрытыеПозиции.ЗапросНомерСтроки КАК ЗапросНомерСтроки,
	|	НеполностьюЗакрытыеПозиции.ЗапросЕдиницаИзмерения КАК ЗапросЕдиницаИзмерения,
	|	НеполностьюЗакрытыеПозиции.ЗапросКоличество КАК ЗапросКоличество,
	|	НеполностьюЗакрытыеПозиции.ПредложениеКоличество КАК ПредложениеКоличествоИтого,
	|	КоммерческоеПредложениеПоставщикаТовары.НоменклатураПоставщикаПредставление КАК ПредложениеНоменклатураПоставщикаПредставление,
	|	КоммерческоеПредложениеПоставщикаТовары.ЕдиницаИзмерения КАК ПредложениеЕдиницаИзмерения,
	|	КоммерческоеПредложениеПоставщикаТовары.НомерСтроки КАК ПредложениеНомерСтроки,
	|	КоммерческоеПредложениеПоставщикаТовары.Количество КАК ПредложениеКоличествоПоСтроке
	|ИЗ
	|	НеполностьюЗакрытыеПозиции КАК НеполностьюЗакрытыеПозиции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КоммерческоеПредложениеПоставщика.Товары КАК КоммерческоеПредложениеПоставщикаТовары
	|		ПО НеполностьюЗакрытыеПозиции.ИдентификаторСтрокиЗапроса = КоммерческоеПредложениеПоставщикаТовары.ИдентификаторСтрокиЗапроса
	|			И (КоммерческоеПредложениеПоставщикаТовары.Ссылка = &КоммерческоеПредложениеПоставщика)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗапросНомерСтроки,
	|	ПредложениеНомерСтроки
	|ИТОГИ ПО
	|	ИдентификаторСтрокиЗапроса";
	
	Запрос.УстановитьПараметр("КоммерческоеПредложениеПоставщика", КоммерческоеПредложениеПоставщика);
	
	Возврат Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);

КонецФункции 

#КонецОбласти

