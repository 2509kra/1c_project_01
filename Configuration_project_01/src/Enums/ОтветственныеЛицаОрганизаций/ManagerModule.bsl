
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	// Общие
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Кассир);
	
КонецПроцедуры

#КонецОбласти
