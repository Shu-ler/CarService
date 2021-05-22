// 
//	Аутсорсинг Групп 
//		+7 495 241 10 64
//		+7 3852 59 50 96
//		
//	Филимонов И.В.
//		+7 913 240 81 77
//
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("Код", Код);
		ДанныеЗаполнения.Свойство("Наименование", Наименование);
		ДанныеЗаполнения.Свойство("name_rus", name_rus);
		ДанныеЗаполнения.Свойство("id_car_mark", id_car_mark);
		ДанныеЗаполнения.Свойство("id_car_type", id_car_type);
		ДанныеЗаполнения.Свойство("date_create", date_create);
		ДанныеЗаполнения.Свойство("date_update", date_update);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Владелец = Справочники.КА2_НаименованияМоделей.НайтиПоНаименованию(Наименование, Истина);
	
	Если Владелец.Пустая() Тогда
		НовоеНаименованеие = Справочники.КА2_НаименованияМоделей.СоздатьЭлемент();
		НовоеНаименованеие.Заполнить(Наименование);
		Попытка
			НовоеНаименованеие.Записать();
			Владелец = НовоеНаименованеие.Ссылка;
		Исключение
			// TODO: Обработать ошибку создания записи справочника НаименованияМарок
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли