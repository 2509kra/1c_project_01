
#Область СлужебныйПрограммныйИнтерфейс

Функция НеобходимВызовСервера(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт

	Перем ПараметрыДействия;
	
	//++ Локализация
	
	Если СтруктураДействий.Свойство("ЗаполнитьПартиюТМЦВЭксплуатации", ПараметрыДействия)
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура)
		И ЗначениеЗаполнено(ТекущаяСтрока.ФизическоеЛицо) Тогда
		
		Если ЗначениеЗаполнено(ПараметрыДействия.Дата)
			И ЗначениеЗаполнено(ПараметрыДействия.Организация)
			И ЗначениеЗаполнено(ПараметрыДействия.Подразделение)
			И (Не ПараметрыДействия.Свойство("ХозяйственнаяОперация")
				Или (ЗначениеЗаполнено(ПараметрыДействия.ХозяйственнаяОперация)
					И ПараметрыДействия.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации"))) Тогда
			
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьАлкогольнуюПродукцию")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПродукциюВЕТИС")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	УпаковкаНоменклатура = Неопределено;
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницВЕТИС", УпаковкаНоменклатура)
		Или СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоВЕТИС", УпаковкаНоменклатура) Тогда
		
		ПараметрыПересчета = ОбработкаТабличнойЧастиКлиентСервер.НормализоватьПараметрыПересчетаЕдиниц(ТекущаяСтрока, УпаковкаНоменклатура);
		
		КлючКоэффициента = ОбработкаТабличнойЧастиКлиентСервер.КлючКэшаУпаковки(ПараметрыПересчета.Номенклатура, ПараметрыПересчета.Упаковка);
		
		Если ЗначениеЗаполнено(ПараметрыПересчета.Упаковка)
			И ЗначениеЗаполнено(ПараметрыПересчета.Номенклатура)
			И КэшированныеЗначения.КоэффициентыУпаковок[КлючКоэффициента] = Неопределено Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- Локализация

	Возврат Ложь;
	
КонецФункции

Процедура ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт

	//++ Локализация
	
	ОбработкаТабличнойЧастиКлиентСерверЛокализация.ЗаполнитьПризнакиКатегорииЭксплуатации(
		ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	
	//-- Локализация
	
КонецПроцедуры

Процедура ПолучитьТекущуюСтрокуСтруктурой(СтруктураДействий, СтруктураПолейТЧ) Экспорт

	//++ Локализация
	
	Если СтруктураДействий.Свойство("ЗаполнитьПартиюТМЦВЭксплуатации") Тогда
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
		СтруктураПолейТЧ.Вставить("ФизическоеЛицо");
		СтруктураПолейТЧ.Вставить("ПартияТМЦВЭксплуатации");
		СтруктураПолейТЧ.Вставить("ИнвентарныйУчет");
		СтруктураПолейТЧ.Вставить("КоличествоУпаковок");
		СтруктураПолейТЧ.Вставить("Количество");
	КонецЕсли;
	
	
	СтруктураПараметровДействия = Неопределено;
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС", СтруктураПараметровДействия) 
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакМаркируемаяПродукция", СтруктураПараметровДействия) 
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти
