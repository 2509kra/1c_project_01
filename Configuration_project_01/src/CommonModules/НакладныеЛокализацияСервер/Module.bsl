////////////////////////////////////////////////////////////////////////////////
// Содержит процедуры и функции для поддержки заполнения 
// накладных и функциональности форм документов и списков накладных.
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура СостоянияПоХозОперациям(ХО, Состояния) Экспорт

	//++ Локализация
	
	Если ХО = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		НакладныеСервер.ДобавитьСостояние(Состояния, "СостоянияПриходныхОрдеров", Метаданные.Документы.ПрочееОприходованиеТоваров);
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
