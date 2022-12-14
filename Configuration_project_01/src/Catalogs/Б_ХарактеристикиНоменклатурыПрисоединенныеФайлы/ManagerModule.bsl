
&НаСервере
Функция СоздатьНовыйПрисоединенныйФайл(ПараметрыФайла) Экспорт
																																																										
	лНовыйПрикрепленыйФайл = Справочники.Б_ХарактеристикиНоменклатурыПрисоединенныеФайлы.СоздатьЭлемент();
	
	лНовыйПрикрепленыйФайл.Номенклатура 				= ПараметрыФайла.Номенклатура;
	лНовыйПрикрепленыйФайл.ХарактеристикаНоменклатуры 	= ПараметрыФайла.ХарактеристикаНоменклатуры;
	
	лНовыйПрикрепленыйФайл.Наименование = ПараметрыФайла.Наименование;
	лНовыйПрикрепленыйФайл.ПутьКФайлу 	= ПараметрыФайла.ПутьКФайлу;
	лНовыйПрикрепленыйФайл.Расширение 	= ПараметрыФайла.Расширение;
	лНовыйПрикрепленыйФайл.Размер 		= ПараметрыФайла.Размер;
	
	лНовыйПрикрепленыйФайл.ДатаСоздания	= ТекущаяДата();
	лНовыйПрикрепленыйФайл.Автор 		= ПараметрыСеанса.ТекущийПользователь;	
	
	лНовыйПрикрепленыйФайл.Записать();
	
	//Регистрируем изменение характеристики	
	лОбъект = ПараметрыФайла.ХарактеристикаНоменклатуры.ПолучитьОбъект();
	лОбъект.Записать();
	
	Возврат лНовыйПрикрепленыйФайл.Ссылка;
	
КонецФункции

&НаСервере
Процедура ЗаписатьПрисоединенныйФайл(ПараметрыФайла) Экспорт
	
	НовЗапись = РегистрыСведений.Б_ПрисоединенныеФайлыХарактеристикНоменклатуры.СоздатьМенеджерЗаписи();
	
	НовЗапись.ПрисоединенныйФайл 	= ПараметрыФайла.ПрисоединенныйФайл;		
	НовЗапись.ХранимыйФайл 			= Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ПараметрыФайла.Картинка));		
	
	НовЗапись.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКартинкуПоПрикрепленномуФайлу(ПрисоединенныйФайл) Экспорт
	
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Б_ПрисоединенныеФайлыХарактеристикНоменклатуры.ХранимыйФайл,
	|	Б_ПрисоединенныеФайлыХарактеристикНоменклатуры.ПрисоединенныйФайл
	|ИЗ
	|	РегистрСведений.Б_ПрисоединенныеФайлыХарактеристикНоменклатуры КАК Б_ПрисоединенныеФайлыХарактеристикНоменклатуры
	|ГДЕ
	|	Б_ПрисоединенныеФайлыХарактеристикНоменклатуры.ПрисоединенныйФайл = &ПрисоединенныйФайл";
	Запрос.УстановитьПараметр("ПрисоединенныйФайл", ПрисоединенныйФайл);
	ВыполненныйЗапрос = Запрос.Выполнить();
	
	Если ВыполненныйЗапрос.Пустой() тогда
		
		Возврат Неопределено;
		
	Иначе
		
		Выборка = ВыполненныйЗапрос.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Возврат Выборка.ХранимыйФайл.Получить();
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Неопределено;		
	
КонецФункции
