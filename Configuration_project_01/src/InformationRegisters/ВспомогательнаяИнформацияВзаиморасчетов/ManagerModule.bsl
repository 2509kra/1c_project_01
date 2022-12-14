
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет регистр вспомогательной информации по изменениям оперативных регистров расчетов.
// 
// Параметры:
// 	МенеджерВТ - МенеджерВременныхТаблиц - Менеджер, содержащий таблицу с изменениями.
// 	ЭтоРасчетыСКлиентами - Булево - это расчеты с клиентами.
Процедура ЗаполнитьВспомогательнуюИнформацию(МенеджерВТ, ЭтоРасчетыСКлиентами = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР КОГДА Изменения.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|						И Изменения.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|		ТОГДА Изменения.РасчетныйДокумент
	|		ИНАЧЕ Изменения.Документ
	|	КОНЕЦ                                           КАК РасчетныйДокумент,
	|	НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Изменения.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|							ТОГДА Изменения.ДатаРегистратора
	|						ИНАЧЕ Изменения.ДатаПлатежа
	|					КОНЕЦ , ДЕНЬ)      КАК ДатаПлановогоПогашения
	|ПОМЕСТИТЬ ИзмененияВспомогательнойИнформации
	|ИЗ
	|	РасчетыСКлиентамиИзменения КАК Изменения
	|ГДЕ
	|	Изменения.Сумма <> 0 ИЛИ Изменения.КОтгрузке <> 0 ИЛИ Изменения.КОплате <> 0
	|;
	|ВЫБРАТЬ
	|	Изменения.РасчетныйДокумент                                            КАК РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения                                       КАК ДатаПлановогоПогашения,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.Регистратор, Неопределено))                    КАК ДокументРегистратор,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СвязанныйДокумент, Неопределено))             КАК СвязанныйДокумент,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокОперации, Неопределено))                КАК ПорядокОперации,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокЗачетаПоДатеПлатежа, Неопределено))     КАК ПорядокЗачета,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ВалютаДокумента, Неопределено))                КАК ВалютаДокумента,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СтатьяДвиженияДенежныхСредств, Неопределено)) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	ИзмененияВспомогательнойИнформации КАК Изменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|			ПО Изменения.РасчетныйДокумент = Расчеты.Регистратор
	|				И Изменения.ДатаПлановогоПогашения = НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|																		ТОГДА Расчеты.ДатаРегистратора
	|																	ИНАЧЕ Расчеты.ДатаПлатежа
	|																КОНЕЦ , ДЕНЬ)
	|				И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Изменения.РасчетныйДокумент) <> ТИП(Документ.ПервичныйДокумент)
	|СГРУППИРОВАТЬ ПО
	|	Изменения.РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Изменения.РасчетныйДокумент                                            КАК РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения                                       КАК ДатаПлановогоПогашения,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.Регистратор, Неопределено))                    КАК ДокументРегистратор,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СвязанныйДокумент, Неопределено))             КАК СвязанныйДокумент,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокОперации, Неопределено))                КАК ПорядокОперации,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокЗачетаПоДатеПлатежа, Неопределено))     КАК ПорядокЗачета,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ВалютаДокумента, Неопределено))                КАК ВалютаДокумента,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СтатьяДвиженияДенежныхСредств, Неопределено)) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	ИзмененияВспомогательнойИнформации КАК Изменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|			ПО Изменения.РасчетныйДокумент = Расчеты.РасчетныйДокумент
	|				И Изменения.ДатаПлановогоПогашения = НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|																		ТОГДА Расчеты.ДатаРегистратора
	|																	ИНАЧЕ Расчеты.ДатаПлатежа
	|																КОНЕЦ , ДЕНЬ)
	|				И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Изменения.РасчетныйДокумент) = ТИП(Документ.ПервичныйДокумент)
	|СГРУППИРОВАТЬ ПО
	|	Изменения.РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения
	|;
	|УНИЧТОЖИТЬ ИзмененияВспомогательнойИнформации";
	Если НЕ ЭтоРасчетыСКлиентами Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"СКлиентами","СПоставщиками");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"КОтгрузке","КПоступлению");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РасчетныйДокумент.Установить(Выборка.РасчетныйДокумент);
		НаборЗаписей.Отбор.ДатаПлановогоПогашения.Установить(Выборка.ДатаПлановогоПогашения);
		Если Выборка.ДокументРегистратор <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЕсли;
		НаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.4.13.150";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("2e98001a-a454-4fe8-9a82-e3750d616798");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ДанныеОбновленыНаНовуюВерсию";
	Обработчик.Комментарий = НСтр("ru = 'Первоначальное заполнение регистра вспомогательной информации расчетов.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентами.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщиками.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.АвансовыйОтчет.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.АктВыполненныхРабот.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВводОстатков.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВзаимозачетЗадолженности.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВозвратТоваровМеждуОрганизациями.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВозвратТоваровОтКлиента.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВозвратТоваровПоставщику.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВыкупВозвратнойТарыКлиентом.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ГрафикИсполненияДоговора.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ЗаказКлиента.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ЗаказПоставщику.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.КорректировкаПриобретения.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.КорректировкаРеализации.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.КорректировкаРегистров.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОперацияПоПлатежнойКарте.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОперацияПоЯндексКассе.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетКомиссионера.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетКомиссионераОСписании.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетКомитенту.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетКомитентуОСписании.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетПоКомиссииМеждуОрганизациями.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ПередачаТоваровМеждуОрганизациями.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ПриобретениеТоваровУслуг.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ПриобретениеУслугПрочихАктивов.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ПриходныйКассовыйОрдер.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.РасходныйКассовыйОрдер.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.РеализацияУслугПрочихАктивов.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.СписаниеЗадолженности.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Документы.ТаможеннаяДекларацияИмпорт.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСКлиентами.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСПоставщиками.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

Функция ДанныеОбновленыНаНовуюВерсию(МетаданныеИОтбор = Неопределено) Экспорт
	
	Возврат НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, "РегистрСведений.ВспомогательнаяИнформацияВзаиморасчетов");
	
КонецФункции
	
// Обработчик обновления
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	ПолноеИмяРегистра = СоздатьНаборЗаписей().Метаданные().ПолноеИмя();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", ПолноеИмяРегистра);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА Расчеты.ДатаРегистратора
	|		ИНАЧЕ Расчеты.ДатаПлатежа
	|	КОНЕЦ , ДЕНЬ)                  КАК ДатаПлановогоПогашения,
	|	ВЫБОР КОГДА Расчеты.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|							И Расчеты.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|				ТОГДА Расчеты.РасчетныйДокумент
	|		ИНАЧЕ Расчеты.Регистратор
	|	КОНЕЦ                                           КАК РасчетныйДокумент
	|ПОМЕСТИТЬ ВтРасчеты
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|ГДЕ
	|	Расчеты.Активность
	|	И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|	И НЕ Расчеты.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА Расчеты.ДатаРегистратора
	|		ИНАЧЕ Расчеты.ДатаПлатежа
	|	КОНЕЦ , ДЕНЬ)        КАК ДатаПлановогоПогашения,
	|	ВЫБОР КОГДА Расчеты.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|							И Расчеты.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|				ТОГДА Расчеты.РасчетныйДокумент
	|		ИНАЧЕ Расчеты.Регистратор
	|	КОНЕЦ                                           КАК РасчетныйДокумент
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|ГДЕ
	|	Расчеты.Активность
	|	И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КПоступлению <> 0 ИЛИ Расчеты.КОплате <> 0)
	|	И НЕ Расчеты.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расчеты.ДатаПлановогоПогашения               КАК ДатаПлановогоПогашения
	|ИЗ ВтРасчеты КАК Расчеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВспомогательнаяИнформацияВзаиморасчетов КАК ВспомогательнаяИнформация
	|			ПО ВспомогательнаяИнформация.ДатаПлановогоПогашения = Расчеты.ДатаПлановогоПогашения
	|				И ВспомогательнаяИнформация.РасчетныйДокумент = Расчеты.РасчетныйДокумент
	|ГДЕ
	|	ВспомогательнаяИнформация.ДокументРегистратор ЕСТЬ NULL";
	
	НаборЗаписей = РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСКлиентами)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщиками) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеЗависимыхДанныхЗавершено();
		Возврат;
	КонецЕсли;
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	ЗапросДанных = Новый Запрос;
	ЗапросДанных.Текст = "
	|ВЫБРАТЬ
	|	РасчетныйДокумент                               КАК РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения                  КАК ДатаПлановогоПогашения,
	|	МИНИМУМ(Расчеты.ДокументРегистратор)            КАК ДокументРегистратор,
	|	МАКСИМУМ(Расчеты.СвязанныйДокумент)             КАК СвязанныйДокумент,
	|	МИНИМУМ(Расчеты.ПорядокОперации)                КАК ПорядокОперации,
	|	МИНИМУМ(Расчеты.ПорядокЗачета)                  КАК ПорядокЗачета,
	|	МИНИМУМ(Расчеты.ВалютаДокумента)                КАК ВалютаДокумента,
	|	МАКСИМУМ(Расчеты.СтатьяДвиженияДенежныхСредств) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР КОГДА Расчеты.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|							И Расчеты.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|				ТОГДА Расчеты.РасчетныйДокумент
	|			ИНАЧЕ Расчеты.Регистратор
	|		КОНЕЦ                                           КАК РасчетныйДокумент,
	|		НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|							ТОГДА Расчеты.ДатаРегистратора
	|						ИНАЧЕ Расчеты.ДатаПлатежа
	|					КОНЕЦ , ДЕНЬ)                       КАК ДатаПлановогоПогашения,
	|		Расчеты.Регистратор                             КАК ДокументРегистратор,
	|		Расчеты.СвязанныйДокумент                       КАК СвязанныйДокумент,
	|		Расчеты.ПорядокОперации                         КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа              КАК ПорядокЗачета,
	|		Расчеты.ВалютаДокумента                         КАК ВалютаДокумента,
	|		Расчеты.СтатьяДвиженияДенежныхСредств           КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	ГДЕ
	|		Расчеты.Активность
	|		И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|		И НЕ Расчеты.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|		И НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|								ТОГДА Расчеты.ДатаРегистратора
	|							ИНАЧЕ Расчеты.ДатаПлатежа
	|						КОНЕЦ , ДЕНЬ) = &ДатаПлановогоПогашения
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВЫБОР КОГДА Расчеты.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|							И Расчеты.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|				ТОГДА Расчеты.РасчетныйДокумент
	|			ИНАЧЕ Расчеты.Регистратор
	|		КОНЕЦ                                           КАК РасчетныйДокумент,
	|		НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|								ТОГДА Расчеты.ДатаРегистратора
	|							ИНАЧЕ Расчеты.ДатаПлатежа
	|					КОНЕЦ , ДЕНЬ)                       КАК ДатаПлановогоПогашения,
	|		Расчеты.Регистратор                             КАК ДокументРегистратор,
	|		Расчеты.СвязанныйДокумент                       КАК СвязанныйДокумент,
	|		Расчеты.ПорядокОперации                         КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа              КАК ПорядокЗачета,
	|		Расчеты.ВалютаДокумента                         КАК ВалютаДокумента,
	|		Расчеты.СтатьяДвиженияДенежныхСредств           КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|	ГДЕ
	|		Расчеты.Активность
	|		И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КПоступлению <> 0 ИЛИ Расчеты.КОплате <> 0)
	|		И НЕ Расчеты.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|		И НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1)
	|								ТОГДА Расчеты.ДатаРегистратора
	|							ИНАЧЕ Расчеты.ДатаПлатежа
	|						КОНЕЦ , ДЕНЬ) = &ДатаПлановогоПогашения) КАК Расчеты
	|СГРУППИРОВАТЬ ПО
	|	Расчеты.РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения";
	
	ОбновляемыеДанные.Свернуть("ДатаПлановогоПогашения");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", ПолноеИмяРегистра);
	Для Каждого ПорцияДанных Из ОбновляемыеДанные Цикл
	
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			ЭлементБлокировки.УстановитьЗначение("ДатаПлановогоПогашения", ПорцияДанных.ДатаПлановогоПогашения);
			Блокировка.Заблокировать();
			
			ЗапросДанных.УстановитьПараметр("ДатаПлановогоПогашения", ПорцияДанных.ДатаПлановогоПогашения);
			Результат = ЗапросДанных.Выполнить();
			Данные = Результат.Выгрузить();
			
			НаборЗаписей = РегистрыСведений[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ДатаПлановогоПогашения.Установить(ПорцияДанных.ДатаПлановогоПогашения);
			НаборЗаписей.Загрузить(Данные);
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
		
			ОтменитьТранзакцию();
			
			Шаблон = НСтр("ru = 'Не удалось записать данные в регистр %1 , по причине: %2'");
			ТекстСообщения = СтрШаблон(Шаблон,
				ПолноеИмяРегистра,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеРегистра,
				,
				ТекстСообщения);
		
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

Функция ОбновлениеЗависимыхДанныхЗавершено()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РежимВыполнения", Перечисления.РежимыВыполненияОбработчиков.Отложенно);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбработчикиОбновления.ИмяОбработчика КАК ИмяОбработчика,
		|	ОбработчикиОбновления.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления
		|ГДЕ
		|	ОбработчикиОбновления.ИмяОбработчика В (
		|		""РегистрыНакопления.РасчетыСКлиентами.ОбработатьДанныеДляПереходаНаНовуюВерсию"",
		|		""РегистрыНакопления.РасчетыСПоставщиками.ОбработатьДанныеДляПереходаНаНовуюВерсию"")
		|	И ОбработчикиОбновления.Статус В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыОбработчиковОбновления.Ошибка))
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбработчикиОбновления.Статус,
		|	ОбработчикиОбновления.ИмяОбработчика";
	СтатусыОбработчиков = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Обработчик Из СтатусыОбработчиков Цикл
		
		ТекстСообщения = НСтр("ru = 'Обновление зависимых данных завершено с ошибкой.
		|Не выполнен обработчик обновления'") + " """ + Обработчик.ИмяОбработчика + """";
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
