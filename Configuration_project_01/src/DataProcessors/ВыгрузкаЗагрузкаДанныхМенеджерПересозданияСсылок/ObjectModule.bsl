#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийПотокЗаменыСсылок;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ПотокЗаменыСсылок) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийПотокЗаменыСсылок = ПотокЗаменыСсылок;
	
КонецПроцедуры

Процедура ВыполнитьПересозданиеСсылок() Экспорт
	
	ФайлыПересоздаваемыхСсылок = ТекущийКонтейнер.ПолучитьФайлыИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.ReferenceRebuilding());
	Для Каждого ФайлПересоздаваемыхСсылок Из ФайлыПересоздаваемыхСсылок Цикл
		
		ИсходныеСсылки = ТекущийКонтейнер.ПрочитатьОбъектИзФайла(ФайлПересоздаваемыхСсылок); // Массив Из ЛюбаяСсылка
		
		Для Каждого ИсходнаяСсылка Из ИсходныеСсылки Цикл
			
			ИмяТипаXML = ВыгрузкаЗагрузкаДанныхСлужебный.XMLТипСсылки(ИсходнаяСсылка);
			ПолноеИмяОбъекта = ИсходнаяСсылка.Метаданные().ПолноеИмя(); 
			НоваяСсылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).ПолучитьСсылку();
			
			ТекущийПотокЗаменыСсылок.ЗаменитьСсылку(ИмяТипаXML, Строка(ИсходнаяСсылка.УникальныйИдентификатор()), Строка(НоваяСсылка.УникальныйИдентификатор()));

			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
