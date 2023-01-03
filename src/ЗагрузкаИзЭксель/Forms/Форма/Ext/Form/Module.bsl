﻿//fddsfsds
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогОткрытия = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытия.Фильтр = "Excel|*.xlsx";
	ДиалогОткрытия.Заголовок = "Выберите файл для загрузки";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытиеФайлаЭксельЗавершение", ЭтаФорма);
	ДиалогОткрытия.Показать(ОписаниеОповещения);
КонецПроцедуры

Процедура ОткрытиеФайлаЭксельЗавершение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПутьКФайлу = ВыбранныеФайлы[0];
		СозданиеНоменклатуры(ПутьКФайлу);
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Процедура СозданиеНоменклатуры(АдресФайла)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Прочитать(АдресФайла);
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабДок.Область());
	ПЗ.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;
	ПЗ.ЗаполнитьНастройки();	
	ПЗ.Выполнить();
	ТаблицаЗначений = ПЗ.Результат.Выгрузить();
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ОчереднаяСтрока Из ТаблицаЗначений Цикл
			НоваяНоменклатура = Справочники.Номенклатура.СоздатьЭлемент();
			НоваяНоменклатура.Наименование = ОчереднаяСтрока.Наименование;
			НоваяНоменклатура.Записать();
		КонецЦикла;
	ЗафиксироватьТранзакцию();
	Исключение
	ОтменитьТранзакцию();
	Сообщить("При загрузке произошла ошибка " + ОписаниеОшибки());
	ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры
               
