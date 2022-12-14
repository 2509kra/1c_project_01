////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Формирует имя для поиска настроек идентификатора сертификата в безопасном хранилище.
// 
// Параметры:
//	ИдентификаторСертификата - Строка - ключ поиска настроек
//
// Возвращаемое значение:
//	Строка - имя настройки.
//
Функция ИмяНастройкиДолговременногоТокенаСертификата(ИдентификаторСертификата)

	Возврат "ЭлектроннаяПодпись.ЭлектроннаяПодписьВМоделиСервиса." + ИдентификаторСертификата;

КонецФункции

// Возвращает структуру хранения настроек проверки токена для сертификата
//
// Возвращаемое значение:
//	Структура - содержит необходимые свойства.
//
Функция ОсновыеСвойстваРасшифрованияПодписания()
	
	Результат = Новый Структура();
	Результат.Вставить("СпособПодтвержденияКриптоопераций", Перечисления.СпособыПодтвержденияКриптоопераций.СессионныйТокен);
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Отпечаток", "");
	Результат.Вставить("Токен", "");
	
	Возврат Результат;
	
КонецФункции

// Служебная функция служит для определения идентификатора сертификата в переданных параметрах
//
// Параметры:
//	Сертификат - Строка, Структура - данные содежащие идентификатор сертификата:
//	 * Идентификатор - Строка - идентификатор сертификата.
//
// Возвращаемое значение:
//   Строка - содержит идентификатор сертификата или пустую строку.
//
Функция ИдентификаторСертификатаСвойства(Сертификат, ТекущиеСвойства = Неопределено)
	
	Результат = "";
	Отпечаток = "";
	
	Если ТипЗнч(Сертификат) = Тип("Структура") Тогда
		Если Сертификат.Свойство("Идентификатор") Тогда
			Результат = СервисКриптографииСлужебный.Идентификатор(Сертификат);
		ИначеЕсли Сертификат.Свойство("Отпечаток") Тогда
			Отпечаток = Сертификат.Отпечаток;
			СвойствоСертификата = ХранилищеСертификатов.НайтиСертификат(Сертификат);
			Если СвойствоСертификата <> Неопределено Тогда
				Результат = СвойствоСертификата.Идентификатор;
			КонецЕсли;	
		КонецЕсли;
		
	Иначе
		Результат = Сертификат;
		
	КонецЕсли;
	
	Если ТекущиеСвойства <> Неопределено Тогда
		ТекущиеСвойства.Отпечаток 		= Отпечаток;
		ТекущиеСвойства.Идентификатор 	= Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает настройки сертификата: использование долговременного токена и его значение
//
// Параметры:
//   Сертификат - Структура, Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
// Возвращаемое значение:
//   Структура - состоит из полей "СпособПодтвержденияКриптоОпераций", "Токен", "Идентификатор", "Отпечаток".
//
Функция СвойстваРасшифрованияПодписанияСертификата(Сертификат) Экспорт
	
	Результат 					= ОсновыеСвойстваРасшифрованияПодписания();
	ИдентификаторСертификата    = ИдентификаторСертификатаСвойства(Сертификат, Результат);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторСертификата) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		
		// Длительный маркер безопасности сохраняем в безопасное хранилище паролей.
		ДанныеНастройки = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИмяНастройкиДолговременногоТокенаСертификата(ИдентификаторСертификата), "Настройки");
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ДанныеНастройки <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Результат, ДанныеНастройки);
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет настройки для использования долговременного токена
//
// Параметры:
//	Сертификат - Структура, Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
Процедура УдалитьСвойстваРасшифрованияПодписания(Сертификат) Экспорт
	
	ИдентификаторСертификата    = ИдентификаторСертификатаСвойства(Сертификат);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторСертификата) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИмяНастройкиДолговременногоТокенаСертификата(ИдентификаторСертификата));
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Сохраняет настройки для использования долговременного токена
//
// Параметры:
//   Сертификат - Структура, Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
Процедура УстановитьСвойстваРасшифрованияПодписания(Сертификат) Экспорт
	
	НовыеНастройки 				= ОсновыеСвойстваРасшифрованияПодписания();
	ИдентификаторСертификата    = ИдентификаторСертификатаСвойства(Сертификат, НовыеНастройки);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторСертификата) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяНастройки	= СервисКриптографииСлужебный.ИмяНастройкиДлительногоМаркерБезопасностиСертификата(ИдентификаторСертификата);
	ТекущийТокен	= ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИмяНастройки, "ИспользоватьДлительныйМаркерБезопасности");
						
	НовыеНастройки.СпособПодтвержденияКриптоопераций = Перечисления.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен;
	Если ТекущийТокен <> Неопределено Тогда
		НовыеНастройки.Токен = ТекущийТокен;
	КонецЕсли;						
	
	ИмяНастройки = ИмяНастройкиДолговременногоТокенаСертификата(ИдентификаторСертификата);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ИмяНастройки, НовыеНастройки, "Настройки");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура НастроитьИспользованиеДолговременногоТокена(СпособПодтвержденияКриптоопераций, Сертификат) Экспорт
	
	ИдентификаторСертификата    = ИдентификаторСертификатаСвойства(Сертификат);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторСертификата) Тогда
		Возврат;
	
	ИначеЕсли СпособПодтвержденияКриптоопераций = Перечисления.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен Тогда
		УстановитьСвойстваРасшифрованияПодписания(ИдентификаторСертификата);
		
	Иначе
		УдалитьСвойстваРасшифрованияПодписания(ИдентификаторСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
// 	Сертификат - см. СервисКриптографииСлужебный.Идентификатор.Сертификат
// Возвращаемое значение:
// 	ДвоичныеДанные - данные сертификата.
Функция НайтиСертификатПоИдентификатору(Сертификат) Экспорт
	
	Если Сертификат.Свойство("Отпечаток")
		и ЗначениеЗаполнено(Сертификат.Отпечаток) Тогда
		Результат = Сертификат.Отпечаток;
		
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ХранилищеСертификатов.Отпечаток КАК Отпечаток
		|ИЗ
		|	РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
		|ГДЕ
		|	ХранилищеСертификатов.Идентификатор = &Идентификатор
		|	И ХранилищеСертификатов.ТипХранилища = ЗНАЧЕНИЕ(Перечисление.ТипХранилищаСертификатов.ПерсональныеСертификаты)";
		
		Запрос 	= Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Идентификатор", СервисКриптографииСлужебный.Идентификатор(Сертификат));
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Результат = Выборка.Отпечаток;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
