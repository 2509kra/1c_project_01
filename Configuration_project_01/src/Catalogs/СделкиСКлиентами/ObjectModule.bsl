#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет информацию об участниках сделки - используется при работе со взаимодействиями.
//
// Параметры:
//  Контакты - Массив - список партнеров и контактных лиц, участвующих в сделке.
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт

	Если (Не ЗначениеЗаполнено(Контакты)) ИЛИ (Контакты.Количество() = 0) Тогда
		Возврат;
	КонецЕсли;

	ТабЗн = Новый ТаблицаЗначений;
	ТабЗн.Колонки.Добавить("Номер", Новый ОписаниеТипов("Число"));
	ТабЗн.Колонки.Добавить(
		"Контакт",
		Новый ОписаниеТипов("СправочникСсылка.Партнеры,СправочникСсылка.КонтактныеЛицаПартнеров"));

	Номер = 0;
	Для Каждого Элемент Из Контакты Цикл
		Номер = Номер + 1;
		Контакт = ?(ТипЗнч(Элемент) = Тип("Структура"), Элемент.Контакт, Элемент);
		новСтр = ТабЗн.Добавить();
		новСтр.Номер = Номер;
		новСтр.Контакт = Контакт;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТабЗн.Номер,
		|	ТабЗн.Контакт
		|ПОМЕСТИТЬ времКонтакты
		|ИЗ
		|	&ТабЗн КАК ТабЗн
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таб.Партнер,
		|	Таб.КонтактноеЛицо
		|ИЗ
		|	(ВЫБРАТЬ
		|		времКонтакты.Номер КАК Номер,
		|		КонтактныеЛицаПартнеров.Владелец КАК Партнер,
		|		КонтактныеЛицаПартнеров.Ссылка КАК КонтактноеЛицо
		|	ИЗ
		|		времКонтакты КАК времКонтакты
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|			ПО времКонтакты.Контакт = КонтактныеЛицаПартнеров.Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		времКонтакты.Номер,
		|		Партнеры.Ссылка,
		|		NULL
		|	ИЗ
		|		времКонтакты КАК времКонтакты
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
		|			ПО времКонтакты.Контакт = Партнеры.Ссылка) КАК Таб
		|
		|УПОРЯДОЧИТЬ ПО
		|	Таб.Номер";

	Запрос.УстановитьПараметр("ТабЗн", ТабЗн);
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		новСтр = ПартнерыИКонтактныеЛица.Добавить();
		новСтр.Партнер = Выборка.Партнер;
		новСтр.КонтактноеЛицо = Выборка.КонтактноеЛицо;

		Если ЗначениеЗаполнено(Выборка.Партнер) И Не ЗначениеЗаполнено(Партнер) Тогда
			Партнер = Выборка.Партнер;
			Если ПолучитьФункциональнуюОпцию("ИспользоватьРолиПартнеровИКонтактныхЛицВСделкахИПроектах") Тогда
				новСтр.РольПартнера = Справочники.РолиПартнеровВСделкахИПроектах.Клиент;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Закрыта") Тогда
			ДанныеЗаполнения.Закрыта = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Статус        = Перечисления.СтатусыСделок.ВРаботе;
	ДатаНачала    = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		// сделка на основании партнера
		Партнер = ДанныеЗаполнения;
		ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
		
	Иначе
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	Партнеры.Клиент,
			|	Партнеры.Ссылка
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|ГДЕ
			|	Партнеры.Ссылка В
			|			(ВЫБРАТЬ
			|				КонтактныеЛицаПартнеров.Владелец
			|			ИЗ
			|				Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|			ГДЕ
			|				КонтактныеЛицаПартнеров.Ссылка = &КонтактноеЛицо)";
			
			Запрос.УстановитьПараметр("КонтактноеЛицо", ДанныеЗаполнения);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				
				Если НЕ Выборка.Клиент Тогда
					
					ТекстОшибки = НСтр("ru='%КонтактноеЛицо% не является контактным лицом партнера - клиента. Ввод сделки на основании доступен только для клиента.'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%КонтактноеЛицо%", ДанныеЗаполнения);
					
					ВызватьИсключение ТекстОшибки;
					
				Иначе
					
					Партнер = Выборка.Ссылка;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ЗначениеЗаполнено(Партнер) Тогда
			ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		
		ЗаполнитьУсловияПродаж();
		
	КонецЕсли;
	
	ВалютаПервичногоСпроса = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаПервичногоСпроса);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// исключить партнеров сегментов запрета отгрузки
	Если СегментыСервер.ПартнерВходитВСегментыЗапретаОтгрузки(Партнер)
	 И НЕ ПраваПользователяПовтИсп.ОтгрузкаПартнерамЗапрещенныхСегментов() Тогда
		ТекстСообщения = Нстр("ru='С этим партнером нельзя заключить сделку, так как он входит в сегмент, которому запрещены отгрузки.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ЭтотОбъект, "Партнер",, Отказ);
	КонецЕсли;

	// проверить полноту информации при проигрыше
	Если Статус = Перечисления.СтатусыСделок.Проиграна Тогда
		
		// проверить определение конкурента
		Если ПричинаПроигрышаСделки = Справочники.ПричиныПроигрышаСделок.ПроигрышКонкуренту
			И ПартнерыИКонтактныеЛица.НайтиСтроки(
			Новый Структура("ВыигралСделку",Истина)).Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Необходимо указать конкурента, которому проиграна сделка'"),
				ЭтотОбъект,
				"ПартнерыИКонтактныеЛица",, Отказ);
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаПроигрышаСделки");
		
	КонецЕсли;
	
	ПроцессыИспользуются = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеСделками");
	НеИспользуетсяПервичныйСпрос = Ложь;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПервичныйСпрос") Тогда
		Если ПроцессыИспользуются И (ВидСделки.Пустая() ИЛИ НЕ ВидСделки.ИспользоватьСпрос) Тогда
			НеИспользуетсяПервичныйСпрос = Истина;
		КонецЕсли;
	Иначе
		НеИспользуетсяПервичныйСпрос = Истина;
	КонецЕсли;
	
	Если НеИспользуетсяПервичныйСпрос Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаПервичногоСпроса");
		МассивНепроверяемыхРеквизитов.Добавить("ПервичныйСпрос");
		Если ПервичныйСпрос.Количество() > 0 Тогда
			ПервичныйСпрос.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если ВидСделки.Пустая() ИЛИ ВидСделки.ТипСделки <> Перечисления.ТипыСделокСКлиентами.ТиповаяПродажа Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Ответственный");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ПервичныйСпрос.ПричинаНеудовлетворения");
	
	// Проверим указание удовлетворения первичного спроса и причин неудовлетворения, если такие необходимы.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПервичныйСпрос") И (НЕ ПроцессыИспользуются) ИЛИ (НЕ ВидСделки.Пустая() И ВидСделки.ИспользоватьСпрос) Тогда
		Если Статус = Перечисления.СтатусыСделок.Проиграна ИЛИ  Статус = Перечисления.СтатусыСделок.Выиграна Тогда
			Для каждого СтрокаПервичногоСпроса Из ПервичныйСпрос Цикл
				Если СтрокаПервичногоСпроса.ПроцентУдовлетворения < 100 И НЕ ЗначениеЗаполнено(СтрокаПервичногоСпроса.ПричинаНеудовлетворения)Тогда
					Отказ = Истина;
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='Необходимо указать причину неудовлетворения первичного спроса'"),
					ЭтотОбъект,
					"ПервичныйСпрос[" + Строка((СтрокаПервичногоСпроса.НомерСтроки-1))+ "].ПричинаНеудовлетворения",, Отказ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	УстановитьПривилегированныйРежим(Истина);
	
	// скорректировать статистику сделок
	ТипСделки = ВидСделки.ТипСделки;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеСделками")
	   И ТипСделки <> Перечисления.ТипыСделокСКлиентами.ПрочиеНепроцессныеСделки Тогда

		// уточнить потенциальную сумму продажи
		Если Ссылка.ПотенциальнаяСуммаПродажи <> ПотенциальнаяСуммаПродажи Тогда
			Выборка = РегистрыСведений.СтатистикаСделокСКлиентами.Выбрать(Новый Структура("Сделка", Ссылка));
			Пока Выборка.Следующий() Цикл
				Запись = Выборка.ПолучитьМенеджерЗаписи();
				Запись.Потенциал = ПотенциальнаяСуммаПродажи;
				Запись.Записать();
			КонецЦикла;
		КонецЕсли;

		// зафиксировать изменение статуса
		ТекущийЭтап = СделкиСервер.ПолучитьТекущийЭтап(Ссылка);
		Если Ссылка.Статус <> Статус
		   И ТекущийЭтап <> Справочники.СостоянияПроцессов.ПустаяСсылка() Тогда
			Если Статус = Перечисления.СтатусыСделок.Проиграна Тогда

				// зафиксировать проигрыш по процессу, управляемому "вручную"
				Запись = СделкиСервер.ПолучитьЗаписьСтатистики(Ссылка, ТекущийЭтап);
				Запись.Результат = Перечисления.СтатусыСделок.Проиграна;
				Запись.ДатаОкончания = ТекущаяДатаСеанса();
				Запись.Записать();

			ИначеЕсли Статус = Перечисления.СтатусыСделок.Выиграна Тогда

				ОтменаПроигрыша = (Ссылка.Статус = Перечисления.СтатусыСделок.Проиграна);
				
				// зафиксировать выигрыш по процессу, управляемому "вручную"
				СделкиСервер.ЗакрытьСтатистику(Ссылка, ТекущийЭтап, ОтменаПроигрыша);
			Иначе

				// отменить регистрацию выигрыша/проигрыша по процессу, управляемому "вручную"
				Запись = СделкиСервер.ПолучитьЗаписьСтатистики(Ссылка, ТекущийЭтап);
				Запись.Результат = Перечисления.СтатусыСделок.ВРаботе;
				Запись.ДатаОкончания = '0001.01.01';
				Запись.Записать();
			КонецЕсли;
		КонецЕсли;//зафиксировать изменение статуса
	КонецЕсли;//скорректировать статистику сделок
	
	Если Закрыта И НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Статус <> Перечисления.СтатусыСделок.Проиграна Тогда
		
		НайденныеСтроки = ПартнерыИКонтактныеЛица.НайтиСтроки(Новый Структура("ВыигралСделку",Истина));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			НайденнаяСтрока.ВыигралСделку = Ложь;
			
		КонецЦикла;
	КонецЕсли;
	
	ОбработатьИзменениеПометкиУдаления();
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Ответственный 					= Пользователи.ТекущийПользователь();
	Статус        					= Перечисления.СтатусыСделок.ВРаботе;
	ДатаНачала    					= ТекущаяДатаСеанса();
	ДатаОкончания					= Дата(1,1,1);
	Проиграна     					= Ложь;
	Закрыта       					= Ложь;
	ПереведенаНаУправлениеВРучную	= Ложь;
	ПричинаПроигрышаСделки 			= Справочники.ПричиныПроигрышаСделок.ПустаяСсылка();	

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.УстановитьПризнакАктивен(Ссылка,(НЕ Закрыта) И (Не ПометкаУдаления));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	СтрокаТаб = Таблица.Добавить();
	Если ЗначениеЗаполнено(Партнер) Тогда
		СтрокаТаб.ЗначениеДоступа = Партнер;
	Иначе
		// Всегда разрешено.
		СтрокаТаб.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНаборыЗначенийДоступа()

Процедура ОбработатьИзменениеПометкиУдаления()
	
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СделкиСКлиентами.ПометкаУдаления,
	               |	ЕСТЬNULL(ВидыСделокСКлиентами.ТипСделки, НЕОПРЕДЕЛЕНО) КАК ТипСделки
	               |ИЗ
	               |	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыСделокСКлиентами КАК ВидыСделокСКлиентами
	               |		ПО СделкиСКлиентами.ВидСделки = ВидыСделокСКлиентами.Ссылка
	               |ГДЕ
	               |	СделкиСКлиентами.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
    Выборка.Следующий();
	
	Если ПометкаУдаления = Выборка.ПометкаУдаления ИЛИ Выборка.ТипСделки <> Перечисления.ТипыСделокСКлиентами.ТиповаяПродажа Тогда
		Возврат;	
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ТиповаяПродажа.Ссылка
		|ИЗ
		|	БизнесПроцесс.ТиповаяПродажа КАК ТиповаяПродажа
		|ГДЕ
		|	ТиповаяПродажа.Предмет = &Сделка";
		
		Запрос.УстановитьПараметр("Сделка",Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Истина); 			
			
		КонецЦикла;		
		
	Иначе 
		
		СделкиСервер.ЗавершитьПроцессПродажи(Ссылка, ВидСделки.ТипСделки);
		ПереведенаНаУправлениеВРучную = Истина;
	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьУсловияПродаж()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	СоглашенияСКлиентами.Ссылка КАК Соглашение
	|ИЗ
	|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
	|ГДЕ
	|	СоглашенияСКлиентами.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту)
	|	И СоглашенияСКлиентами.Типовое
	|	И НЕ СоглашенияСКлиентами.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СоглашениеСКлиентом = Выборка.Соглашение;
		
	КонецЕсли;
КонецПроцедуры

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.ВидыЗапасов", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
