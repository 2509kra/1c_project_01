
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Выводит информационные ссылки на форме
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы.
//	ГруппаФормы - ГруппаФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//	ПутьКФорме - Строка - полный путь к форме.
//
Процедура ВывестиКонтекстныеСсылки(Форма, ГруппаФормы, КоличествоГрупп = 3, КоличествоСсылокВГруппе = 1, 
	ВыводитьСсылкуВсе = Истина, ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылокФормы = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылокФормы.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		// Добавление списка Информационных ссылок
		ИмяРеквизита = "ИнформационныеСсылки";
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		СформироватьГруппыВывода(
			Форма, ТаблицаСсылокФормы, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе);
		
	Исключение
		
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;	
		
КонецПроцедуры

// Заполняет элементы формы информационными ссылками.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//  МассивЭлементов - Массив Из ПолеФормы - массив элементов формы.
//  ЭлементВсеСсылки - ДекорацияФормы - элемент формы.
//  ПутьКФорме - Строка - путь к форме.
//
Процедура ЗаполнитьСтатическиеИнформационныеСсылки(Форма, МассивЭлементов, ЭлементВсеСсылки = Неопределено, 
	ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылок = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылок.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки);
		
		//@skip-warning СтроковыйЛитералСодержитОшибку - ошибка проверки
		Если ТипЗнч(ЭлементВсеСсылки) = Тип("ДекорацияТекстФормы") Тогда
			ОтображатьСсылку = ТаблицаСсылок.Количество() <= МассивЭлементов.Количество();
			ЭлементВсеСсылки.Видимость = ОтображатьСсылку;
		КонецЕсли;
		
		
	Исключение
		
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
	КонецПопытки;	
	
КонецПроцедуры

// Возвращает информационную ссылку по идентификатору.
//
// Параметры:
//	Идентификатор - Строка - идентификатор ссылки.
//
// Возвращаемое значение:
//	Структура - контекстная ссылка.
//
Функция КонтекстнаяСсылкаПоИдентификатору(Идентификатор) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("Адрес", "");
	ВозвращаемаяСтруктура.Вставить("Наименование", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Адрес КАК Адрес,
	|	ИнформационныеСсылкиДляФорм.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.Идентификатор = &ID
	|	И НЕ ИнформационныеСсылкиДляФорм.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ID", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВозвращаемаяСтруктура.Адрес = Выборка.Адрес;
		ВозвращаемаяСтруктура.Наименование = Выборка.Наименование;
		Прервать;
		
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;	
	
КонецФункции

// Возвращает все пространства имен информационных ссылок.
//
// Возвращаемое значение:
//  Массив из Строка - массив пространства имен информационных ссылок.
//
Функция ПространстваИменИнформационныхСсылок() Экспорт
	
	МассивПространств = Новый Массив;
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок());
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок_1_0_1_1());
	
	Возврат МассивПространств;	
	
КонецФункции

// Формирует список новостей.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	ТаблицаНовостей - ТаблицаЗначений - с колонками:
//	 * Наименование - Строка - заголовок новости.
//	 * Идентификатор - УникальныйИдентификатор - идентификатор новости.
//	 * Критичность - Число - критичность новости.
//	 * ВнешняяСсылка - Строка - адрес внешней ссылки.
//	КоличествоВыводимыхНовостей - Число - количество выводимых новостей на рабочем столе.
//
Процедура СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей, Знач КоличествоВыводимыхНовостей = 3) Экспорт
	
КонецПроцедуры

// Возвращает Истину, если установлена интеграция со службой поддержки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Булево - Истина, если установлена интеграция со службой поддержки.
Функция УстановленаИнтеграцияСоСлужбойПоддержки() Экспорт
		
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список макетов для информационных ссылок.
//
// Возвращаемое значение:
//  Массив Из ТекстовыйДокумент - массив общих макетов.
//
Функция ПолучитьОбщиеМакетыИнформационныхСсылок() Экспорт
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить(ПолучитьОбщийМакет("ИнформационныеСсылки_Общие"));
	
	ИнформационныйЦентрСерверПереопределяемый.ОбщиеМакетыСИнформационнымиСсылками(МассивМакетов);
	
	Возврат МассивМакетов;
	
КонецФункции

// Формирует хеш полного пути к форме при записи.
//
Процедура ПолныйПутьКФормеПередЗаписьюПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Источник.ПолныйПутьКФорме) Тогда 
		Источник.Хеш = ХешПолногоПутиКФорме(Источник.ПолныйПутьКФорме);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает хеш полного пути к форме по алгоритму.
//
// Параметры:
//	ПолныйПутьКФорме - Строка - полный путь к форме.
//
// Возвращаемое значение:
//	Строка - хэш.
//
Функция ХешПолногоПутиКФорме(Знач ПолныйПутьКФорме) Экспорт
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ПолныйПутьКФорме);
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Возвращает имя события журнала регистрации.
//
// Возвращаемое значение:
//	Строка - имя события журнала регистрации.
//
Функция ПолучитьИмяСобытияДляЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Информационный центр'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Процедура регламентного задания ЧтениеНовостейСлужбыПоддержки
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЧтениеНовостейСлужбыПоддержки() Экспорт

КонецПроцедуры

// Возвращает Прокси Информационного центра Менеджера сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_1() Экспорт
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок()
	
	Возврат "http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/InformationReferences";
	
КонецФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences_1_0_1_1"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок_1_0_1_1()
	
	Возврат "http://www.1c.ru/1cFresh/InformationCenter/InformationReferences/1.0.1.1";
	
КонецФункции

// Формирует элементы формы информационных ссылок в группе.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы:
//  * ИнформационныеСсылки - СписокЗначений - значения информационных ссылок.
//	ТаблицаСсылок - см. ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки
//	ГруппаФормы - ГруппаФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура СформироватьГруппыВывода(Форма, ТаблицаСсылок, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, 
	ВыводитьСсылкуВсе)
	
	КоличествоСсылок = ?(ТаблицаСсылок.Количество() > КоличествоГрупп * КоличествоСсылокВГруппе, 
		КоличествоГрупп * КоличествоСсылокВГруппе, ТаблицаСсылок.Количество());
	
	КоличествоГрупп = ?(КоличествоСсылок < КоличествоГрупп, КоличествоСсылок, КоличествоГрупп);
	
	НеполноеНаименованиеГруппы = "ГруппаИнформационныхСсылок";
	
	Для Итерация = 1 По КоличествоГрупп Цикл 
		
		ИмяЭлементаФормы = НеполноеНаименованиеГруппы + Строка(Итерация);
		РодительскаяГруппа = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
		РодительскаяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		РодительскаяГруппа.ОтображатьЗаголовок = Ложь;
		РодительскаяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительскаяГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
		
	КонецЦикла;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ГруппаСсылки = ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, Итерация);
		
		ДанныеСсылки = ТаблицаСсылок.Получить(Итерация - 1);
		ИмяСсылки = ДанныеСсылки.Наименование;
		Адрес = ДанныеСсылки.Адрес;
		
		ЭлементСсылки = 
			Форма.Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаСсылки);
		ЭлементСсылки.Вид = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.АвтоМаксимальнаяШирина = Ложь;
		ЭлементСсылки.Высота = 1;
		Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ЭлементСсылки);
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
	Если ВыводитьСсылкуВсе Тогда
		Элемент = Форма.Элементы.Добавить("СсылкаВсеИнформационныеСсылки", Тип("ДекорацияФормы"), ГруппаФормы);
		Элемент.Вид = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок = НСтр("ru = 'Все'");
		Элемент.Гиперссылка = Истина;
		Элемент.ЦветТекста = WebЦвета.Черный;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки")
	КонецЕсли;
	
КонецПроцедуры

// Заполняет элементы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма:
//  * ИнформационныеСсылки - СписокЗначений - значения информационных ссылок.
//  ТаблицаСсылок - ТаблицаЗначений - таблица ссылок.
//  МассивЭлементов - Массив - массив элементов формы.
//  ЭлементВсеСсылки - ДекорацияФормы -  надпись "Все".
//
Процедура ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки)
	
	Для Итерация = 0 По МассивЭлементов.Количество() -1 Цикл
		
		ДанныеСсылки = ТаблицаСсылок.Получить(Итерация);
		
		ЭлементСсылки = МассивЭлементов.Получить(Итерация);
		ЭлементСсылки.Заголовок = ДанныеСсылки.Наименование;
		Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ЭлементСсылки);
		ЭлементСсылки.Подсказка = ДанныеСсылки.Подсказка;
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, ДанныеСсылки.Адрес);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает группу, в которой необходимо выводить информационные ссылки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы.
//	КоличествоГрупп - Число - количество групп с информационными ссылками на форме.
//	НеполноеНаименованиеГруппы - Строка - неполное наименование группы.
//	ТекущаяИтерация - Число - текущая итерация.
//
// Возвращаемое значение:
//	ГруппаФормы - группа информационных ссылок или неопределенно.
//
Функция ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, ТекущаяИтерация)
	
	ИмяГруппы = "";
	
	Для ИтерацияГрупп = 1 По КоличествоГрупп Цикл
		
		Если ТекущаяИтерация % ИтерацияГрупп  = 0 Тогда 
			ИмяГруппы = НеполноеНаименованиеГруппы + Строка(ИтерацияГрупп);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Форма.Элементы.Найти(ИмяГруппы);
	
КонецФункции

#КонецОбласти