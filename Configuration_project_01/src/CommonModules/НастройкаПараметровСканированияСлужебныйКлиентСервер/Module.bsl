#Область СлужебныйПрограммныйИнтерфейс

// Формирует структуру текстового описания настроенных исключений.
// 
// Параметры:
// 	ГруппаНастроек           - см. ЗначениеГруппыНастроек
// 	УровеньСокращенияДеталей - Неопределено, Число - Количество элементов для включения в описание.
// 	ТранспонироватьПоВидуОтображения - Булево - Признак перегруппировки исходных значений исключений.
// Возвращаемое значение:
// 	Структура - Описание:
// * ПолноеВОднуСтроку - Строка - Полное описание в одну строку (например, для протокола обмена).
// * Полное            - Строка - Полное описание.
// * Краткое           - Строка - Краткое (сокращенное) описание.
Функция ПредставленияИсключения(ГруппаНастроек, УровеньСокращенияДеталей = Неопределено, ТранспонироватьПоВидуОтображения = Истина) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Краткое",           "");
	ВозвращаемоеЗначение.Вставить("Полное",            "");
	ВозвращаемоеЗначение.Вставить("ПолноеВОднуСтроку", "");
	
	Исключения = ГруппаНастроек.Исключения;
	
	Если ТранспонироватьПоВидуОтображения
		И ГруппаНастроек.ВариантОтображения <> НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ВариантОтображенияПоВидамПродукции() Тогда
		
		Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
			Исключения,
			НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций().ВыгрузитьЗначения(),
			ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции());
		
	КонецЕсли;
	
	ИсключенияСДетализациями = Новый СписокЗначений();
	ИсключенияБезДетализаций = Новый СписокЗначений();
	
	ЗначенияПредставления         = Новый Массив();
	ЗначенияКарткогоПредставления = Новый Массив();
	
	Для Каждого КлючИЗначение Из Исключения Цикл
		
		Если КлючИЗначение.Значение.Количество() Тогда
			
			ДанныеПредставления = Новый Массив();
			ДанныеПредставления.Добавить(НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(КлючИЗначение.Ключ));
			
			ДанныеЗначенияПредставления = Новый СписокЗначений();
			
			Для Каждого КлючИЗначениеНастроенное Из КлючИЗначение.Значение Цикл
				ДанныеЗначенияПредставления.Добавить(НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(КлючИЗначениеНастроенное.Ключ));
			КонецЦикла;
			
			ДанныеЗначенияПредставления.СортироватьПоЗначению();
			
			Если УровеньСокращенияДеталей = Неопределено Тогда
				ДанныеПредставления.Добавить(СтрСоединить(ДанныеЗначенияПредставления.ВыгрузитьЗначения(), ", "));
			Иначе
				ДанныеСокращения = ДанныеСокращения(ДанныеЗначенияПредставления.ВыгрузитьЗначения(), УровеньСокращенияДеталей);
				ДанныеПредставления.Добавить(ДанныеСокращения.Текст);
			КонецЕсли;
			
			ЗначениеПредставления = СтрСоединить(ДанныеПредставления, ": ");
			ИсключенияСДетализациями.Добавить(ЗначениеПредставления);
			ЗначенияКарткогоПредставления.Добавить(ЗначениеПредставления);
			
		Иначе
			
			Представление = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(КлючИЗначение.Ключ);
			ИсключенияБезДетализаций.Добавить(Представление);
			ЗначенияКарткогоПредставления.Добавить(Представление);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИсключенияБезДетализаций.Количество() Тогда
		ИсключенияБезДетализаций.СортироватьПоЗначению();
		ЗначенияПредставления.Добавить(СтрСоединить(ИсключенияБезДетализаций.ВыгрузитьЗначения(), "; "));
	КонецЕсли;
	
	ИсключенияСДетализациями.СортироватьПоЗначению();
	Для Каждого ЭлементСписка Из ИсключенияСДетализациями Цикл
		ЗначенияПредставления.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
	ДанныеСокращения = ДанныеСокращения(ЗначенияКарткогоПредставления, 2);
	Если ЗначениеЗаполнено(ДанныеСокращения.Текст) Тогда
		ВозвращаемоеЗначение.Краткое = СтрШаблон(
			НСтр("ru = 'Исключения: %1'"),
			ДанныеСокращения.Текст);
	КонецЕсли;
	
	Если ЗначенияПредставления.Количество() Тогда
		
		ВозвращаемоеЗначение.ПолноеВОднуСтроку = СтрШаблон(
			НСтр("ru = 'Исключения: %1'"),
			СтрСоединить(ЗначенияПредставления, "; "));
			
		Если ЗначенияПредставления.Количество() = 1 Тогда
			РазделительПолногоПредставления = Символы.ПС;
		Иначе
			РазделительПолногоПредставления = Символы.ПС + "- ";
		КонецЕсли;
		
		ЗначенияПредставления.Вставить(0, НСтр("ru = 'Исключения:'"));
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.Полное = СтрСоединить(ЗначенияПредставления, РазделительПолногоПредставления);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает группу настроек сканирования по имени параметра.
// 
// Параметры:
// 	НастройкиСканирования - см. ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки
// 	ИмяПараметра          - Строка - Идентификатор параметра.
// Возвращаемое значение:
// 	см. НоваяГруппаПараметровНастройки
Функция ЗначениеГруппыНастроек(НастройкиСканирования, ИмяПараметра) Экспорт
	
	ВозвращаемоеЗначение = НоваяГруппаПараметровНастройки();
	ТекущееЗначение      = НастройкиСканирования[ИмяПараметра];
	
	Если ТекущееЗначение <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, ТекущееЗначение);
	КонецЕсли;
	
	НастройкиСканирования[ИмяПараметра] = ВозвращаемоеЗначение;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Группа настроек параметра сканирования.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Исключения - Соответствие - Исключения по виду продукции и операциям
// * Включено   - Булево       - Признак включения настройки.
Функция НоваяГруппаПараметровНастройки() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Включено",           Ложь);
	ВозвращаемоеЗначение.Вставить("ВариантОтображения", НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ВариантОтображенияПоВидамПродукции());
	ВозвращаемоеЗначение.Вставить("Исключения",         Новый Соответствие());
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Описание
// 
// Параметры:
// 	ВходящееЗначенияИсключения
// 	ПолныйСписокКлючей - Массив - Описание
// 	ПолныйСписокВложенных - ФиксированныйМассив из ПеречислениеСсылка.ВидыПродукцииИС - Описание
// Возвращаемое значение:
// 	Соответствие - Описание
Функция ТранспонироватьЗначенияИсключения(ВходящееЗначенияИсключения, ПолныйСписокКлючей, ПолныйСписокВложенных) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие();
	
	Для Каждого КлючИЗначение Из ВходящееЗначенияИсключения Цикл
		
		Если КлючИЗначение.Значение.Количество() = 0 Тогда
			
			Для Каждого ВложенноеЗначение Из ПолныйСписокКлючей Цикл
				
				КоллекцияВложенныхЗначений = НайтиСоздатьЗначениеНастройки(
					ВозвращаемоеЗначение,
					ВложенноеЗначение);
				
				КоллекцияВложенныхЗначений.Вставить(КлючИЗначение.Ключ, Истина);
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого ВложенноеЗначение Из КлючИЗначение.Значение Цикл
				
				КоллекцияВложенныхЗначений = НайтиСоздатьЗначениеНастройки(
					ВозвращаемоеЗначение,
					ВложенноеЗначение.Ключ);
				
				КоллекцияВложенныхЗначений.Вставить(КлючИЗначение.Ключ, Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ВозвращаемоеЗначение Цикл
		
		ВыбранныеВложенные = Новый Массив;
		ВложенныеДанные    = КлючИЗначение.Значение;
		
		Для Каждого КлючИЗначениеВложенные Из ВложенныеДанные Цикл
			ВыбранныеВложенные.Добавить(КлючИЗначениеВложенные.Ключ);
		КонецЦикла;
		
		ОставшиесяОперации = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ПолныйСписокВложенных, ВыбранныеВложенные);
		
		Если ОставшиесяОперации.Количество() = 0 Тогда
			ВложенныеДанные.Очистить();
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполняет сокращение входных данных по количеству элементов.
// 
// Параметры:
// 	ВходящийСписок      - Массив - Сокращаемые элементы.
// 	КоличествоЭлементов - Число  - Сколько элементов оставить в представлении.
// Возвращаемое значение:
// 	Структура - Описание:
// * Идентификатор - Строка - Идентификатор сокращенного значения.
// * Текст         - Строка - Сокращенное значение.
Функция ДанныеСокращения(ВходящийСписок, КоличествоЭлементов = 2) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Текст",         "");
	ВозвращаемоеЗначение.Вставить("Идентификатор", "");
	
	СколькоЕще   = 0;
	ДанныеХэша   = Новый СписокЗначений();
	ДанныеТекста = Новый Массив();
	
	Если ТипЗнч(ВходящийСписок) = Тип("Массив") Тогда
		СписокДляОбработки = Новый СписокЗначений();
		СписокДляОбработки.ЗагрузитьЗначения(ВходящийСписок);
	Иначе
		СписокДляОбработки = ВходящийСписок;
	КонецЕсли;
	
	Для Каждого Элемент Из СписокДляОбработки Цикл
		
		Если ДанныеТекста.Количество() >= КоличествоЭлементов Тогда
			СколькоЕще = СколькоЕще + 1;
		ИначеЕсли ЗначениеЗаполнено(Элемент.Представление) Тогда
			ДанныеТекста.Добавить(Элемент.Представление);
		Иначе
			ДанныеТекста.Добавить(Элемент.Значение);
		КонецЕсли;
		
		ДанныеХэша.Добавить(СокрЛП(Элемент.Значение));
		
	КонецЦикла;
	
	Если СколькоЕще = 0 Тогда
		ТекстЕще = "";
	Иначе
		ТекстЕще = СтрШаблон(НСтр("ru = '%1( + еще %2)'"), " ", СколькоЕще);
	КонецЕсли;
	
	ДанныеХэша.СортироватьПоЗначению();
	ВозвращаемоеЗначение.Текст         = СтрШаблон("%1%2", СтрСоединить(ДанныеТекста, ", "), ТекстЕще);
	ВозвращаемоеЗначение.Идентификатор = СтрСоединить(ДанныеХэша.ВыгрузитьЗначения(), "|");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Добавляет в группу настроек переданную настройку со значением.
// 
// Параметры:
// 	ГруппаНастрек - см. НоваяГруппаПараметровНастройки
// 	Настройка     - ПеречислениеСсылка.ВидыОперацийИСМП, ПеречислениеСсылка.ВидыПродукцииИС               - Настройка.
// 	Значение      - ПеречислениеСсылка.ВидыПродукцииИС, ПеречислениеСсылка.ВидыОперацийИСМП, Неопределено - Значение настройки.
Процедура ДобавитьВИсключение(ГруппаНастрек, Настройка, Значение = Неопределено) Экспорт
	
	КоллекцияЗначения = НайтиСоздатьЗначениеНастройки(
		ГруппаНастрек.Исключения,
		Настройка);
	
	Если ЗначениеЗаполнено(Значение) Тогда
		КоллекцияЗначения.Вставить(Значение, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Переносит множество из ограничивающей настройки во множество целевой настройки.
// 
// Параметры:
// 	ЦелеваяНастройка - см. НоваяГруппаПараметровНастройки.
// 	Ограничения      - см. НоваяГруппаПараметровНастройки.
Процедура ПрименитьОграничение(ЦелеваяНастройка, Ограничения) Экспорт
	
	Для Каждого КлючИЗначениеВидПродукции Из Ограничения.Исключения Цикл
		
		Если КлючИЗначениеВидПродукции.Значение.Количество() = 0 Тогда
			
			НайтиСоздатьЗначениеНастройки(
				ЦелеваяНастройка.Исключения,
				КлючИЗначениеВидПродукции.Ключ);
			
		Иначе
			
			Для Каждого КлючИЗначениеОперация Из КлючИЗначениеВидПродукции.Значение Цикл
				
				ЗначениеПоВидуПродукции = НайтиСоздатьЗначениеНастройки(
					ЦелеваяНастройка.Исключения,
					КлючИЗначениеВидПродукции.Ключ);
				
				НайтиСоздатьЗначениеНастройки(
					ЗначениеПоВидуПродукции,
					КлючИЗначениеОперация.Ключ,
					КлючИЗначениеОперация.Значение);
				
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Функция НайтиСоздатьЗначениеНастройки(Коллекция, Ключ, НовоеЗначение = Неопределено)
	
	ЗначениеПоВидуПродукции = Коллекция.Получить(Ключ);
	
	Если ЗначениеПоВидуПродукции = Неопределено Тогда
		Если НовоеЗначение = Неопределено Тогда
			ЗначениеПоВидуПродукции = Новый Соответствие();
		Иначе
			ЗначениеПоВидуПродукции = НовоеЗначение;
		КонецЕсли;
		Коллекция.Вставить(Ключ, ЗначениеПоВидуПродукции);
	КонецЕсли;
	
	Возврат ЗначениеПоВидуПродукции;
	
КонецФункции

#КонецОбласти

#КонецОбласти
