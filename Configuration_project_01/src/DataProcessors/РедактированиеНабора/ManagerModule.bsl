#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры проверки корректности комплекта.
//
// Параметры:
//	Объект - ОбработкаОбъект.РедактированиеНабора,
//				ДанныеФормыСтруктура - документ, для которого необходимо получить параметры проверки комплекта.
//
// Возвращаемое значение:
//	Структура - см. УчетПрослеживаемыхТоваровЛокализация.ПараметрыПроверкиКорректностиКомплекта.
//
Функция ПараметрыПроверкиКорректностиКомплекта(Объект) Экспорт
	
	ПараметрыВариантаКомплектацииНоменклатуры = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(
													Объект.НоменклатураНабора,
													Объект.ХарактеристикаНабора);
	
	ОтборСтрок = Новый Структура;
	ОтборСтрок.Вставить("Номенклатура",		ПараметрыВариантаКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента);
	ОтборСтрок.Вставить("Характеристика",	ПараметрыВариантаКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента);
	
	ОсновныеКомплектующие = Объект.Комплектующие.НайтиСтроки(ОтборСтрок);
	
	ПараметрыПроверки = УчетПрослеживаемыхТоваровЛокализация.ПараметрыПроверкиКорректностиКомплекта();
	ПараметрыПроверки.Дата				= Объект.Дата;
	ПараметрыПроверки.СборкаКомплекта	= Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РазборкаТоваров;
	
	ПараметрыПроверки.Номенклатура		= Объект.НоменклатураНабора;
	ПараметрыПроверки.Характеристика	= Объект.ХарактеристикаНабора;
	
	Если ОсновныеКомплектующие.Количество() Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыПроверки, ПараметрыВариантаКомплектацииНоменклатуры);
	КонецЕсли;
	
	ПараметрыПроверки.ИмяТЧ = "Комплектующие";
	
	Возврат ПараметрыПроверки;
	
КонецФункции

#КонецОбласти

#КонецЕсли