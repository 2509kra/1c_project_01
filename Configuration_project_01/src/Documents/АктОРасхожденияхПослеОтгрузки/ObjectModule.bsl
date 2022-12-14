#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеОтгрузки);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.СуффиксДопРеквизита = "ПоДокументу";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	АктОРасхожденияхПослеОтгрузкиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
	АктОРасхожденияхПослеОтгрузкиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполненНаОснованииДокумента = Ложь;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			Если ДанныеЗаполнения.Свойство("ДокументОснование") 
				И (ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
					ИЛИ ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровПоставщику")) Тогда
				
				ЗаполненНаОснованииДокумента = Истина;
				ЗаполнитьНаОсновании(ДанныеЗаполнения.ДокументОснование);
				
			Иначе
				ЗаполнитьПоОтбору(ДанныеЗаполнения);
			КонецЕсли;
		
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
			ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
			
			ЗаполненНаОснованииДокумента = Истина;
			ЗаполнитьНаОсновании(ДанныеЗаполнения);
			ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаполненНаОснованииДокумента  Тогда
		
		Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении)
			Тогда
		
			ИнициализироватьУсловияПродаж();
		
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) 
		И (Не ЗначениеЗаполнено(НалогообложениеНДС) Или Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами")) Тогда
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.НалогообложениеНДС(Организация, , Договор, , Дата);
	КонецЕсли;
	АктОРасхожденияхПослеОтгрузкиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	АвторизованВнешнийПользователь = ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();
	ТипОснованияРеализация         = РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении);
	
	Если АвторизованВнешнийПользователь Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Цена");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Действие");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковокПоДокументу");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоДокументу");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ТекстовоеОписание");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Реализация");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
	                                            НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеОтгрузки),
	                                            Отказ,
	                                            МассивНепроверяемыхРеквизитов);
	
	//Проверка того, что реализации по заказу
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ЗаказКлиента");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КодСтроки");
	
	Если АвторизованВнешнийПользователь Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацииДокумента.Реализация
		|ПОМЕСТИТЬ ДокументыОснования
		|ИЗ
		|	&ДокументыОснования КАК РеализацииДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументыОснования.Реализация
		|ИЗ
		|	ДокументыОснования КАК ДокументыОснования
		|ГДЕ
		|	НЕ ДокументыОснования.Реализация В(&ПустыеСсылки)";
		
		ПустыеСсылки = Новый Массив;
		ПустыеСсылки.Добавить(Документы.РеализацияТоваровУслуг.ПустаяСсылка());
		
		Запрос.УстановитьПараметр("ДокументыОснования", Товары.Выгрузить(,"Реализация"));
		Запрос.УстановитьПараметр("ПустыеСсылки",       ПустыеСсылки);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			КоличествоРеализацийОснований = 0;
		Иначе
			КоличествоРеализацийОснований = РезультатЗапроса.Выбрать().Количество();
		КонецЕсли;
		
		Для ТекИндекс = 0 По Товары.Количество()-1 Цикл
			
			ТекущаяСтрока = Товары[ТекИндекс];
			
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) И Не ЗначениеЗаполнено(ТекущаяСтрока.ТекстовоеОписание) Тогда
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Текстовое описание"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "ТекстовоеОписание"),
				,
				Отказ)
			КонецЕсли;
			
			Если КоличествоРеализацийОснований > 1 И НЕ ЗначениеЗаполнено(ТекущаяСтрока.Реализация) Тогда
				
				АктПоПередаче = Ложь;
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""%Реализация%"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Реализация%", ?(Не АктПоПередаче, НСтр("ru='Реализация'"), НСтр("ru='Передача'")));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Реализация"),
				,
				Отказ);
			КонецЕсли;
			
			Если Не ТекущаяСтрока.ЗаполненоПоРеализации
				И Не ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковок) Тогда
			
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Количество факт"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковок"),
					,
					Отказ);
			
		КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		МассивРеализацийПоЗаказу = Новый Массив;
		ПроверкиПоЗаказуТребуются = Ложь;
		
		Если ТипОснованияРеализация Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	РеализацииДокумента.Реализация
			|ПОМЕСТИТЬ ДокументыОснования
			|ИЗ
			|	&ДокументыОснования КАК РеализацииДокумента
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ДокументыОснования.Реализация
			|ИЗ
			|	ДокументыОснования КАК ДокументыОснования
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|		ПО ДокументыОснования.Реализация = РеализацияТоваровУслуг.Ссылка
			|ГДЕ
			|	РеализацияТоваровУслуг.РеализацияПоЗаказам
			|";
			
			Запрос.УстановитьПараметр("ДокументыОснования", Товары.Выгрузить(,"Реализация"));
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				ПроверкиПоЗаказуТребуются = Истина;
				МассивРеализацийПоЗаказу = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Реализация");
			КонецЕсли;
			
		КонецЕсли;
		
		Для ТекИндекс = 0 По Товары.Количество()-1 Цикл
			
			ТекущаяСтрока = Товары[ТекИндекс];
			
			Если ПроверкиПоЗаказуТребуются Тогда 
				Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЗаказКлиента) И ЗначениеЗаполнено(ТекущаяСтрока.Реализация)
					И МассивРеализацийПоЗаказу.Найти(ТекущаяСтрока.Реализация) <> Неопределено Тогда
					
					ТекстОшибки = НСтр("ru='Не заполнено поле ""Заказ клиента"" в строке %НомерСтроки% списка ""Товары""'");
					ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "ЗаказКлиента"),
					,
					Отказ);
					
					ТекстОшибки = НСтр("ru='Не заполнено поле ""Код строки"" в строке %НомерСтроки% списка ""Товары""'");
					ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "ЗаказКлиента"),
					,
					Отказ);
					
				КонецЕсли;
			КонецЕсли;
			
			Если ТекущаяСтрока.ЗаполненоПоРеализации
				И Не ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковокПоДокументу) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Количество по документу"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковокПоДокументу"),
					,
					Отказ);
				
			КонецЕсли;
				
			Если Статус <> Перечисления.СтатусыАктаОРасхождениях.НеСогласовано 
				И (ТекущаяСтрока.КоличествоУпаковок - ТекущаяСтрока.КоличествоУпаковокПоДокументу) <> 0 
				И Не ЗначениеЗаполнено(ТекущаяСтрока.Действие) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Как отражать расхождение"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Действие"),
					,
					Отказ);
				
			КонецЕсли;
				
			Если Не ТекущаяСтрока.ЗаполненоПоРеализации
				И Не ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковок) Тогда
			
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Количество факт"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковок"),
				,
				Отказ);
			
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Реализация)
				И Статус <> Перечисления.СтатусыАктаОРасхождениях.НеСогласовано Тогда
				
				ИмяКолонки = ?(ТипОснованияРеализация, НСтр("ru = 'Реализация'"), НСтр("ru = 'Возврат поставщику'"));
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Не заполнено поле ""%1"" в строке ""%2"" списка ""Товары""'"), ИмяКолонки, ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Реализация"),
				,
				Отказ);
				
			КонецЕсли;
		
		КонецЦикла;
		
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		Если Не ЗначениеЗаполнено(Партнер) Тогда
			
			Если ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратПоставщику Тогда
				ТекстОшибки = НСтр("ru = 'Поле ""Поставщик"" не заполнено'");
			Иначе
				ТекстОшибки = НСтр("ru = 'Поле ""Клиент"" не заполнено'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Партнер",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) Тогда
		Если Не ЗначениеЗаполнено(Соглашение) ИЛИ 
			 Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Договор");
		КонецЕсли;
	ИначеЕсли РасхожденияКлиентСервер.ТипОснованияВозвратПоставщику(ТипОснованияАктаОРасхождении) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Соглашение");
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг
		Тогда
			
		ОписаниеМетаданных = РасхожденияСервер.ОписаниеМетаданныхПроверкиВозможностиВнесенияИзлишкаВНакладную();
		ОписаниеМетаданных.ИмяПоляНакладнойЗаказ = "ЗаказКлиента";
		ОписаниеМетаданных.ИмяПоляРегистраЗаказ  = "ЗаказКлиента";
		ОписаниеМетаданных.ИмяПоляАктаЗаказ = "ЗаказКлиента";
		ОписаниеМетаданных.ИмяПоляАктаНакладная = "Реализация";
		
		РасхожденияСервер.ПроверкаВозможностиВнесенияИзлишкаВНакладную(ЭтотОбъект, "ЗаказыКлиентов", ОписаниеМетаданных, Отказ);
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении)
		Тогда
		
		ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект,Отказ);
		
	Иначе
		ЗакупкиСервер.ПроверитьКорректностьЗаполненияДокументаЗакупки(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	АктОРасхожденияхПослеОтгрузкиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АктОРасхожденияхПослеОтгрузки.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ЗаказыСервер.ОтразитьГрафикОтгрузкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	АктОРасхожденияхПослеОтгрузкиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	АктОРасхожденияхПослеОтгрузкиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоОтбору(СтруктураОтбора)
	
	Если СтруктураОтбора.Свойство("Организация") Тогда
		Организация = СтруктураОтбора.Организация;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Партнер") Тогда
		Партнер = СтруктураОтбора.Партнер;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Контрагент") Тогда
		Контрагент = СтруктураОтбора.Контрагент;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Валюта") Тогда
		Валюта = СтруктураОтбора.Валюта;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("ХозяйственнаяОперация") Тогда
		ХозяйственнаяОперация = СтруктураОтбора.ХозяйственнаяОперация;
		ТипОснованияАктаОРасхождении = ТипОснованияАктаОРасхожденииПоХозОперации(ХозяйственнаяОперация);
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("ТипОснованияАктаОРасхождении") Тогда
		ТипОснованияАктаОРасхождении = СтруктураОтбора.ТипОснованияАктаОРасхождении;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОсновании(Основание)
	
	Запрос = Новый Запрос;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг;
		Запрос.Текст = ТекстЗапросаПоОснованиюРеализации();
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратПоставщику;
		Запрос.Текст = ТекстЗапросаПоОснованиюВозврату();
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Основание", Основание);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыОснования = РезультатЗапроса[0].Выбрать();
	РеквизитыОснования.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив;
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		РеквизитыОснования.РеализацияТоваровУслуг,
		РеквизитыОснования.СтатусДокумента,
		РеквизитыОснования.ЕстьОшибкиПроведен,
		РеквизитыОснования.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов,
		РеквизитыОснования.СоглашениеДоступноВнешнимПользователям);
	
	// Заполнение шапки
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
	
	Товары.Загрузить(РезультатЗапроса[1].Выгрузить());
	Серии.Загрузить(РезультатЗапроса[2].Выгрузить());
	
КонецПроцедуры

Функция ТекстЗапросаПоОснованиюРеализации()

	Возврат "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НЕ РеализацияТоваровУслуг.Проведен КАК ЕстьОшибкиПроведен,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровУслуг.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
	|			ИЛИ РеализацияТоваровУслуг.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьОшибкиСтатус,
	|	РеализацияТоваровУслуг.Ссылка КАК РеализацияТоваровУслуг,
	|	РеализацияТоваровУслуг.Статус КАК СтатусДокумента,
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.Контрагент,
	|	РеализацияТоваровУслуг.Менеджер,
	|	РеализацияТоваровУслуг.НалогообложениеНДС,
	|	РеализацияТоваровУслуг.Партнер,
	|	РеализацияТоваровУслуг.Валюта,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Грузоотправитель) КАК Грузоотправитель,
	|	РеализацияТоваровУслуг.ХозяйственнаяОперация,
	|	РеализацияТоваровУслуг.ЦенаВключаетНДС,
	|	РеализацияТоваровУслуг.Договор,
	|	РеализацияТоваровУслуг.КонтактноеЛицо,
	|	РеализацияТоваровУслуг.Соглашение,
	|	РеализацияТоваровУслуг.Подразделение,
	|	РеализацияТоваровУслуг.Соглашение.ДоступноВнешнимПользователям КАК СоглашениеДоступноВнешнимПользователям
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РеализацияТоваровУслугТовары.Номенклатура,
	|	РеализацияТоваровУслугТовары.Характеристика,
	|	РеализацияТоваровУслугТовары.Серия,
	|	РеализацияТоваровУслугТовары.Назначение,
	|	РеализацияТоваровУслугТовары.Упаковка,
	|	РеализацияТоваровУслугТовары.КоличествоУпаковок,
	|	РеализацияТоваровУслугТовары.Количество,
	|	РеализацияТоваровУслугТовары.ВидЦены,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровУслугТовары.КоличествоУпаковок = 0
	|			ТОГДА РеализацияТоваровУслугТовары.Цена
	|		ИНАЧЕ
	|			ВЫРАЗИТЬ(РеализацияТоваровУслугТовары.Сумма / РеализацияТоваровУслугТовары.КоличествоУпаковок КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК Цена,
	|	РеализацияТоваровУслугТовары.Сумма,
	|	РеализацияТоваровУслугТовары.СтавкаНДС,
	|	РеализацияТоваровУслугТовары.Склад,
	|	РеализацияТоваровУслугТовары.СуммаНДС,
	|	РеализацияТоваровУслугТовары.СуммаСНДС,
	|	РеализацияТоваровУслугТовары.СтатусУказанияСерий,
	|	РеализацияТоваровУслугТовары.Ссылка КАК Реализация,
	|	РеализацияТоваровУслугТовары.ЗаказКлиента КАК ЗаказКлиента,
	|	РеализацияТоваровУслугТовары.КодСтроки КАК КодСтроки,
	|	ИСТИНА КАК ЗаполненоПоРеализации,
	|	РеализацияТоваровУслугТовары.КоличествоУпаковок КАК КоличествоУпаковокПоДокументу,
	|	РеализацияТоваровУслугТовары.Количество КАК КоличествоПоДокументу,
	|	РеализацияТоваровУслугТовары.Сумма КАК СуммаПоДокументу,
	|	РеализацияТоваровУслугТовары.СуммаНДС КАК СуммаНДСПоДокументу,
	|	РеализацияТоваровУслугТовары.СуммаСНДС КАК СуммаСНДСПоДокументу
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РеализацияТоваровУслугСерии.Серия          КАК Серия,
	|	РеализацияТоваровУслугСерии.Количество     КАК Количество,
	|	РеализацияТоваровУслугСерии.Количество     КАК КоличествоПоДокументу,
	|	РеализацияТоваровУслугСерии.Номенклатура   КАК Номенклатура,
	|	РеализацияТоваровУслугСерии.Характеристика КАК Характеристика,
	|	РеализацияТоваровУслугСерии.Назначение     КАК Назначение,
	|	РеализацияТоваровУслугСерии.Склад          КАК Склад,
	|	РеализацияТоваровУслугСерии.Ссылка         КАК Реализация,
	|	ИСТИНА                                     КАК ЗаполненоПоРеализации
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Серии КАК РеализацияТоваровУслугСерии
	|ГДЕ
	|	РеализацияТоваровУслугСерии.Ссылка = &Основание
	|";

КонецФункции 

Функция ТекстЗапросаПоОснованиюВозврату()

	Возврат "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НЕ ВозвратТоваровПоставщику.Проведен КАК ЕстьОшибкиПроведен,
	|	ЛОЖЬ КАК ЕстьОшибкиСтатус,
	|	ВозвратТоваровПоставщику.Ссылка КАК РеализацияТоваровУслуг,
	|	НЕОПРЕДЕЛЕНО КАК СтатусДокумента,
	|	ВозвратТоваровПоставщику.Организация,
	|	ВозвратТоваровПоставщику.Контрагент,
	|	ВозвратТоваровПоставщику.Менеджер,
	|	ВозвратТоваровПоставщику.НалогообложениеНДС,
	|	ВозвратТоваровПоставщику.Партнер,
	|	ВозвратТоваровПоставщику.Валюта,
	|	ПРЕДСТАВЛЕНИЕ(ВозвратТоваровПоставщику.Грузоотправитель) КАК Грузоотправитель,
	|	ВозвратТоваровПоставщику.ХозяйственнаяОперация,
	|	ВозвратТоваровПоставщику.ЦенаВключаетНДС,
	|	ВозвратТоваровПоставщику.Договор,
	|	ВозвратТоваровПоставщику.КонтактноеЛицо,
	|	ВозвратТоваровПоставщику.Соглашение,
	|	ВозвратТоваровПоставщику.Подразделение,
	|	ЛОЖЬ КАК СоглашениеДоступноВнешнимПользователям
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|ГДЕ
	|	ВозвратТоваровПоставщику.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВозвратТоваровПоставщикуТовары.Номенклатура,
	|	ВозвратТоваровПоставщикуТовары.Характеристика,
	|	ВозвратТоваровПоставщикуТовары.Серия,
	|	ВозвратТоваровПоставщикуТовары.Назначение,
	|	ВозвратТоваровПоставщикуТовары.Упаковка,
	|	ВозвратТоваровПоставщикуТовары.КоличествоУпаковок,
	|	ВозвратТоваровПоставщикуТовары.Количество,
	|	ВозвратТоваровПоставщикуТовары.Цена КАК Цена,
	|	ВозвратТоваровПоставщикуТовары.Сумма,
	|	ВозвратТоваровПоставщикуТовары.СтавкаНДС,
	|	ВозвратТоваровПоставщикуТовары.Ссылка.Склад,
	|	ВозвратТоваровПоставщикуТовары.СуммаНДС,
	|	ВозвратТоваровПоставщикуТовары.СуммаСНДС,
	|	ВозвратТоваровПоставщикуТовары.СтатусУказанияСерий,
	|	ВозвратТоваровПоставщикуТовары.Ссылка КАК Реализация,
	|	ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка) КАК ЗаказКлиента,
	|	ИСТИНА КАК ЗаполненоПоРеализации,
	|	ВозвратТоваровПоставщикуТовары.КоличествоУпаковок КАК КоличествоУпаковокПоДокументу,
	|	ВозвратТоваровПоставщикуТовары.Количество КАК КоличествоПоДокументу,
	|	ВозвратТоваровПоставщикуТовары.Сумма КАК СуммаПоДокументу,
	|	ВозвратТоваровПоставщикуТовары.СуммаНДС КАК СуммаНДСПоДокументу,
	|	ВозвратТоваровПоставщикуТовары.СуммаСНДС КАК СуммаСНДСПоДокументу,
	|	ВозвратТоваровПоставщикуТовары.ДокументПоступления
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику.Товары КАК ВозвратТоваровПоставщикуТовары
	|ГДЕ
	|	ВозвратТоваровПоставщикуТовары.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВозвратТоваровПоставщикуСерии.Серия КАК Серия,
	|	ВозвратТоваровПоставщикуСерии.Количество КАК Количество,
	|	ВозвратТоваровПоставщикуСерии.Количество КАК КоличествоПоДокументу,
	|	ВозвратТоваровПоставщикуСерии.Номенклатура КАК Номенклатура,
	|	ВозвратТоваровПоставщикуСерии.Характеристика КАК Характеристика,
	|	ВозвратТоваровПоставщикуСерии.Назначение КАК Назначение,
	|	ВозвратТоваровПоставщикуСерии.Ссылка.Склад КАК Склад,
	|	ВозвратТоваровПоставщикуСерии.Ссылка КАК Реализация,
	|	ИСТИНА КАК ЗаполненоПоРеализации
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику.Серии КАК ВозвратТоваровПоставщикуСерии
	|ГДЕ
	|	ВозвратТоваровПоставщикуСерии.Ссылка = &Основание";

КонецФункции


Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если Не ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Менеджер    = Пользователи.ТекущийПользователь();
		Если Не ЗначениеЗаполнено(Подразделение) Тогда
			Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер);
		КонецЕсли;
	КонецЕсли;
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	Статус      = Перечисления.СтатусыАктаОРасхождениях.НеСогласовано;
	
	ЗаполнитьНалогообложениеНДС();
	
КонецПроцедуры

#Область УсловияПродаж

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в документе
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию(СегментНоменклатуры = Неопределено) Экспорт
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если ЗначениеЗаполнено(Партнер) ИЛИ Не ИспользоватьСоглашенияСКлиентами Тогда
		
		ОперацияОтбора = ?(ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи,
							Неопределено,
							ХозяйственнаяОперация);
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение",   Соглашение);
		ПараметрыОтбора.Вставить("ХозяйственныеОперации", ОперацияОтбора);
		ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.АктОРасхожденияхПослеОтгрузки.ПустаяСсылка());
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(Партнер, ПараметрыОтбора);
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если НЕ ИспользоватьСоглашенияСКлиентами 
				Или (Соглашение <> УсловияПродажПоУмолчанию.Соглашение И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию, СегментНоменклатуры);
				ЗаполнитьНалогообложениеНДС();
				
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС)
		И ИспользоватьСоглашенияСКлиентами
		И Не РасхожденияКлиентСервер.ТипОснованияПередачаТоваровХранителю(ТипОснованияАктаОРасхождении) Тогда
		
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.НалогообложениеНДС(Организация, , Договор, , Дата);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж в документе
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж, СегментНоменклатуры = Неопределено) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта                = УсловияПродаж.Валюта;
	ХозяйственнаяОперация = УсловияПродаж.ХозяйственнаяОперация;
	ЦенаВключаетНДС       = УсловияПродаж.ЦенаВключаетНДС;
	СегментНоменклатуры   = УсловияПродаж.СегментНоменклатуры;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация <> Организация Тогда
		Организация = УсловияПродаж.Организация;
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И УсловияПродаж.Контрагент<>Контрагент Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.КонтактноеЛицо) 
			И НЕ ЗначениеЗаполнено(КонтактноеЛицо) Тогда
			КонтактноеЛицо = УсловияПродаж.КонтактноеЛицо;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(
			ЭтотОбъект,
			?(ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет,
				Перечисления.ХозяйственныеОперации.РеализацияКлиенту,
				ХозяйственнаяОперация));
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС)
		И Не РасхожденияКлиентСервер.ТипОснованияПередачаТоваровХранителю(ТипОснованияАктаОРасхождении) Тогда
		
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.НалогообложениеНДС(Организация, , Договор, , Дата);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в документе
//
Процедура ЗаполнитьУсловияПродажПоСоглашению(СегментНоменклатуры) Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение, Истина, Истина);
	ЗаполнитьУсловияПродаж(УсловияПродаж, СегментНоменклатуры);
	ЗаполнитьНалогообложениеНДС();
	
КонецПроцедуры

#КонецОбласти

#Область УсловияЗакупок

// Заполняет условия закупок по умолчанию в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Соглашение) Тогда
		Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено (Партнер) Тогда
		
		ОперацияОтбора = ?(ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения,
							Неопределено,
							Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи);
		
		ПараметрыОтбора = Новый Структура("ХозяйственныеОперации", ОперацияОтбора);
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Партнер, ПараметрыОтбора);
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				ЗаполнитьНалогообложениеНДС();
				
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
				
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоСоглашению() Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	ЗаполнитьНалогообложениеНДС();
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

// Заполняет условия закупок в документе
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	ЦенаВключаетНДС = УсловияЗакупок.ЦенаВключаетНДС;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация<>Организация Тогда
		Организация = УсловияЗакупок.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	ХозяйственнаяОперация = ЗакупкиСервер.ПолучитьХозяйственнуюОперациюВозвратаПоПоступлению(УсловияЗакупок.ХозяйственнаяОперация);
	
	Если Не РасхожденияКлиентСервер.ТипОснованияОтгрузкаТоваровСХранения(ТипОснованияАктаОРасхождении) Тогда
		НалогообложениеНДС = УсловияЗакупок.НалогообложениеНДС;
	КонецЕсли;
	
	ХозяйственнаяОперацияДоговора = Неопределено;
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровПоставщику") Тогда
		ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровКомитенту") Тогда
		ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссию");
	КонецЕсли;
	
	ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
	ДопПараметры.ВалютаВзаиморасчетов = Валюта;
	Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперацияДоговора, ДопПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыАктаОРасхождениях[НовыйСтатус];
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеОтгрузки);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

Функция ТипОснованияАктаОРасхожденииПоХозОперации(ХозОперация)
	
	Если ХозОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровПоставщику 
		ИЛИ ХозОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту Тогда
		
		Возврат Перечисления.ТипыОснованияАктаОРасхождении.ВозвратПоставщику;
		
	Иначе
		Возврат Перечисления.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг;
	КонецЕсли;
	
КонецФункции

#Область Прочее

Процедура ЗаполнитьНалогообложениеНДС()
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) Тогда
		
		ПараметрыЗаполнения = Документы.АктОРасхожденияхПослеОтгрузки.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
		УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
		
	ИначеЕсли РасхожденияКлиентСервер.ТипОснованияВозвратПоставщику(ТипОснованияАктаОРасхождении) Тогда
		
		ПараметрыЗаполнения = Документы.АктОРасхожденияхПослеОтгрузки.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
		УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
