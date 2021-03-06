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
		ДанныеЗаполнения.Свойство("id_car_serie", id_car_serie);
		ДанныеЗаполнения.Свойство("id_car_model", id_car_model);
		ДанныеЗаполнения.Свойство("id_car_type", id_car_type);
		ДанныеЗаполнения.Свойство("start_production_year", start_production_year);
		ДанныеЗаполнения.Свойство("end_production_year", end_production_year);
		ДанныеЗаполнения.Свойство("date_create", date_create);
		ДанныеЗаполнения.Свойство("date_update", date_update);

	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Владелец = Справочники.КА2_Кузова.НайтиПоКоду(id_car_serie);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли