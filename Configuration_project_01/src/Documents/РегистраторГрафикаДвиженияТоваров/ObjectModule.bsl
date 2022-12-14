#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ДополнительныеСвойства.Свойство("СинхронизацияКлючаСоЗначением")
		И Не ПометкаУдаления Тогда

		// Документ самостоятельно не используется.

		Отказ = Истина;
		ТекстОшибки = НСтр("ru = 'Запись этого объекта возможна только из служебных механизмов'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГрафикПоступленияТоваров.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ГрафикПоступленияТоваров КАК ГрафикПоступленияТоваров
	|ГДЕ
	|	ГрафикПоступленияТоваров.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		
		ТекстИсключения = НСтр("ru = 'По документу %Документ% есть движения в регистре ГрафикПоступленияТоваров. Удаление документа невозможно.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Документ%", Ссылка);
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
