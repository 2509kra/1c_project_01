////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройВызовСервераУТ.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПолучитьДанныеШтрихкода(Штрихкод) Экспорт

	Возврат РаботаСНоменклатуройУТ.ПолучитьДанныеШтрихкода(Штрихкод);
	
КонецФункции

Процедура ЗаполнитьНоменклатуруПоШтрихкоду(Форма, Номенклатура) Экспорт
	
	РаботаСНоменклатуройУТ.ЗаполнитьНоменклатуруПоШтрихкоду(Форма, Номенклатура);
	
КонецПроцедуры

#КонецОбласти