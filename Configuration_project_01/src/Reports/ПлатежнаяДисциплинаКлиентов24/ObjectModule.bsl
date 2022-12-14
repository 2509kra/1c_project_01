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
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета,"ДанныеОтчета");
	Если ПараметрДанныеОтчета.Значение = 2 Тогда 
		ВалютаОтчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли ПараметрДанныеОтчета.Значение = 3 Тогда
		ВалютаОтчета = Константы.ВалютаУправленческогоУчета.Получить();
	Иначе
		Валюта = Неопределено;
	КонецЕсли;
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса(ПараметрДанныеОтчета.Значение);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	ПараметрДатаОтчетаГраница = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "КонецПериодаГраница");
	ПараметрДатаОтчетаГраница.Использование = Истина;

	ПараметрПериод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период");
	Период = ПараметрПериод.Значение; // СтандартныйПериод
	Если ПараметрПериод.Использование И ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(Период.ДатаОкончания), ВидГраницы.Включая);
	Иначе
		ПараметрДатаОтчетаГраница.Значение = Дата(1,1,1)
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалютСквознаяСебестоимость(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Функция ТекстЗапроса(ВалютаОтчета)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыОтчета.Кратность / (КурсВалюты.Кратность * КурсВалютыОтчета.Курс) КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериода}, ) КАК КурсВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериодаОтчета}, Валюта = &Валюта) КАК КурсВалютыОтчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыОтчета.Курс <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|//Остатки по фактической задолженности на конец периода отчета
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчета.Организация                                     КАК Организация,
	|	АналитикаУчета.Партнер                                         КАК Партнер,
	|	АналитикаУчета.Контрагент                                      КАК Контрагент,
	|	АналитикаУчета.Договор                                         КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|	РасчетыПоСрокам.ОбъектРасчетов                                 КАК ОбъектРасчетов,
	|	РасчетыПоСрокам.РасчетныйДокумент                              КАК РасчетныйДокумент,
	|	РасчетыПоСрокам.Валюта                                         КАК Валюта,
	|	
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(РасчетыПоСрокам.ДатаПлановогоПогашения, &КонецПериода, ДЕНЬ) < 0
	|			ИЛИ РасчетыПоСрокам.ДатаПлановогоПогашения < &НачалоПериода
	|			ИЛИ РасчетыПоСрокам.ДатаПлановогоПогашения > &КонецПериода
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(РасчетыПоСрокам.ДатаПлановогоПогашения, &КонецПериода, ДЕНЬ)
	|	КОНЕЦ                                                          КАК ДлительностьПросрочки,
	|	ВЫБОР
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения >= &НачалоПериода
	|				И РасчетыПоСрокам.ДатаПлановогоПогашения <= &КонецПериода
	|				И НЕ РасчетыПоСрокам.РасчетныйДокумент ССЫЛКА Документ.СписаниеЗадолженности
	|			ТОГДА РасчетыПоСрокам.ДолгРеглОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ                                                          КАК ДолгКлиентаПросроченоВПериоде,
	|	РасчетыПоСрокам.ДолгРеглОстаток                                КАК ДолгКлиента,
	|	ВЫБОР 
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < &КонецПериода
	|			ТОГДА РасчетыПоСрокам.ДолгРеглОстаток
	|		ИНАЧЕ 0 
	|	КОНЕЦ                                                          КАК ДолгКлиентаПросрочено
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки({&КонецПериодаГраница}) КАК РасчетыПоСрокам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыПоСрокам.АналитикаУчетаПоПартнерам
	|ГДЕ
	|	РасчетыПоСрокам.ДолгРеглОстаток > 0
	|	И Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие) И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 1)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|//Остатки по плановой задолженности на конец периода отчета
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация               КАК Организация,
	|	АналитикаУчета.Партнер                   КАК Партнер,
	|	АналитикаУчета.Контрагент                КАК Контрагент,
	|	АналитикаУчета.Договор                   КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|	РасчетыПланОплат.ОбъектРасчетов          КАК ОбъектРасчетов,
	|	РасчетыПланОплат.ДокументПлан            КАК РасчетныйДокумент,
	|	РасчетыПланОплат.Валюта                  КАК Валюта,
	|	
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(РасчетыПланОплат.ДатаПлановогоПогашения, &КонецПериода, ДЕНЬ) < 0
	|			ИЛИ РасчетыПланОплат.ДатаПлановогоПогашения < &НачалоПериода
	|			ИЛИ РасчетыПланОплат.ДатаПлановогоПогашения > &КонецПериода
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(РасчетыПланОплат.ДатаПлановогоПогашения, &КонецПериода, ДЕНЬ)
	|	КОНЕЦ                                    КАК ДлительностьПросрочки,
	|	ВЫБОР
	|		КОГДА РасчетыПланОплат.ДатаПлановогоПогашения >= &НачалоПериода
	|				И РасчетыПланОплат.ДатаПлановогоПогашения <= &КонецПериода
	|			ТОГДА РасчетыПланОплат.КОплатеОстаток * ЕСТЬNULL(Курсы.Коэффициент,1)
	|		ИНАЧЕ 0
	|	КОНЕЦ                                    КАК ДолгКлиентаПросроченоВПериоде,
	|	РасчетыПланОплат.КОплатеОстаток
	|		* ЕСТЬNULL(Курсы.Коэффициент,1)      КАК ДолгКлиента,
	|	ВЫБОР 
	|		КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < &КонецПериода
	|			ТОГДА РасчетыПланОплат.КОплатеОстаток * ЕСТЬNULL(Курсы.Коэффициент,1)
	|		ИНАЧЕ 0 
	|	КОНЕЦ                                    КАК ДолгКлиентаПросрочено
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат.Остатки({&КонецПериодаГраница}) КАК РасчетыПланОплат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыПланОплат.АналитикаУчетаПоПартнерам
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|			ПО Курсы.Валюта = РасчетыПланОплат.Валюта
	|ГДЕ
	|	РасчетыПланОплат.КОплатеОстаток > 0
	|	И ТИПЗНАЧЕНИЯ(РасчетыПланОплат.ДокументПлан) В (&ТипыДокументовПлана)
	|	И Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие) И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|//Обороты по фактической задолженности
	|ВЫБРАТЬ
	|	Аналитика.Организация                  КАК Организация,
	|	Аналитика.Партнер                      КАК Партнер,
	|	Аналитика.Контрагент                   КАК Контрагент,
	|	Аналитика.Договор                      КАК Договор,
	|	Аналитика.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|	РасчетыОбороты.ОбъектРасчетов          КАК ОбъектРасчетов,
	|	РасчетыОбороты.РасчетныйДокумент       КАК РасчетныйДокумент,
	|	РасчетыОбороты.Валюта                  КАК Валюта,
	|	
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(РасчетыОбороты.ДатаПлановогоПогашения, РасчетыОбороты.Период, ДЕНЬ) < 0
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(РасчетыОбороты.ДатаПлановогоПогашения, РасчетыОбороты.Период, ДЕНЬ)
	|	КОНЕЦ                                  КАК ДлительностьПросрочки,
	|	
	|	ВЫБОР
	|		КОГДА РасчетыОбороты.ДатаПлановогоПогашения >= &НачалоПериода
	|				И РасчетыОбороты.ДатаПлановогоПогашения <= &КонецПериода
	|				И НЕ РасчетыОбороты.РасчетныйДокумент ССЫЛКА Документ.СписаниеЗадолженности
	|			ТОГДА РасчетыОбороты.ДолгРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ                                  КАК ДолгКлиентаПросроченоВПериоде,
	|	0                                      КАК ДолгКлиента,
	|	0                                      КАК ДолгКлиентаПросрочено
	|	
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК РасчетыОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|			ПО Аналитика.КлючАналитики = РасчетыОбороты.АналитикаУчетаПоПартнерам
	|ГДЕ
	|	РасчетыОбороты.ДолгРегл > 0
	|	И РасчетыОбороты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И РасчетыОбороты.Период >= &НачалоПериода
	|	И РасчетыОбороты.Период <= &КонецПериода
	|	И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 1)
	|{ГДЕ
	|	Аналитика.Организация.* КАК Организация,
	|	Аналитика.Партнер.* КАК Партнер,
	|	Аналитика.Контрагент.* КАК Контрагент,
	|	Аналитика.Договор.* КАК Договор,
	|	Аналитика.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(Аналитика.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Аналитика.Организация                                   КАК Организация,
	|	Аналитика.Партнер                                       КАК Партнер,
	|	Аналитика.Контрагент                                    КАК Контрагент,
	|	Аналитика.Договор                                       КАК Договор,
	|	Аналитика.НаправлениеДеятельности                       КАК НаправлениеДеятельности,
	|	РасчетыОбороты.ОбъектРасчетов                           КАК ОбъектРасчетов,
	|	РасчетыОбороты.ДокументПлан                             КАК РасчетныйДокумент,
	|	РасчетыОбороты.Валюта                                   КАК Валюта,
	|	
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(РасчетыОбороты.ДатаПлановогоПогашения,
	|				РасчетыОбороты.Период, ДЕНЬ) < 0
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(РасчетыОбороты.ДатаПлановогоПогашения,
	|				РасчетыОбороты.Период, ДЕНЬ)
	|	КОНЕЦ                                                   КАК ДлительностьПросрочки,
	|	
	|	ВЫБОР
	|		КОГДА РасчетыОбороты.ДатаПлановогоПогашения >= &НачалоПериода
	|				И РасчетыОбороты.ДатаПлановогоПогашения <= &КонецПериода
	|			ТОГДА РасчетыОбороты.КОплате * ЕСТЬNULL(Курсы.Коэффициент,1)
	|		ИНАЧЕ 0
	|	КОНЕЦ                                                   КАК ДолгКлиентаПросроченоВПериоде,
	|	0                                                       КАК ДолгКлиента,
	|	0                                                       КАК ДолгКлиентаПросрочено
	|	
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат КАК РасчетыОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|			ПО Курсы.Валюта = РасчетыОбороты.Валюта
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|			ПО Аналитика.КлючАналитики = РасчетыОбороты.АналитикаУчетаПоПартнерам
	|ГДЕ
	|	РасчетыОбороты.КОплате > 0
	|	И РасчетыОбороты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И РасчетыОбороты.Период >= &НачалоПериода
	|	И РасчетыОбороты.Период <= &КонецПериода
	|	И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	Аналитика.Организация.* КАК Организация,
	|	Аналитика.Партнер.* КАК Партнер,
	|	Аналитика.Контрагент.* КАК Контрагент,
	|	Аналитика.Договор.* КАК Договор,
	|	Аналитика.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(Аналитика.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}";
	
	Если ВалютаОтчета = 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","");
	ИначеЕсли ВалютаОтчета = 2 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","Упр");
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ТипыДокументовПлана", ПолучитьТипыДокументовПлана());
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ПолучитьТипыДокументовПлана()
	
	ТекстТиповДокументов = ""; 
	
	
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаказКлиента), ";
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаявкаНаВозвратТоваровОтКлиента), ";
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ГрафикИсполненияДоговора)";
	
	Возврат ТекстТиповДокументов;
КонецФункции

#КонецОбласти

#КонецЕсли