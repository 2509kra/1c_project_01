#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Соотвествие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соотвествие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	
	Возврат ОбщегоНазначенияУТ.КлючевыеРеквизитыСправочникаКлючейПоРегиструСведений(Метаданные.РегистрыСведений.АналитикаУчетаНоменклатуры);
	
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ДанныеСправочника.Номенклатура		= Аналитика.Номенклатура
	|		И ДанныеСправочника.Характеристика	= Аналитика.Характеристика
	|		И ДанныеСправочника.Серия			= Аналитика.Серия
	|		И ДанныеСправочника.МестоХранения	= Аналитика.МестоХранения
	|		И ДанныеСправочника.Назначение		= Аналитика.Назначение
	|		И ДанныеСправочника.СтатьяКалькуляции = Аналитика.СтатьяКалькуляции
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL
	|");
	
	// Сформируем соответствие ключей аналитики.
	СоответствиеАналитик = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
	
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СоответствиеАналитик.Вставить(Выборка.Ссылка, Выборка.КлючАналитики);
			
			Если Не Выборка.ПометкаУдаления Тогда
				СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
				Попытка
					СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
				Исключение
					ВызватьИсключение;
				КонецПопытки;
			КонецЕсли;

		КонецЦикла;
		Исключения = Новый Массив;
		Исключения.Добавить(Метаданные.РегистрыСведений.СтоимостьТоваров);
		ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеАналитик, Исключения);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли