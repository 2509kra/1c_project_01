#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ВерсияПеречняСодержитГруппу35()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыПродукцииПоГруппамПриказаВЕТИС.ВидПродукцииИдентификатор КАК ВидПродукцииИдентификатор
	|ИЗ
	|	РегистрСведений.ВидыПродукцииПоГруппамВЕТИС КАК ВидыПродукцииПоГруппамПриказаВЕТИС
	|ГДЕ
	|	ВидыПродукцииПоГруппамПриказаВЕТИС.ГруппаПриказа = Значение(Перечисление.ГруппыПродукцииУполномоченныхЛиц.Группа35Строка1)";
	
	Возврат Не Запрос.Выполнить().Пустой()
	
КонецФункции

Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт

	Возврат ВерсияПеречняСодержитГруппу35();

КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра",             "РегистрСведений.ВидыПродукцииПоГруппамВЕТИС");
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ЭтоДвижения",                   Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыПродукцииПоГруппамПриказаВЕТИС.РольПользователя КАК РольПользователя,
	|	ВидыПродукцииПоГруппамПриказаВЕТИС.ГруппаПриказа КАК ГруппаПриказа,
	|	ВидыПродукцииПоГруппамПриказаВЕТИС.ВидПродукцииИдентификатор КАК ВидПродукцииИдентификатор
	|ИЗ
	|	РегистрСведений.ВидыПродукцииПоГруппамВЕТИС КАК ВидыПродукцииПоГруппамПриказаВЕТИС";
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	Если Данные.Количество() = 0
		И ОбщегоНазначения.РазделениеВключено() Тогда
		
		ОбработатьДанныеДляПереходаНаНовуюВерсию(Неопределено);
		
	Иначе
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	Если Параметры <> Неопределено Тогда
		УзелРегистрации = ПланыОбмена.ОбновлениеИнформационнойБазы.УзелПоОчереди(Параметры.Очередь);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ВидыПродукцииПоГруппамВЕТИС");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС.СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
		
		ДопустимыеЦелиВЕТИС.ЗаполнитьДанныеВРегистреВидыПродукцииПоГруппамПриказаВЕТИС();
		
		Если Параметры <> Неопределено Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелРегистрации, Метаданные.РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС);
			Параметры.ОбработкаЗавершена = Истина;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось обработать регистр ВидыПродукцииПоГруппамВЕТИС по причине: %1'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС,,
			ТекстСообщения);

		Если Параметры <> Неопределено Тогда
			Параметры.ОбработкаЗавершена = Ложь;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли