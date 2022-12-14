#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПартииНДС.Период                         КАК Период,
	|	ПартииНДС.Регистратор                    КАК Регистратор,
	|	ПартииНДС.ВидДвижения                    КАК ВидДвижения,
	|	ПартииНДС.Организация                    КАК Организация,
	|	ПартииНДС.Подразделение                  КАК Подразделение,
	|	ПартииНДС.НаправлениеДеятельности        КАК НаправлениеДеятельности,
	|	ПартииНДС.СтатьяРасходов                 КАК СтатьяРасходов,
	|	ПартииНДС.АналитикаРасходов              КАК АналитикаРасходов,
	|	ПартииНДС.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|	ПартииНДС.Поставщик                      КАК Поставщик,
	|	ПартииНДС.ДокументПоступленияРасходов    КАК ДокументПоступленияРасходов,
	|	ПартииНДС.ВидДеятельностиНДС             КАК ВидДеятельностиНДС,
	|	ПартииНДС.ВидЦенности                    КАК ВидЦенности,
	|	ПартииНДС.КорВидДеятельностиНДС          КАК КорВидДеятельностиНДС,
	|	ПартииНДС.ДокументРеализации             КАК ДокументРеализации,
	|	ПартииНДС.СтатьяОтраженияРасходов        КАК СтатьяОтраженияРасходов,
	|	ПартииНДС.АналитикаОтраженияРасходов     КАК АналитикаОтраженияРасходов,
	|	ПартииНДС.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|	ПартииНДС.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	ПартииНДС.СтавкаНДС                      КАК СтавкаНДС,
	|	ПартииНДС.СтоимостьРегл                  КАК СтоимостьРегл,
	|	ПартииНДС.НДСРегл                        КАК НДСРегл,
	|	ПартииНДС.НДСУпр                         КАК НДСУпр
	|ПОМЕСТИТЬ ПартииНДСКРаспределениюПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПартииНДСКРаспределению КАК ПартииНДС
	|ГДЕ
	|	ПартииНДС.Регистратор = &Регистратор
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	ЭтоОтменаПроведения = (ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	Запрос.УстановитьПараметр("ЭтоОтменаПроведения", ЭтоОтменаПроведения);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МассивТекстовЗапроса = Новый Массив;
	
	ТекстТаблицыИзменений = 
	"ВЫБРАТЬ
	|	Таблица.Период                         КАК Период,
	|	Таблица.Регистратор                    КАК Регистратор,
	|	Таблица.ВидДвижения                    КАК ВидДвижения,
	|	Таблица.Организация                    КАК Организация,
	|	Таблица.Подразделение                  КАК Подразделение,
	|	Таблица.НаправлениеДеятельности        КАК НаправлениеДеятельности,
	|	Таблица.СтатьяРасходов                 КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов              КАК АналитикаРасходов,
	|	Таблица.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|	Таблица.Поставщик                      КАК Поставщик,
	|	Таблица.ДокументПоступленияРасходов    КАК ДокументПоступленияРасходов,
	|	Таблица.ВидДеятельностиНДС             КАК ВидДеятельностиНДС,
	|	Таблица.ВидЦенности                    КАК ВидЦенности,
	|	Таблица.СтавкаНДС                      КАК СтавкаНДС,
	|	Таблица.КорВидДеятельностиНДС          КАК КорВидДеятельностиНДС,
	|	Таблица.ДокументРеализации             КАК ДокументРеализации,
	|	Таблица.СтатьяОтраженияРасходов        КАК СтатьяОтраженияРасходов,
	|	Таблица.АналитикаОтраженияРасходов     КАК АналитикаОтраженияРасходов,
	|	Таблица.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|	Таблица.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	СУММА(Таблица.СтоимостьРегл)           КАК СтоимостьРегл,
	|	СУММА(Таблица.НДСРегл)                 КАК НДСРегл,
	|	СУММА(Таблица.НДСУпр)                  КАК НДСУпр
	|ПОМЕСТИТЬ втПартийНДСКРаспределениюРазница
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Период                         КАК Период,
	|		Таблица.Регистратор                    КАК Регистратор,
	|		Таблица.ВидДвижения                    КАК ВидДвижения,
	|		Таблица.Организация                    КАК Организация,
	|		Таблица.Подразделение                  КАК Подразделение,
	|		Таблица.НаправлениеДеятельности        КАК НаправлениеДеятельности,
	|		Таблица.СтатьяРасходов                 КАК СтатьяРасходов,
	|		Таблица.АналитикаРасходов              КАК АналитикаРасходов,
	|		Таблица.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|		Таблица.Поставщик                      КАК Поставщик,
	|		Таблица.ДокументПоступленияРасходов    КАК ДокументПоступленияРасходов,
	|		Таблица.ВидДеятельностиНДС             КАК ВидДеятельностиНДС,
	|		Таблица.ВидЦенности                    КАК ВидЦенности,
	|		Таблица.КорВидДеятельностиНДС          КАК КорВидДеятельностиНДС,
	|		Таблица.ДокументРеализации             КАК ДокументРеализации,
	|		Таблица.СтатьяОтраженияРасходов        КАК СтатьяОтраженияРасходов,
	|		Таблица.АналитикаОтраженияРасходов     КАК АналитикаОтраженияРасходов,
	|		Таблица.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|		Таблица.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|		Таблица.СтавкаНДС                      КАК СтавкаНДС,
	|		Таблица.СтоимостьРегл                  КАК СтоимостьРегл,
	|		Таблица.НДСРегл                        КАК НДСРегл,
	|		Таблица.НДСУпр                         КАК НДСУпр
	|	ИЗ
	|		ПартииНДСКРаспределениюПередЗаписью КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПартииНДС.Период                         КАК Период,
	|		ПартииНДС.Регистратор                    КАК Регистратор,
	|		ПартииНДС.ВидДвижения                    КАК ВидДвижения,
	|		ПартииНДС.Организация                    КАК Организация,
	|		ПартииНДС.Подразделение                  КАК Подразделение,
	|		ПартииНДС.НаправлениеДеятельности        КАК НаправлениеДеятельности,
	|		ПартииНДС.СтатьяРасходов                 КАК СтатьяРасходов,
	|		ПартииНДС.АналитикаРасходов              КАК АналитикаРасходов,
	|		ПартииНДС.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|		ПартииНДС.Поставщик                      КАК Поставщик,
	|		ПартииНДС.ДокументПоступленияРасходов    КАК ДокументПоступленияРасходов,
	|		ПартииНДС.ВидДеятельностиНДС             КАК ВидДеятельностиНДС,
	|		ПартииНДС.ВидЦенности                    КАК ВидЦенности,
	|		ПартииНДС.КорВидДеятельностиНДС          КАК КорВидДеятельностиНДС,
	|		ПартииНДС.ДокументРеализации             КАК ДокументРеализации,
	|		ПартииНДС.СтатьяОтраженияРасходов        КАК СтатьяОтраженияРасходов,
	|		ПартииНДС.АналитикаОтраженияРасходов     КАК АналитикаОтраженияРасходов,
	|		ПартииНДС.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|		ПартииНДС.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|		ПартииНДС.СтавкаНДС                      КАК СтавкаНДС,
	|		-ПартииНДС.СтоимостьРегл                 КАК СтоимостьРегл,
	|		-ПартииНДС.НДСРегл                       КАК НДСРегл,
	|		-ПартииНДС.НДСУпр                        КАК НДСУпр
	|	ИЗ
	|		РегистрНакопления.ПартииНДСКРаспределению КАК ПартииНДС
	|	ГДЕ
	|		ПартииНДС.Регистратор = &Регистратор
	|
	|) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.ВидДвижения,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|	Таблица.НаправлениеДеятельности,
	|	Таблица.СтатьяРасходов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.АналитикаАктивовПассивов,
	|	Таблица.Поставщик,
	|	Таблица.ДокументПоступленияРасходов,
	|	Таблица.ВидДеятельностиНДС,
	|	Таблица.ВидЦенности,
	|	Таблица.СтавкаНДС,
	|	Таблица.КорВидДеятельностиНДС,
	|	Таблица.ДокументРеализации,
	|	Таблица.СтатьяОтраженияРасходов,
	|	Таблица.АналитикаОтраженияРасходов,
	|	Таблица.НастройкаХозяйственнойОперации,
	|	Таблица.ИдентификаторФинЗаписи
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.НДСРегл) <> 0
	|	ИЛИ СУММА(Таблица.НДСУпр) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Период                         КАК Период,
	|	Таблица.Регистратор                    КАК Регистратор,
	|	Таблица.Организация                    КАК Организация,
	|	Таблица.Подразделение                  КАК Подразделение,
	|	Таблица.НаправлениеДеятельности        КАК НаправлениеДеятельности,
	|	Таблица.СтатьяРасходов                 КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов              КАК АналитикаРасходов,
	|	Таблица.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|	Таблица.Поставщик                      КАК Поставщик,
	|	Таблица.ДокументПоступленияРасходов    КАК ДокументПоступленияРасходов,
	|	Таблица.ВидДеятельностиНДС             КАК ВидДеятельностиНДС,
	|	Таблица.ВидЦенности                    КАК ВидЦенности,
	|	Таблица.СтавкаНДС                      КАК СтавкаНДС,
	|	Таблица.КорВидДеятельностиНДС          КАК КорВидДеятельностиНДС,
	|	Таблица.ДокументРеализации             КАК ДокументРеализации,
	|	Таблица.СтатьяОтраженияРасходов        КАК СтатьяОтраженияРасходов,
	|	Таблица.АналитикаОтраженияРасходов     КАК АналитикаОтраженияРасходов,
	|	Таблица.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|	Таблица.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	Таблица.СтоимостьРегл                  КАК СтоимостьРегл,
	|	Таблица.НДСРегл                        КАК НДСРегл,
	|	Таблица.НДСУпр                         КАК НДСУпр
	|ПОМЕСТИТЬ втПартийНДСКРаспределениюРазницаПриход
	|ИЗ
	|	втПартийНДСКРаспределениюРазница КАК Таблица
	|ГДЕ
	|	Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Партии.Период КАК Период,
	|	Партии.Организация КАК Организация,
	|	Партии.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|	Партии.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|	Партии.ДокументПоступленияРасходов КАК СчетФактура
	|ПОМЕСТИТЬ ВтИзменениеПартий
	|ИЗ
	|	втПартийНДСКРаспределениюРазница КАК Партии
	|ГДЕ
	|	Партии.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|";
	МассивТекстовЗапроса.Добавить(ТекстТаблицыИзменений);
	
	МассивЗапросовЗаданийПоОперациям = Новый Массив;
	МассивЗапросовЗаданийПоОперациям.Добавить(
		УчетНДСУП.ТекстЗапросаФормированияЗаданийПриЗаписиПартийНДСКРаспределению("втПартийНДСКРаспределениюРазницаПриход"));
	ТекстЗапросаЗаданийКЗакрытиюМесяца = ЗакрытиеМесяцаСервер.ТекстЗапросЗаданийКЗакрытиюМесяца(
	                                         "ПартииНДСКРаспределению", МассивЗапросовЗаданийПоОперациям);
	МассивТекстовЗапроса.Добавить(ТекстЗапросаЗаданийКЗакрытиюМесяца);
	
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ ПартииНДСКРаспределениюПередЗаписью");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ втПартийНДСКРаспределениюРазница");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ втПартийНДСКРаспределениюРазницаПриход");
	
	Запрос = Новый Запрос();
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВПакете());
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.ВыполнитьПакет();
	
	УчетНДСУП.СформироватьЗаданияДляФормированияКнигиПокупокПродаж(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
