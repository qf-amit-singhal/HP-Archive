/*============================================================================================================
Email Address Updates / Appends
============================================================================================================*/
/*Individual Requests*/
if object_id('tempdb..##tmp_manual_email_updates') is not null drop table ##tmp_manual_email_updates;
go
select * into ##tmp_manual_email_updates from Qualfon_Employee_List_Manual_Email_Updates where 1= 2;
go
insert into ##tmp_manual_email_updates([Employee ID], [Email Address])
values (1010598,'Stefany.Coria@qualfon.com')


insert into Qualfon_Employee_List_Manual_Email_Updates ([Employee ID], [First Name], [Last Name], [Email Address])
select  a.[Employee ID], b.[First Name], b.[Last Name], a.[Email Address]
from ##tmp_manual_email_updates a
join [Qualfon_Employee_List] b on a.[Employee ID] = b.[Employee ID]
where a.[Email Address] <> isnull(b.[Email Address],'X')
  and a.[Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Manual_Email_Updates);
  

/*Manual Email Address Updates*/
update Qualfon_Employee_List
set [Email Address] = b.[Email Address]
   ,[YMWM Valid Email] = 1
   ,[Email Update Comment] = case 
                               when a.[Email Address] is null  
                                 then 'Manually Append Email Address'
                                 else 'Manual Email Address Update'
                              end   
from Qualfon_Employee_List a
join Qualfon_Employee_List_Manual_Email_Updates b on a.[Employee ID] = b.[Employee ID]
where isnull(a.[Email Address],'X') <> b.[Email Address];




/*============================================================================================================
List Assignment Updates
============================================================================================================*/
/*Manually assign to Management/Staff list*/
insert into Qualfon_Employee_List_Assignment_Updates([Employee ID],[First Name],[Last Name],[List Assignment])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , 'Management'
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (286159)
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Assignment_Updates);

/*Manually assign to Agent list*/
insert into Qualfon_Employee_List_Assignment_Updates([Employee ID],[First Name],[Last Name],[List Assignment])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , 'Agent'
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (285490)
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Assignment_Updates);

  
/*Manually assign to Supervisor list*/
insert into Qualfon_Employee_List_Assignment_Updates([Employee ID],[First Name],[Last Name],[List Assignment])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , 'Supervisor'
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (282914)
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Assignment_Updates);

/*Manually Update Assigned List*/
update Qualfon_Employee_List
set [List] = b.[List Assignment]
   ,[Manual List Reassignment] = 1
from Qualfon_Employee_List a 
join Qualfon_Employee_List_Assignment_Updates b on a.[Employee ID] = b.[Employee ID]
where a.[List] <> b.[List Assignment];

/*============================================================================================================
"Duplicate" Employees - Exist in HR systems in Group 4 & Group 1/3
============================================================================================================*/
insert into Qualfon_Employee_List_Duplicate_Systems([Employee ID],[First Name],[Last Name],[Source],[Dup Reason], [Employee ID Footprint], [Employee ID ADP])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , [Source]
      , 'QNECT_ADP_DUP' [Dup Reason]
      , 330709 as [Employee ID Footprint]
      , [Employee ID] as [Employee ID ADP]
--select *
from [dbo].[Qualfon_Employee_List]
where [Employee ID] = (1001019) --Nicole Matuja
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Duplicate_Systems);
  
insert into Qualfon_Employee_List_Duplicate_Systems([Employee ID],[First Name],[Last Name],[Source],[Dup Reason])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , [Source]
      , 'QNECT_DUPLICATE' [Dup Reason]
--select *
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (314026--Bibi Aneisa	Roopdeo
                       )
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Duplicate_Systems);

insert into Qualfon_Employee_List_Duplicate_Systems([Employee ID],[First Name],[Last Name],[Source],[Dup Reason])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , [Source]
      , 'NO_LONGER_EMPLOYED' [Dup Reason]
--select *
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (306589--Adrian Laing
                       )
  and [Employee ID] not in (select [Employee ID] from Qualfon_Employee_List_Duplicate_Systems);

/*============================================================================================================
Individual Agents who are required to receive a direct link via Email
============================================================================================================*/
/*Manually assign ELOQUA_LINK - INDIVIDUAL*/
insert into Qualfon_Agents_Requiring_Survey_Link([Employee ID],[First Name],[Last Name],[YMWM_Agent_Link])
select  [Employee ID]
      , [First Name]
      , [Last Name]
      , 'ELOQUA_LINK'
from [dbo].[Qualfon_Employee_List]
where [Employee ID] in (289223,280267,286639,280236,289222,276094,276096,276100,276093)
  and [Employee ID] not in (select [Employee ID] from Qualfon_Agents_Requiring_Survey_Link);

/*Manually Update Link Assignment*/
update Qualfon_Employee_List
set [YMWM_Agent_Link] = b.[YMWM_Agent_Link]
from Qualfon_Employee_List a 
join Qualfon_Agents_Requiring_Survey_Link b on a.[Employee ID] = b.[Employee ID]
where isnull(a.[YMWM_Agent_Link],'X') <> b.[YMWM_Agent_Link];

/*============================================================================================================
Manual Forced Inclusions
============================================================================================================*/
--insert into Qualfon_Manual_Employee_List_Inclusions([First Name],[Last Name],[Email Address],[Qualfon Group],[Qualfon Location],List,[HR Job Title],Country)
--values ('Charles','Clark','charles@worksitechaplains.org','Business Group 04 Office','Troy','Management','Chaplain','United States')

--insert into Qualfon_Manual_Employee_List_Inclusions([First Name],[Last Name],[Email Address],[Qualfon Group],[Qualfon Location],List,[HR Job Title],Country)
--values ('Fernando','Charles','fcharles@qualfon.com','Business Group 03 Office','San Antonio','Management','Chaplain','United States')

----Cuatro Cienegas 2040 Employees
--insert into Qualfon_Manual_Employee_List_Inclusions([First Name],[Last Name],[Qualfon Group],[Qualfon Location],[Business Unit],List,[HR Job Title],[Email Address],Country)
--values('Alejandra', 'Delgadillo', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Visitas', 'adelgadillo@cuatrocienegas2040.org', 'Mexico')
--,('Andrés', 'Espinosa', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinador de Formación', 'aespinosa@cuatrocienegas2040.org', 'Mexico')
--,('Angela', 'Cunningham', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Inglés', 'acunningham@cuatrocienegas2040.org', 'Mexico')
--,('Dibanhi', 'Álvarez', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Estimulación Temprana', 'dalvarez@cuatrocienegas2040.org', 'Mexico')
--,('Diego', 'Treviño', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Analista', 'dtrevino@cuatrocienegas2040.org', 'Mexico')
--,('Dolores', 'Torres', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinadora de Administración', 'dtorres@cuatrocienegas2040.org', 'Mexico')
--,('Gilberto', 'González', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinador de Desarrollo Institucional', 'ggonzalez@cuatrocienegas2040.org', 'Mexico')
--,('Iván', 'Torres', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinador General', 'itorres@cuatrocienegas2040.org', 'Mexico')
--,('Joaquín', 'Aldana', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinador de Operación', 'jaldana@cuatrocienegas2040.org', 'Mexico')
--,('Jovita', 'García', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Visitas', 'jgarcia@cuatrocienegas2040.org', 'Mexico')
--,('Karla', 'Rocha', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Administradora', 'karocha@cuatrocienegas2040.org', 'Mexico')
--,('Lizeth', 'García', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de casos', 'lgarcia@cuatrocienegas2040.org', 'Mexico')
--,('Mariana', 'Escobar', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Visitas', 'mescobar@cuatrocienegas2040.org', 'Mexico')
--,('Marianita', 'Araiza', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de espiritualidad', 'maraiza@cuatrocienegas2040.org', 'Mexico')
--,('Mayra', 'Jinez', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de visitas', 'mjinez@cuatrocienegas2040.org', 'Mexico')
--,('Saira', 'Jinez', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Visitas', 'sjinez@cuatrocienegas2040.org', 'Mexico')

/*Per Pam's Request on 5/27/20*/
--delete from Qualfon_Manual_Employee_List_Inclusions where [Email Address] = 'dtorres@cuatrocienegas2040.org'
--insert into Qualfon_Manual_Employee_List_Inclusions([First Name],[Last Name],[Qualfon Group],[Qualfon Location],[Business Unit],List,[HR Job Title],[Email Address],Country)
--values('Karely', 'Gaytán', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Mantenimeinto', 'kgaytan2040@gmail.com', 'Mexico')

/*Per Ariadna's request on 10/1*/
--delete from Qualfon_Manual_Employee_List_Inclusions where [Email Address] in ('fcharles@qualfon.com', 'aespinosa@cuatrocienegas2040.org');

--insert into Qualfon_Manual_Employee_List_Inclusions([First Name],[Last Name],[Qualfon Group],[Qualfon Location],[Business Unit],List,[HR Job Title],[Email Address],Country)
--values('Carla ', 'Escobedo Ledezma', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía de Visitas', 'cescobedo@cuatrocienegas2040.org', 'Mexico')
--,('Deisy ', 'Medina', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Coordinadora de Educación', 'dmedina@cuatrocienegas2040.org', 'Mexico')
--,('Erika ', 'Jinez', 'Shared Services', 'Cuatro Cienegas 2040', 'Mission Office', 'Management', 'Guía Tutora Rochat', 'ejinez@rochatsb.ch', 'Mexico');



--Change requested by Micah Bates in person office
--update Qualfon_Manual_Employee_List_Inclusions set [Qualfon Location] = 'Highland Park - Administration' where [Email Address] = 'charles@worksitechaplains.org';

--Email Update for Charles Clark
--update Qualfon_Manual_Employee_List_Inclusions set [Email Address] = 'Charles.Clark@qualfon.com' where [Email Address] = 'charles@worksitechaplains.org';
