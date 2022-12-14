#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ИнформацияОбОператореЭДОУчетнойЗаписи(УчетнаяЗапись) Экспорт
	
	ТаблицаОператоровЭДО = ОбменСКонтрагентамиСлужебныйПовтИсп.ТаблицаОператоровЭДО();
	ОператорЭДО = Неопределено;
	
	Для Каждого Оператор Из ТаблицаОператоровЭДО Цикл
		
		Если Лев(ВРег(УчетнаяЗапись), СтрДлина(Оператор.ИдентификаторОператора)) = ВРег(Оператор.ИдентификаторОператора) Тогда
			ОператорЭДО = Оператор.ИдентификаторОператора;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ОператорЭДО) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИдентификаторОператора КАК ИдентификаторОператора,
		|	ОператорыЭДО.Представление КАК Представление,
		|	ОператорыЭДО.ИНН КАК ИНН,
		|	ОператорыЭДО.КПП КАК КПП,
		|	ОператорыЭДО.ОГРН КАК ОГРН,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	ОператорыЭДО.ОтпечатокСертификата КАК ОтпечатокСертификата,
		|	ОператорыЭДО.ДоступноПодключениеЧерез1С КАК ДоступноПодключениеЧерез1С,
		|	ОператорыЭДО.ОтправлятьДополнительныеСведения КАК ОтправлятьДополнительныеСведения,
		|	ОператорыЭДО.СсылкаНаСтраницуТехническойПоддержки КАК СсылкаНаСтраницуТехническойПоддержки
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО
		|ГДЕ
		|	ОператорыЭДО.ИдентификаторОператора = &ОператорЭДО";
	
	Запрос.УстановитьПараметр("ОператорЭДО", ОператорЭДО);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанныхОбОператореЭДО = РезультатЗапроса.Выгрузить();
	
	Результат = Неопределено;
	
	Если ТаблицаДанныхОбОператореЭДО.Количество() > 0 Тогда
		Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаДанныхОбОператореЭДО[0]);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаОператоровЭДО() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИдентификаторОператора КАК ИдентификаторОператора,
		|	ОператорыЭДО.Представление КАК Представление,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	ОператорыЭДО.СсылкаНаСтраницуТехническойПоддержки КАК СсылкаНаСтраницуТехническойПоддержки
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// Получает данные оператора ЭДО по идентификатору
Функция АктуальныеДанныеОператораЭДО(ОператорЭДО) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИНН КАК ИНН,
		|	ОператорыЭДО.КПП КАК КПП,
		|	ОператорыЭДО.ОГРН КАК ОГРН,
		|	ОператорыЭДО.ОтпечатокСертификата КАК Сертификат,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбмена,
		|	ОператорыЭДО.ИдентификаторОператора КАК Код,
		|	ОператорыЭДО.Представление КАК Наименование
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО
		|ГДЕ
		|	ОператорыЭДО.ИдентификаторОператора = &ИдентификаторОператора";
	
	Запрос.УстановитьПараметр("ИдентификаторОператора", ОператорЭДО);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтрокаРезультат = РезультатЗапроса.Выгрузить()[0];
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаРезультат);
	
КонецФункции

#КонецОбласти

#КонецЕсли
