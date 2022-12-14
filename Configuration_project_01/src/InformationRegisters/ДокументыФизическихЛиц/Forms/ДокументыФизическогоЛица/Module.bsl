
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Физлицо") Тогда
		
		ИзФормыРедактированияЛичныхДанных = Параметры.ИзФормыРедактированияЛичныхДанных;
		
		Если ТолькоПросмотр Тогда
			УстановитьРежимТолькоПросмотр(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ИзФормыРедактированияЛичныхДанных И Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ИзФормыРедактированияЛичныхДанных И Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Если ИзФормыРедактированияЛичныхДанных И Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	Возврат; // в УТ11 не используется
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимТолькоПросмотр(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Список",
		"ТолькоПросмотр",
		Истина);
	
КонецПроцедуры

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

