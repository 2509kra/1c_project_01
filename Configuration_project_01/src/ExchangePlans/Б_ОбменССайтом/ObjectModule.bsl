#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	Перем ЭтоНовый;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
    ЭтоНовый = ЭтоНовый();
	
	Если ПустаяСтрока(Код) Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	
	НайденныйУзел = ПланыОбмена.Б_ОбменССайтом.НайтиПоНаименованию(Наименование);
	
	Если ЗначениеЗаполнено(НайденныйУзел) и НайденныйУзел.Ссылка <> ЭтотОбъект.Ссылка тогда
		Сообщить("Уже существует такое наименование настройки обмена. Укажите новое наименование");
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	УдалитьРегламентноеЗадание();
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Код = "";
	ИдентификаторРегламентногоЗадания = НеОпределено;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЭтоНовый тогда	
		НоваяЗапись = РегистрыСведений.Б_ИнформацияОНастройкахОбменаССайтом.СоздатьМенеджерЗаписи();
		НоваяЗапись.НастройкаОбмена 		 = ЭтотОбъект.Ссылка;
		НоваяЗапись.ВидСостояния 			 = "Принудительная полная выгрузка";
		НоваяЗапись.ПринудительнаяПолнаяВыгрузка = Истина;	
		НоваяЗапись.Записать();		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРегламентноеЗадание() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Задание;
КонецФункции

Процедура УдалитьРегламентноеЗадание() Экспорт
	Задание = ПолучитьРегламентноеЗадание();
	Если НЕ Задание = НеОпределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		Задание.Удалить();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли