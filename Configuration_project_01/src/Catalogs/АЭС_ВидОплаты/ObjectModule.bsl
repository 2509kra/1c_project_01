
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	//запрет переноса в другую группу
	//Если Не ЭтотОбъект.ЭтоНовый() И ЭтотОбъект.Родитель <> ЭтотОбъект.Ссылка.Родитель И Не РольДоступна("АЭС_ПолныеПрава") Тогда
	//	Отказ = Истина;
	//КонецЕсли;
	
	Если Не РольДоступна("АЭС_ПолныеПрава") Тогда
		Отказ = Истина;
	КонецЕсли;
	
	
КонецПроцедуры
