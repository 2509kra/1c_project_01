#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСервиса = ПолучитьОбщийМакет("ИнструкцияПоПереходуВСервис").ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти
