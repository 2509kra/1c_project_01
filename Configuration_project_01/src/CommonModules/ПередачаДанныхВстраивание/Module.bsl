#Область СлужебныйПрограммныйИнтерфейс

Процедура МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ) Экспорт
		
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ОбщегоНазначения.ОбщийМодуль("МиграцияПриложений");
		ВсеМенеджерыЛогическихХранилищ.Вставить("migration", МодульМиграцияПриложений);
	КонецЕсли;
	
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ) Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора) Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных) Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных) Экспорт
КонецПроцедуры

Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ПолучениеДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ОтправкаДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение) Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
Процедура ПриПродленииДействияВременногоИдентификатора(Идентификатор, Дата, Запрос) Экспорт
КонецПроцедуры

#КонецОбласти