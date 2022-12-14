#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.РазрешеноИзменятьВарианты = Ложь;
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("Номенклатура");
		Для каждого ЭлементПараметр Из КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы Цикл
			Если ЭлементПараметр.Параметр = ЗначениеПоиска Тогда
				ЭлементПараметр.ПредставлениеПользовательскойНастройки = НСтр("ru = 'Комплект'");
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборНоменклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	ОтборСерия = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение;
	
	Если НЕ ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Продукция или полуфабрикат"" не заполнено.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Поле ""Комплект"" не заполнено.'");
		КонецЕсли; 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ОтборСерия) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Серия"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	#Область Инициализация
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Номенклатура", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение);
	ПараметрыОтчета.Вставить("Характеристика", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Характеристика").Значение);
	ПараметрыОтчета.Вставить("Серия", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение);
	
	СтруктураСерииДерево = СтруктураСерииНоменклатуры(ПараметрыОтчета);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.СтруктураСерииНоменклатуры.ПФ_MXL_СтруктураСерииНоменклатуры");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПараметры = Макет.ПолучитьОбласть("Параметры");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	#КонецОбласти
	
	// Вывод области Заголовок
	#Область ОбластьЗаголовок
	ПараметрыОбласти = Новый Структура("ТекстЗаголовка", НСтр("ru = 'Структура серии номенклатуры'"));
	ОбластьЗаголовок.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьЗаголовок);
	#КонецОбласти
	
	// Вывод области Параметры
	#Область ОбластьПараметры
	ПараметрыОбласти = Новый Структура;
	ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
										Строка(ПараметрыОтчета.Номенклатура), 
										Строка(ПараметрыОтчета.Характеристика));
										
	ПараметрыОбласти.Вставить("ОтборНоменклатура", ПредставлениеНоменклатуры);
	ПараметрыОбласти.Вставить("ОтборСерия", Строка(ПараметрыОтчета.Серия));
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Продукция или полуфабрикат'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Комплект'"));
	КонецЕсли;
	ОбластьПараметры.Параметры.Заполнить(ПараметрыОбласти);
	ОбластьПараметры.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ДокументРезультат.Вывести(ОбластьПустаяСтрока, 1,, Истина);
	ДокументРезультат.Вывести(ОбластьПараметры, 2,, Истина);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	ДокументРезультат.Вывести(ОбластьПустаяСтрока);
	#КонецОбласти
	
	// Вывод области Шапка
	#Область ОбластьШапка
	ПараметрыОбласти = Новый Структура;
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Полуфабрикат или материал'"));
		ПараметрыОбласти.Вставить("ТекстИзрасходовано", НСтр("ru = 'Израсходовано'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Комплектующая'"));
		ПараметрыОбласти.Вставить("ТекстИзрасходовано", НСтр("ru = 'Израсходовано'"));
	КонецЕсли;
	ОбластьШапка.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьШапка);
	#КонецОбласти
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, 0, ДокументРезультат);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураСерииНоменклатуры(Параметры)
	
	СтруктураСерииНоменклатурыДерево = Новый ДеревоЗначений;
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("Израсходовано", Новый ОписаниеТипов("Число"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("Строка"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("НоменклатураПредставление", Новый ОписаниеТипов("Строка"));
	СтруктураСерииНоменклатурыДерево.Колонки.Добавить("СерияПредставление", Новый ОписаниеТипов("Строка"));
	
	СтруктураСерииКоллекция = СтруктураСерииНоменклатурыДерево.Строки;
	
	СписокНоменклатуры = Новый ТаблицаЗначений;
	СписокНоменклатуры.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокНоменклатуры.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Строки");
	
	НоваяСтрока = СписокНоменклатуры.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Параметры);
	НоваяСтрока.Строки = СтруктураСерииКоллекция;
	
	// Для предотвращения зацикливания
	ОтработаннаяНоменклатура = Новый ТаблицаЗначений;
	ОтработаннаяНоменклатура.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	
	ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), Параметры);
	
	ОтборПоХарактеристике = ЗначениеЗаполнено(Параметры.Характеристика);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока СписокНоменклатуры.Количество() <> 0 Цикл
		
		НовыйСписокНоменклатуры = СписокНоменклатуры.СкопироватьКолонки();
		
		ИспользованныеСерии = ИспользованныеСерии(СписокНоменклатуры, ОтборПоХарактеристике);
		
		Если НЕ ОтборПоХарактеристике Тогда
			
			ОтборПоХарактеристике = Истина;
			
			СписокНоменклатуры.Очистить();
			
			Колонки = "НоменклатураСписка, ХарактеристикаСписка, СерияСписка";
			ИспользованныеСерииКопия = ИспользованныеСерии.Скопировать(, Колонки);
			ИспользованныеСерииКопия.Свернуть(Колонки);
			
			Для каждого Строка Из ИспользованныеСерииКопия Цикл
				
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Строка.НоменклатураСписка;
				НоваяСтрока.Характеристика = Строка.ХарактеристикаСписка;
				НоваяСтрока.Серия = Строка.СерияСписка;
				НоваяСтрока.Строки = СтруктураСерииКоллекция;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("НоменклатураСписка", СтрокаНоменклатура.Номенклатура);
			СтруктураПоиска.Вставить("ХарактеристикаСписка", СтрокаНоменклатура.Характеристика);
			СтруктураПоиска.Вставить("СерияСписка", СтрокаНоменклатура.Серия);
			
	  		СписокСтрок = ИспользованныеСерии.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаСерияМатериала Из СписокСтрок Цикл
				
				НоваяСерия = СтрокаНоменклатура.Строки.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСерия, СтрокаСерияМатериала);
				
				НоваяСерия.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
					СтрокаСерияМатериала.НоменклатураПредставление,
					СтрокаСерияМатериала.ХарактеристикаПредставление);
					
				Если ЗначениеЗаполнено(НоваяСерия.Серия) Тогда
					
					// Контроль зацикливания
					ЕстьЗацикливание = Ложь;
					
					СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Серия",
						НоваяСерия.Номенклатура, НоваяСерия.Характеристика, НоваяСерия.Серия);
					Если ОтработаннаяНоменклатура.НайтиСтроки(СтруктураПоиска).ВГраница() <> -1 Тогда
						Родитель = НоваяСерия.Родитель;
						Пока Родитель <> Неопределено Цикл
							Если Родитель.Номенклатура = НоваяСерия.Номенклатура
									И Родитель.Характеристика = НоваяСерия.Характеристика
									И Родитель.Серия = НоваяСерия.Серия Тогда
								ЕстьЗацикливание = Истина;
								Прервать;
							КонецЕслИ;
							Родитель = Родитель.Родитель;
						КонецЦикла;
					КонецЕсли;
					
					Если Не ЕстьЗацикливание Тогда
						
						НоваяНоменклатура = НовыйСписокНоменклатуры.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяНоменклатура, НоваяСерия);
						НоваяНоменклатура.Строки = НоваяСерия.Строки;
						
						ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), НоваяСерия);
						
					КонецЕсли; 
					
				КонецЕсли;
				
			КонецЦикла; 
			
		КонецЦикла;
		
		СписокНоменклатуры = НовыйСписокНоменклатуры.Скопировать();
		
	КонецЦикла; 
	
	Возврат СтруктураСерииНоменклатурыДерево;
	
КонецФункции

Функция ИспользованныеСерии(СписокНоменклатуры, ОтборПоХарактеристике)

	ТекстыЗапроса = Новый Массив;
	
	#Область СписокНоменклатуры
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Серия КАК Справочник.СерииНоменклатуры) КАК Серия
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&СписокНоменклатуры КАК СписокНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия");
	
	#КонецОбласти
	
	
	
	
	
	#Область ПоступлениеСерийПриСборке
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.СборкаТоваров) КАК Документ,
	|	ДвижениеСерии.КоличествоОборот КАК Количество
	|ПОМЕСТИТЬ ПоступлениеСерииПоСборке
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			&ОтборПоСпискуНоменклатуры
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаСобранныхКомплектов)) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Документ");
	
	#КонецОбласти
	
	#Область РасходСерий
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.НоменклатураСписка КАК НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка КАК ХарактеристикаСписка, 
	|	ВложенныйЗапрос.СерияСписка КАК СерияСписка,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ВложенныйЗапрос.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.Серия.Представление КАК СерияПредставление,
	|	СУММА(ВложенныйЗапрос.Израсходовано) КАК Израсходовано
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		ПоступлениеСерииПоСборке.Номенклатура КАК НоменклатураСписка,
	|		ПоступлениеСерииПоСборке.Характеристика КАК ХарактеристикаСписка,
	|		ПоступлениеСерииПоСборке.Серия КАК СерияСписка,
	|		ИспользованныеСерии.Номенклатура КАК Номенклатура,
	|		ИспользованныеСерии.Характеристика КАК Характеристика,
	|		ИспользованныеСерии.Серия КАК Серия,
	|		ИспользованныеСерии.КоличествоОборот КАК Израсходовано
	|	ИЗ
	|			РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|				,
	|				,
	|				,
	|				Документ В
	|						(ВЫБРАТЬ
	|							ПоступлениеСерииПоСборке.Документ
	|						ИЗ
	|							ПоступлениеСерииПоСборке)
	|					И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКомплектующихДляСборки)) КАК ИспользованныеСерии
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПоступлениеСерииПоСборке КАК ПоступлениеСерииПоСборке
	|			ПО (ПоступлениеСерииПоСборке.Документ = ИспользованныеСерии.Документ)
	|) КАК ВложенныйЗапрос
	|ГДЕ
	|	НЕ(ВложенныйЗапрос.НоменклатураСписка = ВложенныйЗапрос.Номенклатура
	|		И ВложенныйЗапрос.ХарактеристикаСписка = ВложенныйЗапрос.Характеристика
	|		И ВложенныйЗапрос.СерияСписка = ВложенныйЗапрос.Серия)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка,
	|	ВложенныйЗапрос.СерияСписка,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураПредставление,
	|	ХарактеристикаПредставление,
	|	СерияПредставление");
	
	#КонецОбласти
	
	Разделитель = 
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, Разделитель);
	
	Если ОтборПоХарактеристике Тогда
		
		ОтборПоСпискуНенклатуры = 
		"(Номенклатура, Характеристика, Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Характеристика,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры)";
		
		ОтборПоНоменклатуреРаспределениеЗатрат = 
		"(РаспределениеЗатрат.Номенклатура, РаспределениеЗатрат.Характеристика, РаспределениеЗатрат.Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Характеристика,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры КАК СписокНоменклатуры)";
		
	Иначе
		
		ОтборПоСпискуНенклатуры = 
		"(Номенклатура, Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры)";
		
		ОтборПоНоменклатуреРаспределениеЗатрат = 
		"(РаспределениеЗатрат.Номенклатура, РаспределениеЗатрат.Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры КАК СписокНоменклатуры)";
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		"&ОтборПоСпискуНоменклатуры",
		ОтборПоСпискуНенклатуры);
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		"&ОтборПоНоменклатуреРаспределениеЗатрат",
		ОтборПоНоменклатуреРаспределениеЗатрат);
		
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Результат.Индексы.Добавить("НоменклатураСписка,СерияСписка");
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, Уровень, ДокументРезультат)

	Для каждого СтрокаДерева Из СтруктураСерииДерево.Строки Цикл
		
		ПараметрыОбласти = Новый Структура("Номенклатура,Серия,НоменклатураПредставление,
											|СерияПредставление,ЕдиницаИзмерения,Израсходовано");
		ЗаполнитьЗначенияСвойств(ПараметрыОбласти, СтрокаДерева);
		
		СтруктураРасшифровки = Новый Структура("Номенклатура,Характеристика,Серия");
		ЗаполнитьЗначенияСвойств(СтруктураРасшифровки, СтрокаДерева);
		ПараметрыОбласти.Вставить("СтруктураРасшифровки", СтруктураРасшифровки);
		
		ОбластьСтрока.Параметры.Заполнить(ПараметрыОбласти);
		ДокументРезультат.Вывести(ОбластьСтрока, Уровень,, Истина);
		
		ЗаполнитьСтрокиРекурсивно(СтрокаДерева, ОбластьСтрока, Уровень + 1, ДокументРезультат);
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли