
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ТипОснованияАктаОРасхождении",
		ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПередачаТоваровХранителю"));
	
	ОткрытьФорму("Документ.АктОРасхожденияхПослеОтгрузки.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, "ПередачаТоваровХранителю", ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

