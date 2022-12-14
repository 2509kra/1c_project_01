#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ДополнительныеСвойства.Свойство("НеСохранятьОтложенные")
		ИЛИ (ДополнительныеСвойства.Свойство("СвойстваДокумента") 
			И ДополнительныеСвойства.СвойстваДокумента.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения)
		ИЛИ Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Сохранить отложенные движения
	ОписаниеРегистра = СформироватьОписаниеРегистра();
	#Область ТекстЗапроса
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&ВсеПоля
	|ПОМЕСТИТЬ НовыеДвижения
	|ИЗ
	|	&Набор КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ВсеПоля
	|ПОМЕСТИТЬ ТекущиеДвижения
	|ИЗ
	|	РегистрНакопления.ДвиженияДенежныеСредстваКонтрагент КАК Т
	|ГДЕ
	|	Т.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ГруппировкиПсевдоним,
	|	&РесурсыСумма
	|ПОМЕСТИТЬ Различия
	|ИЗ
	|	(ВЫБРАТЬ
	|	&ГруппировкиПсевдоним,
	|	&РесурсыМинусом
	|	ИЗ
	|		НовыеДвижения КАК Т
	|	ГДЕ
	|		НЕ Т.ОтложенноеПроведение
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|	&ГруппировкиПсевдоним,
	|	&РесурсыПлюсом
	|	ИЗ
	|		ТекущиеДвижения КАК Т
	|	ГДЕ
	|		НЕ Т.ОтложенноеПроведение
	|	) КАК Т
	|СГРУППИРОВАТЬ ПО
	|	&Группировки
	|ИМЕЮЩИЕ
	|	&РесурсыОтбор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Различия.Организация КАК Организация1,
	|	&ВсеПоля
	|ИЗ
	|	ТекущиеДвижения КАК Т
	|	ЛЕВОЕ СОЕДИНЕНИЕ Различия КАК Различия
	|	ПО ИСТИНА
	|	И &Соединение
	|ГДЕ
	|	Т.ОтложенноеПроведение
	|	И Различия.Организация ЕСТЬ NULL";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВсеПоля", ОписаниеРегистра.ВсеПоляРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ГруппировкиПсевдоним", ОписаниеРегистра.ГруппировкиСПсевдонимом);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РесурсыСумма", ОписаниеРегистра.РесурсыСумма);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РесурсыМинусом", ОписаниеРегистра.РесурсыМинусом);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РесурсыПлюсом", ОписаниеРегистра.Ресурсы);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Группировки", ОписаниеРегистра.Группировки);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РесурсыОтбор", ОписаниеРегистра.РесурсыОтбор);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Соединение", ОписаниеРегистра.Соединение);
	#КонецОбласти
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Набор", Выгрузить());
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьОписаниеРегистра()
	
	Описание = Новый Структура;

	НаборРегистра = РегистрыНакопления.ДвиженияДенежныеСредстваКонтрагент.СоздатьНаборЗаписей();
	ТаблицаРегистра = НаборРегистра.ВыгрузитьКолонки();
	
	Разделитель = ","+Символы.ПС + Символы.Таб;
	ВсеПоляРегистра = "";
	Для Каждого Колонка Из ТаблицаРегистра.Колонки Цикл
		Если СтрНайти(Колонка.Имя, "Удалить") > 0 
			ИЛИ СтрНайти(Колонка.Имя, "МоментВремени") > 0 Тогда
			Продолжить;
		КонецЕсли;
		ВсеПоляРегистра = ВсеПоляРегистра + ?(ВсеПоляРегистра = "", "", Разделитель) 
			+ "Т."+ Колонка.Имя + " КАК " + Колонка.Имя;
	КонецЦикла;
	Описание.Вставить("ВсеПоляРегистра", ВсеПоляРегистра);
	
	МетаданныеРегистра = Метаданные();
	ГруппировкиСПсевдонимом = "";
	Группировки = "";
	Соединение = "ИСТИНА";
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		Если СтрНайти(Измерение.Имя, "Удалить") > 0 Тогда
			Продолжить;
		КонецЕсли;
		ГруппировкиСПсевдонимом = ГруппировкиСПсевдонимом + ?(ГруппировкиСПсевдонимом = "", "", Разделитель) 
			+ "Т."+ Измерение.Имя + " КАК " + Измерение.Имя;
		Группировки = Группировки + ?(Группировки = "", "", Разделитель) 
			+ "Т."+ Измерение.Имя;
		Если СтрНайти(Измерение.Имя, "РасчетныйДокумент") = 0 Тогда
			Соединение = Соединение + ?(Соединение = "", "", Символы.ПС + Символы.Таб) + "И Т."+ Измерение.Имя+ " = Различия."+ Измерение.Имя;
		КонецЕсли;
	КонецЦикла;
	Описание.Вставить("ГруппировкиСПсевдонимом", ГруппировкиСПсевдонимом);
	Описание.Вставить("Группировки", Группировки);
	Описание.Вставить("Соединение", Соединение);
	
	Ресурсы = "";
	РесурсыСумма = "";
	РесурсыОтбор = "ЛОЖЬ";
	Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
		Если СтрНайти(Ресурс.Имя, "Удалить") > 0
			ИЛИ СтрНайти(Ресурс.Имя, "СуммаОплаты") = 0 Тогда
			Продолжить;
		КонецЕсли;
		Ресурсы = Ресурсы + ?(Ресурсы = "", "", Разделитель) 
			+ "Т."+ Ресурс.Имя + " КАК " + Ресурс.Имя;
		РесурсыСумма = РесурсыСумма + ?(РесурсыСумма = "", "", Разделитель) 
			+ "СУММА(Т."+ Ресурс.Имя + ") КАК " + Ресурс.Имя;
		РесурсыОтбор = РесурсыОтбор + ?(РесурсыОтбор = "", "", Символы.ПС + Символы.Таб) + "ИЛИ СУММА(Т."+ Ресурс.Имя + ") <> 0";
	КонецЦикла;
	Описание.Вставить("Ресурсы", Ресурсы);
	Описание.Вставить("РесурсыМинусом", СтрЗаменить(Ресурсы, "Т.", "-Т."));
	Описание.Вставить("РесурсыСумма", РесурсыСумма);
	Описание.Вставить("РесурсыОтбор", РесурсыОтбор);
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти

#КонецЕсли
