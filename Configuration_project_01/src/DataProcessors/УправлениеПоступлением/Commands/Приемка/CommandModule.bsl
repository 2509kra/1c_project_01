
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.УправлениеПоступлением.Команда.Приемка");
	
	ОткрытьФорму("Обработка.УправлениеПоступлением.Форма.Форма",,,,ПараметрыВыполненияКоманды.Окно);	
КонецПроцедуры

#КонецОбласти
