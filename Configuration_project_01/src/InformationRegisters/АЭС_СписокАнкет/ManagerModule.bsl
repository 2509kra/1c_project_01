&НаСервере 
Функция ПолучитьДатуАктуальногоПеречня()Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	АЭС_СписокЭкстремистов.Перечень КАК Перечень,
	|	МАКСИМУМ(АЭС_СписокЭкстремистов.ДатаПеречня) КАК ДатаПеречня
	|ИЗ
	|	РегистрСведений.АЭС_СписокЭкстремистов КАК АЭС_СписокЭкстремистов
	|
	|СГРУППИРОВАТЬ ПО
	|	АЭС_СписокЭкстремистов.Перечень";

	Результат = Запрос.Выполнить().Выгрузить();

	Возврат Результат;	
КонецФункции
