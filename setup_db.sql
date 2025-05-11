--Чистим объекты, если их уже создали 
drop table if exists dbo.RetailPacks;
drop table if exists dbo.BillContent;
drop table if exists dbo.Bills;
drop table if exists dbo.Clients;

--создание объектов
--Клиенты
create table dbo.Clients (
  cID   int           not null
 ,Name  nvarchar(500) collate Cyrillic_General_CI_AS not null
 ,Inn   nvarchar(12)  collate Cyrillic_General_CI_AS not null
 ,Phone nvarchar(15)  collate Cyrillic_General_CI_AS null
 ,Email nvarchar(500) collate Cyrillic_General_CI_AS null
);
alter table dbo.Clients add constraint PK_Clients primary key clustered (cID);

--Счета
create table dbo.Bills (
  bID     int          not null
 ,Num     nvarchar(50) collate Cyrillic_General_CI_AS not null
 ,BDate   date         not null
 ,PayDate date         null
 ,cID     int          not null
);
alter table dbo.Bills add constraint PK_Bills primary key clustered (bID);
alter table dbo.Bills add constraint FK_Bills_cID foreign key (cID) references dbo.Clients (cID);

--Строки счета
create table dbo.BillContent (
  bcID        int            not null
 ,bID         int            not null
 ,Product     nvarchar(50)   collate Cyrillic_General_CI_AS null
 ,TariffName  nvarchar(1000) collate Cyrillic_General_CI_AS null
 ,ServiceName nvarchar(1000) collate Cyrillic_General_CI_AS null
 ,TypeID      tinyint        not null
 ,Cost        money          not null
 ,Paid        money          null
 ,Cnt         int            not null
);
alter table dbo.BillContent add constraint PK_BillContent primary key clustered (bcID);
alter table dbo.BillContent add constraint FK_BillContent_bID foreign key (bID) references dbo.Bills (bID);

--Поставки
create table dbo.RetailPacks (
  rpID  int  not null
 ,bcID  int  not null
 ,Since date not null
 ,UpTo  date not null
);
alter table dbo.RetailPacks add constraint PK_RetailPacks primary key clustered (rpID);
alter table dbo.RetailPacks add constraint FK_RetailPacks_bcID foreign key (bcID) references dbo.BillContent (bcID);

--Наполнение таблиц данными
--Клиенты
INSERT dbo.[Clients] ([cID], [Name], [Inn], [Phone], [Email]) VALUES (1, N'Ricky', N'926284146793', N'8(953)236-70-70', N'uastfclx5@rxmvmm.com')
INSERT dbo.[Clients] ([cID], [Name], [Inn], [Phone], [Email]) VALUES (59, N'Shannon170', N'635298086668', N'8(913)942-07-06', N'kzij.avvsg@uurgir.com')

--Счета
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (3331, N'20932479494', CAST(N'2020-09-29' AS Date), CAST(N'2020-09-30' AS Date), 1)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (37036, N'1893327426', CAST(N'2018-03-06' AS Date), CAST(N'2020-10-06' AS Date), 1)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (1460456, N'B2012132032', CAST(N'2013-12-20' AS Date), CAST(N'2013-12-25' AS Date), 59)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (1250497, N'B2212134015', CAST(N'2013-12-22' AS Date), CAST(N'2013-12-24' AS Date), 59)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (5474874, N'20932994380', CAST(N'2020-11-19' AS Date), CAST(N'2020-11-20' AS Date), 59)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (5475058, N'w2093185400', CAST(N'2020-08-10' AS Date), CAST(N'2020-10-18' AS Date), 1)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (5476484, N'18931678721', CAST(N'2018-09-27' AS Date), CAST(N'2018-09-28' AS Date), 59)
INSERT dbo.[Bills] ([bID], [Num], [BDate], [PayDate], [cID]) VALUES (5480454, N'2093531000', CAST(N'2020-02-26' AS Date), CAST(N'2020-02-27' AS Date), 1)

--Строки счета
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (3275, 3331, N'Контур-Экстерн', N'ОБ доп сертификат', N'Изготовление дополнительного сертификата для организации на обслуживании в режиме "Обслуживающая бухгалтерия" со встроенной лицензией СКЗИ "КриптоПро CSP", 1+9 абонентов', 2, 630.00, 630.00, 4)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5474082, 5474874, N'КЭП.АлкоЕГАИС', N'Квалифицированный для ЕГАИС', N'Абонентское обслуживание по тарифному плану "Квалифицированный для ЕГАИС" сроком действия 12 мес., с выдачей сертифицированного защищенного носителя Рутокен ЭЦП 2.0 64КБ, серт. ФСБ', 1, 810.00, 810.00, 9)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5474212, 5475058, N'Диадок', N'Минимальный', N'Право использования программы для ЭВМ «Диадок», тарифный план «Минимальный»', 1, 900.00, 900.00, 5)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5475727, 5476484, N'Перепродажа ПО и носителей', N'КриптоПро', N'Лицензия на право использования СКЗИ «КриптоПро CSP» версии 4.0 на одном рабочем месте', 1, 2700.00, 2700.00, 9)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5482965, 5480454, N'КЭП для инф. систем', N'Квалифицированный для внесения изменений в сведения ЮЛ', N'Абонентское обслуживание по тарифному плану "Квалифицированный для внесения изменений в сведения ЮЛ" сроком действия 1 мес.', 1, 60.00, 60.00, 5)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5484722, 3331, N'ЭП для торгов', N'Электронная подпись 2.0', N'Абонентское обслуживание по тарифному плану "Электронная подпись 2.0" сроком действия 15 мес., с выдачей защищенного носителя Рутокен Лайт сертифицированный + ЭТП «ТЭК-Торг» секция ПАО НК «Роснефть», + ЭТП Газпромбанка', 2, 2325.00, 2325.00, 10)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (5517103, 37036, N'Услуги сопровождения торгов', N'Консультационные услуги', N'Консультационные услуги по участию в закупке – анализ документации закупки, подготовка заявки на участие', 1, 1.00, 1.00, 10)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (12211353, 1250497, N'Диадок', N'Диадок', N'Право использования программы для ЭВМ «Диадок». Постоплатная система расчетов. Документ. Период с 01.05.2018 по 31.07.2018', 2, 108.00, 108.00, 10)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (12422108, 1460456, N'Услуги внедрения ККТ', N'Прочие', N'Инструктаж для 1 пользователя ККТ по работе с Контур.Маркетом', 1, 1200.00, 1200.00, 5)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (1249703, 1250497, N'Контур-Экстерн', N'Бюджетник Плюс', N'Право использования программы для ЭВМ "Контур.Экстерн" по тарифному плану "Бюджетник плюс" на 1 год, с применением встроенных в сертификат СКЗИ "КриптоПро CSP"', 2, 5600.00, 5600.00, 1)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (6730468, 1250497, N'Контур.ОФД', N'ОФД-15', N'Услуги по обработке фискальных данных по тарифному плану «ОФД-15» сроком на 15 месяцев, 1 ККТ', 2, 2312.00, 2312.00, 2)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (6940444, 1460456, N'КЭП для инф. систем', N'КриптоПро', N'Лицензия на право использования СКЗИ «КриптоПро CSP» в составе сертификата ключа', 1, 1000.00, 1000.00, 5)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (36968, 37036, N'Контур-Экстерн', N'Оптимальный Плюс', N'Право использования программы для ЭВМ "Контур.Экстерн" по тарифному плану "Оптимальный плюс" на 1 год для ЮЛ на специальной системе налогообложения, с применением встроенных в сертификат СКЗИ "КриптоПро CSP"', 2, 3416.00, 3416.00, 5)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (1460923, 1460456, N'Контур-Экстерн', N'Оптимальный Плюс', N'Услуги абонентского обслуживания  программы для ЭВМ «Контур-Экстерн»  по тарифному плану «Оптимальный плюс» на 1 год для ЮЛ на общей системе налогообложения', 2, 4260.00, 4260.00, 6)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10955701, 5474874, N'ЭП для торгов', N'Электронная подпись 3.0', N'Абонентское обслуживание по тарифному плану "Электронная подпись 3.0" сроком действия 12 мес., с выдачей сертифицированного защищенного носителя Рутокен лайт, + Фабрикант', 1, 1780.00, 1780.00, 6)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10955980, 5475058, N'Контур.ФМС', N'ФМС.Стандарт', N'Право использования программы для ЭВМ «Контур.Отель» по тарифному плану "ФМС.Стандарт" сроком действия на 12 месяцев, от 31 до 100 номеров', 1, 13680.00, 13680.00, 6)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10956951, 5476484, N'КЭП для инф. систем', N'Квалифицированный Классик', N'Абонентское обслуживание по тарифному плану "Квалифицированный Классик" сроком действия 12 мес., без выдачи защищенного носителя', 1, 600.00, 600.00, 7)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10960305, 5480454, N'КЭП для инф. систем', N'Квалифицированный Классик', N'Право использования программ для ЭВМ для управления Сертификатом по тарифному плану "Квалифицированный Классик" сроком действия 15 мес., без выдачи защищенного носителя', 2, 3000.00, 3000.00, 6)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10964483, 3331, N'КЭП для инф. систем', N'КриптоПро', N'Лицензия на право использования СКЗИ «КриптоПро CSP» в составе сертификата ключа', 1, 1000.00, 1000.00, 6)
INSERT dbo.[BillContent] ([bcID], [bID], [Product], [TariffName], [ServiceName], [TypeID], [Cost], [Paid], [Cnt]) VALUES (10998867, 37036, N'ЭП для торгов', N'Сертум.Классик', N'Право использования программ для ЭВМ для управления Сертификатом по тарифному плану "Сертум.Классик" сроком действия 12 мес., с выдачей сертифицированного защищенного носителя Рутокен Лайт', 1, 4400.00, 4400.00, 8)

--Поставки
INSERT dbo.[RetailPacks] ([rpID], [bcID], [Since], [UpTo]) VALUES (2999, 3275, CAST(N'2018-03-02' AS Date), CAST(N'2021-03-02' AS Date))
INSERT dbo.[RetailPacks] ([rpID], [bcID], [Since], [UpTo]) VALUES (37331, 36968, CAST(N'2019-09-17' AS Date), CAST(N'2020-09-17' AS Date))
