
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	РазрешитьРедактированиеРеквизитов = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Если РазрешитьРедактированиеРеквизитов Тогда 
		
		Закрыть(ПолучитьБлокируемыеРеквизиты());
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере 
Функция ПолучитьБлокируемыеРеквизиты()
	
	Возврат Документы.ВозвратТоваровОтКлиента.ПолучитьБлокируемыеРеквизитыОбъекта();
	
КонецФункции

#КонецОбласти
