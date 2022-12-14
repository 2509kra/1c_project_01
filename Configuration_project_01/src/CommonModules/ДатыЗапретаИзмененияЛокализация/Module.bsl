#Область ПрограммныйИнтерфейс

// Вызывается из переопределяемого модуля.
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения()
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт

	//++ Локализация
	УчетНДСУП.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперацияПоЯндексКассе",                      "Дата", "Банк", "БанковскийСчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТМЦВЭксплуатации",                  "Период", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров", "Дата", "СкладскиеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УведомлениеОВвозеПрослеживаемыхТоваров",     "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	
	//-- Локализация

КонецПроцедуры

// Позволяет изменить работу интерфейса при встраивании.
//
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.НастройкаИнтерфейса()
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// см. ОбщийМодуль.ПриЗаполненииРазделовДатЗапретаИзменения.НастройкаИнтерфейса()
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	//++ Локализация


	Раздел = Разделы.Добавить();
	Раздел.Имя  = "БухгалтерскийУчет";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("2bdf6479-8eaf-4ec0-93a1-412e8659a178");
	Раздел.Представление = НСтр("ru = 'Бухгалтерский учет'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	
	//-- Локализация
	
КонецПроцедуры


// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
//
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.ПередПроверкойЗапретаИзменения()
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	//++ Локализация
	Если ОбщегоНазначения.ЭтоРегистр(Объект.Метаданные())
	 И Объект.Отбор.Найти("Регистратор") <> Неопределено Тогда
		ТипРегистратора = ТипЗнч(Объект.Отбор.Регистратор.Значение); // это набор записей документа-регистратора
	Иначе
		ТипРегистратора = Неопределено;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект);
		
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти