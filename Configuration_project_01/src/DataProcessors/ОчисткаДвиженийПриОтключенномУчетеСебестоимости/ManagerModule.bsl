#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак наличия неиспользуемых движений по себестоимости.
//
//	Возвращаемое значение:
//		Булево - признак наличия неиспользуемых движений по себестоимости.
//
Функция ЕстьНеиспользуемыеДвиженияПоРегистрамСебестоимости() Экспорт
	
	Если НЕ РасчетСебестоимостиПовтИсп.ВозможныНеиспользуемыеДвиженияПоРегистрамСебестоимости() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерВТ = СформироватьТаблицуНеиспользуемыхДвижений(Истина);
	
	Возврат РасчетСебестоимостиПрикладныеАлгоритмы.РазмерВременнойТаблицы(МенеджерВТ, "ВТНеиспользуемыеДвижения") > 0;
	
КонецФункции

// Возвращает количество регистраторов с неиспользуемыми движениями по себестоимости.
//
//	Возвращаемое значение:
//		Число - количество регистраторов с неиспользуемыми движениями по себестоимости.
//
Функция КоличествоРегистраторовСНеиспользуемымиДвижениями() Экспорт
	
	Если НЕ РасчетСебестоимостиПовтИсп.ВозможныНеиспользуемыеДвиженияПоРегистрамСебестоимости() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СформироватьТаблицуНеиспользуемыхДвижений(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Т.Регистратор) КАК КоличествоРегистраторов
	|ИЗ
	|	ВТНеиспользуемыеДвижения КАК Т";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.КоличествоРегистраторов;
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьТаблицуНеиспользуемыхДвижений(ТолькоПроверитьНаличие) Экспорт
	
	РегистраторыИсключения = Новый Массив;
	
	Для Каждого МетаРегистратор Из РасчетСебестоимостиПовтИсп.РегистраторыСДвижениямиПриВыключенномУчетеСебестоимости() Цикл
		РегистраторыИсключения.Добавить(Тип("ДокументСсылка." + МетаРегистратор.Ключ.Имя));
	КонецЦикла;
	
	МассивТекстовЗапроса = Новый Массив;
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ %1
	|	""%2"" КАК ИмяРегистра,
	|	Т.Регистратор КАК Регистратор,
	|	%4,
	|	НАЧАЛОПЕРИОДА(Т.Период, ДЕНЬ) КАК Период,
	|	ИСТИНА КАК ОчищатьВсеДвижения
	|%3
	|ИЗ
	|	%2 КАК Т
	|ГДЕ
	|	НЕ &ВестиУчет
	|	ИЛИ (Т.Период < &ДатаНачалаУчета
	|		И НЕ ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения))
	|	ИЛИ (Т.Период < ДОБАВИТЬКДАТЕ(&ДатаНачалаУчета, МЕСЯЦ, -1)
	|		И ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения))";
	
	ПереченьРегистров = РасчетСебестоимостиПовтИсп.РегистрыНеИспользуемыеПриВыключенномУчетеСебестоимости();
	
	Для Каждого КлючИЗначение Из ПереченьРегистров Цикл
		
		МетаданныеРегистра 	   = КлючИЗначение.Ключ;
		ЕстьОрганизация 	   = МетаданныеРегистра.Измерения.Найти("Организация") <> Неопределено;
		ЕстьАналитикаПартнеров = МетаданныеРегистра.Измерения.Найти("АналитикаУчетаПоПартнерам") <> Неопределено;
		
		Если ЕстьОрганизация Тогда
			ТекстПоляОрганизации = "Т.Организация КАК Организация";
		ИначеЕсли ЕстьАналитикаПартнеров Тогда 
			ТекстПоляОрганизации = "Т.АналитикаУчетаПоПартнерам.Организация КАК Организация";
		Иначе		
			ТекстПоляОрганизации = "ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация";
		КонецЕсли;
		
		МассивТекстовЗапроса.Добавить(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗапроса,
				?(ТолькоПроверитьНаличие, "ПЕРВЫЕ 1", "РАЗЛИЧНЫЕ"),
				МетаданныеРегистра.ПолноеИмя(),
				?(МассивТекстовЗапроса.Количество() = 0, "ПОМЕСТИТЬ ВТНеиспользуемыеДвижения", ""),
				ТекстПоляОрганизации));
		
	КонецЦикла;
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ %1
	|	""%2"" КАК ИмяРегистра,
	|	Т.Регистратор КАК Регистратор,
	|	%4,
	|	НАЧАЛОПЕРИОДА(Т.Период, ДЕНЬ) КАК Период,
	|	ЛОЖЬ КАК ОчищатьВсеДвижения
	|ИЗ
	|	%2 КАК Т
	|ГДЕ
	|	(НЕ &ВестиУчет
	|	ИЛИ (Т.Период < &ДатаНачалаУчета
	|		И НЕ ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения))
	|	ИЛИ (Т.Период < ДОБАВИТЬКДАТЕ(&ДатаНачалаУчета, МЕСЯЦ, -1)
	|		И ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения)))
	|	И (%3)";
	
	ПереченьРегистров = РасчетСебестоимостиПовтИсп.РегистрыНеРассчитываемыеПриВыключенномУчетеСебестоимости();
	
	Для Каждого КлючИЗначение Из ПереченьРегистров Цикл
		
		МетаданныеРегистра 	   = КлючИЗначение.Ключ;
		ЕстьОрганизация 	   = МетаданныеРегистра.Измерения.Найти("Организация") <> Неопределено;
		ЕстьАналитикаПартнеров = МетаданныеРегистра.Измерения.Найти("АналитикаУчетаПоПартнерам") <> Неопределено;
		
		Если ЕстьОрганизация Тогда
			ТекстПоляОрганизации = "Т.Организация КАК Организация";
		ИначеЕсли ЕстьАналитикаПартнеров Тогда 
			ТекстПоляОрганизации = "Т.АналитикаУчетаПоПартнерам.Организация КАК Организация";
		Иначе		
			ТекстПоляОрганизации = "ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация";
		КонецЕсли;
		
		ТекстОтбора = ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра);
		
		МассивТекстовЗапроса.Добавить(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗапроса,
				?(ТолькоПроверитьНаличие, "ПЕРВЫЕ 1", "РАЗЛИЧНЫЕ"),
				МетаданныеРегистра.ПолноеИмя(),
				ТекстОтбора,
				ТекстПоляОрганизации));
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	Запрос.УстановитьПараметр("ВестиУчет", 		 		ПолучитьФункциональнуюОпцию("ИспользоватьУчетСебестоимости"));
	Запрос.УстановитьПараметр("ДатаНачалаУчета", 		НачалоМесяца(Константы.ДатаНачалаУчетаСебестоимости.Получить()));
	Запрос.УстановитьПараметр("РегистраторыИсключения", РегистраторыИсключения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Запрос.МенеджерВременныхТаблиц;
	
КонецФункции

Процедура ОчиститьНеиспользуемыеДвиженияПоРегистрамСебестоимости(Параметры = "", АдресХранилища = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СформироватьТаблицуНеиспользуемыхДвижений(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Регистратор			КАК Регистратор,
	|	Т.ИмяРегистра			КАК ИмяРегистра,
	|	Т.Период				КАК Период,
	|	Т.ОчищатьВсеДвижения	КАК ОчищатьВсеДвижения
	|ИЗ
	|	ВТНеиспользуемыеДвижения КАК Т
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ТекстыЗапросовПоРегистрам = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		МетаданныеРегистра = Метаданные.НайтиПоПолномуИмени(Выборка.ИмяРегистра);
		
		Если Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистра) Тогда
			НаборЗаписей = РегистрыНакопления[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
		Иначе
			НаборЗаписей = РегистрыСведений[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
		КонецЕсли;
		
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		
		Если НЕ Выборка.ОчищатьВсеДвижения Тогда
			
			ТекстЗапроса = ТекстыЗапросовПоРегистрам.Получить(Выборка.ИмяРегистра);
			
			Если НЕ ЗначениеЗаполнено(ТекстЗапроса) Тогда
				
				ТекстЗапроса =
				"ВЫБРАТЬ
				|	*
				|ИЗ
				|	%1 КАК Т
				|ГДЕ
				|	Т.Регистратор = &Регистратор
				|	И НЕ (%2)";
				
				ТекстОтбора = ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра);
				
				ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстЗапроса,
					Выборка.ИмяРегистра,
					ТекстОтбора);
				
				ТекстыЗапросовПоРегистрам.Вставить(Выборка.ИмяРегистра, ТекстЗапроса);
				
			КонецЕсли;
			
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Регистратор", Выборка.Регистратор);
			
			НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
			
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	ДатаНачалаУчета = НачалоМесяца(Константы.ДатаНачалаУчетаСебестоимости.Получить());
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.ОчиститьЗаписиЗаПериод(, ДатаНачалаУчета - 1);
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(НачалоМесяца(ДатаНачалаУчета - 1));
	
КонецПроцедуры 

Функция ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра)
	
	ЕстьРасчетПартий 		= (МетаданныеРегистра.Реквизиты.Найти("РасчетПартий") <> Неопределено);
	ЕстьРасчетСебестоимости = (МетаданныеРегистра.Реквизиты.Найти("РасчетСебестоимости") <> Неопределено);
	
	Если ЕстьРасчетПартий И ЕстьРасчетСебестоимости Тогда
		ТекстОтбора = "Т.РасчетПартий ИЛИ Т.РасчетСебестоимости";
	ИначеЕсли ЕстьРасчетПартий Тогда
		ТекстОтбора = "Т.РасчетПартий";
	ИначеЕсли ЕстьРасчетСебестоимости Тогда
		ТекстОтбора = "Т.РасчетСебестоимости";
	Иначе
		ТекстОтбора = "ЛОЖЬ";
	КонецЕсли;
	
	Возврат ТекстОтбора;
	
КонецФункции


#КонецОбласти

#КонецЕсли
