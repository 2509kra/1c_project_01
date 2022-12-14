
#Область ПрограммныйИнтерфейс

#Область ЭтикеткиИЦенники

// Возвращает данные для печати этикеток или ценников,
//	получает эти данные из модулей менеджеров объектов печати.
//
// Параметры:
//	Идентификатор	- Строка - может принимать значения "Ценники" или "Этикетки";
//	ОбъектыПечати	- Массив - массив ссылок на объекты для печати, ссылки должны быть одного типа;
//	ДополнительныеПараметры	- Структура - параметры печати.
//
// Возвращаемое значение:
//	Строка	-	адрес структуры во временном хранилище, содержащей данные для печати.
//
Функция ДанныеДляПечатиЦенниковИЭтикеток(Идентификатор, ОбъектыПечати, ДополнительныеПараметры) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыПечати[0]);
	
	СоответствиеОбъектов = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(ОбъектыПечати);
	Если СоответствиеОбъектов.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Печать этикеток и ценников для нескольких видов документов не поддерживается'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Идентификатор = "Ценники" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЦенников(ОбъектыПечати);	
	ИначеЕсли Идентификатор = "Этикетки" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЭтикеток(ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

// Возвращает данные для печати этикеток складских ячеек
//
// Параметры:
//  Идентификатор	 - Строка - Идентификатор команды печати,
//  ОбъектыПечати	- Массив - массив ссылок СправочникСсылка.СкладскиеЯчейки.
// 
// Возвращаемое значение:
//   - Строка	-	адрес структуры во временном хранилище, содержащей данные для печати.
//
Функция ДанныеДляПечатиЭтикетокСкладскиеЯчейки(Идентификатор, ОбъектыПечати) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Владелец КАК Склад,
	|	СкладскиеЯчейки.Помещение
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В(&Ячейки)";
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 1 Тогда
		ТекстИсключения = НСтр("ru = 'Выделены ячейки разных складских территорий (помещений).
			|Одновременно можно печатать этикетки только по ячейкам, принадлежащим одной складской территории (помещению).'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Выборка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Ссылка КАК Ячейка
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В ИЕРАРХИИ(&Ячейки)
	|	И НЕ СкладскиеЯчейки.ПометкаУдаления
	|	И НЕ СкладскиеЯчейки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	СкладскиеЯчейки.Код";
	
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	ТаблицаЯчеек = Запрос.Выполнить().Выгрузить();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склад", 	  Выборка.Склад);
	СтруктураПараметров.Вставить("Помещение", Выборка.Помещение);
	СтруктураПараметров.Вставить("Ячейки",    ТаблицаЯчеек);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураПараметров);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЭтикеткиИЦенники

// См. Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки
//
Функция ДанныеДляПечатиЭтикетокДоставки(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки(ОбъектыПечати);
	
КонецФункции

// См. Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты
//
Функция ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати);
	
КонецФункции

#КонецОбласти

#КонецОбласти