#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация", Запись.Отправитель);
	ПараметрыОткрытия.Вставить("Контрагент" , Запись.Получатель);
	ПараметрыОткрытия.Вставить("Договор"    , Запись.Договор);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьФормуНастройкиОтправкиЭДО(ПараметрыОткрытия, Неопределено, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти
