USE [Covid-19]
GO
/****** Object:  StoredProcedure [dbo].[covid19_death]    Script Date: 10/6/2021 4:59:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Arun Kumar>
-- Create date: <Create Date, 25/03/2021>
--Project to Analyse Covid-19 Death impact and After Vacination Results
--data Sourece:- https://ourworldindata.org/covid-deaths
--i have devided the whole dataset into two parts covid_deaths and covid_vacination- both files are available on my github
--And have uploaded teh data using Visual shell to sql management studio as text
-- This Proc is to convert covid-death raw table to workable table with correct data types for easy manipulation
-- =============================================
ALTER PROC [dbo].[covid19_death]


AS
BEGIN
-- =============================================
 -- Delete Object if exsists 
-- =============================================

if OBJECT_ID('WRK_CovidDeaths') is not null
drop table WRK_CovidDeaths

-- =============================================
 -- Create table 
-- =============================================
	
create table WRK_CovidDeaths
(
       [Rownumber] int identity(1,1)
      ,[iso_code] varchar (100)
      ,[continent] varchar (100)
      ,[location] varchar (100)
      ,[date] date
      ,[population] bigint
      ,[total_cases] bigint
      ,[new_cases] bigint
      ,[new_cases_smoothed] varchar (100)
      ,[total_deaths] bigint
      ,[new_deaths] bigint 
      ,[new_deaths_smoothed] varchar (100)
      ,[total_cases_per_million] float
      ,[new_cases_per_million] float
      ,[new_cases_smoothed_per_million] varchar (100)
      ,[total_deaths_per_million] float
      ,[new_deaths_per_million] float
      ,[new_deaths_smoothed_per_million] varchar (100)
      ,[reproduction_rate] varchar (100)
      ,[icu_patients] varchar (100)
      ,[icu_patients_per_million] varchar (100)
      ,[hosp_patients] varchar (100)
      ,[hosp_patients_per_million] varchar (100)
      ,[weekly_icu_admissions] varchar (100)
      ,[weekly_icu_admissions_per_million] varchar (100)
      ,[weekly_hosp_admissions] varchar (100)
      ,[weekly_hosp_admissions_per_million] varchar (100)
      ,[new_tests] bigint

)

-- =============================================
 -- Truncate table 
-- =============================================

truncate table [Covid-19].[dbo].[WRK_CovidDeaths]

-- =============================================
 -- Insert into table
-- =============================================


insert into WRK_CovidDeaths
(
     [iso_code]
      ,[continent] 
      ,[location] 
      ,[date] 
      ,[population] 
      ,[total_cases] 
      ,[new_cases] 
      ,[new_cases_smoothed] 
      ,[total_deaths] 
      ,[new_deaths]  
      ,[new_deaths_smoothed] 
      ,[total_cases_per_million] 
      ,[new_cases_per_million] 
      ,[new_cases_smoothed_per_million] 
      ,[total_deaths_per_million] 
      ,[new_deaths_per_million] 
      ,[new_deaths_smoothed_per_million] 
      ,[reproduction_rate] 
      ,[icu_patients] 
      ,[icu_patients_per_million] 
      ,[hosp_patients] 
      ,[hosp_patients_per_million] 
      ,[weekly_icu_admissions] 
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions] 
      ,[weekly_hosp_admissions_per_million] 
      ,[new_tests]  
)
-- =============================================
 -- Select data from Raw table 
-- =============================================

select
       [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,cast([population] as bigint)
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
      ,[new_tests]
  FROM [Covid-19].[dbo].[OLE DB Raw_CovidDeaths]

  -- (120331 rows affected(have uploaded to the database))

  --**************************************************************************************************


  -- =============================================
 -- Below is the area where I prefer to execute my Sql querry so it can store for Auditbility purpose
-- =============================================

-- =============================================
-- Overview of Covid19 deaths Database
-- =============================================
SELECT 
       [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_tests]
  FROM [Covid-19].[dbo].[WRK_CovidDeaths]

  -- =============================================
-- find the Totals Deaths by country
-- =============================================
SELECT 
        [location]
      ,max([total_deaths]) as Total_Deaths
     FROM [Covid-19].[dbo].[WRK_CovidDeaths]
	  group by [location]
	  order by [location]

  -- =============================================
-- find the percentage of detah rate by country
-- =============================================
SELECT 
			 [location]
			,[date]
		    ,[total_cases]
		    ,[total_deaths]
			 ,(cast([total_deaths] as float)/cast([total_cases] as float))*100 as DeathPercantage
 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
 where [location] like '%United Kingdom%'
 order by 2

   -- =============================================
-- find the Total cases Vs Population (infection rate Vs population)
-- =============================================
SELECT      [date]
			,[population]
		    ,[total_cases]
		    
			 ,cast([total_cases] as float)/(cast([population] as float))*100 as Total_casePercentage
 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
 where [location] like '%United Kingdom%'

-- =============================================
-- Countries with hightest infection rate Vs population
-- =============================================
SELECT 
			 [location]
		    ,[population]
		    ,max([total_cases]) as Maximumcases
		    ,max(cast([total_cases] as float)/(cast([population] as float)))*100 as Total_casePercentage
			
 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
  where [population] >0
 group by [location],[population]
 order by Total_casePercentage desc

 -- =============================================
-- Countries with hightest death rate Vs Population
-- =============================================

SELECT 
			 [location]
		    ,[population]
		    ,max([total_deaths]) as TotalsDeaths
		    ,max(cast([total_deaths] as float)/(cast([population] as float)))*100 as MaximumDeathRate
			
 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
   where [population] >0
 group by [location],[population]
 order by MaximumDeathRate desc

  -- =============================================
-- Global Numbers
-- =============================================
 SELECT
			 [continent]
		     ,max([total_deaths]) as TotalsDeaths
			 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
			 where len([continent])<>0
Group by [continent]
		    
 -- =============================================
-- sun of new cases Global Numbers
-- =============================================
SELECT

			 SUM([new_cases]) as TotalNewcases
		     ,SUM([new_deaths]) as TotalNewDeaths
			 ,[date]
			 FROM [Covid-19].[dbo].[WRK_CovidDeaths]
			 group by [date]
			 order by [date]

-- =============================================
-- join the vacination table with Covid death table
-- =============================================

select cd.continent,cd.location,cd.population,cd.new_cases,cd.new_deaths,cd.total_cases,
cv.date,cv.new_vaccinations,cv.people_fully_vaccinated,cv.total_tests,cv.total_vaccinations

from [Covid-19].[dbo].[WRK_CovidDeaths]  cd
join [Covid-19].[dbo].[WRK_covid19_vacination] cv
on cd.location = cv.location
and 
cd.date = cv.date
order by cd.date

-- =============================================
-- Find out Total Population Vs Vacination (new vacination per day)**to understand the Partition clause
-- so basically we are finding the Rolling_vacination_count
-- =============================================

select cd.continent,cd.location,cd.population,
cv.date,cv.new_vaccinations
,SUM(cv.new_vaccinations)  over (partition by cd.location order by cd.location, cd.date) as total_Vacination

from [Covid-19].[dbo].[WRK_CovidDeaths]  cd
join [Covid-19].[dbo].[WRK_covid19_vacination] cv
on cd.location = cv.location
and 
cd.date = cv.date
and cd.continent is not null
and LEN(cd.continent)<>0
order by cd.location

-- =============================================
-- so on the above querry we found  Rolling_vacination_count
-- now we need to find percentage of total vacination Vs population
-- to find that we need to calculate total vacination/population*100
--as total vacination is not the actually column in table we need to create CTE or TEMP table
-- =============================================

--with cte_vacipercentage (continent,location,population,date,new_vaccinations,total_Vacination)
--as 
--(
--select cd.continent,cd.location,cd.population,
--cv.date,cv.new_vaccinations
--,SUM(cv.new_vaccinations)  over (partition by cd.location order by cd.location, cd.date) as total_Vacination

--from [Covid-19].[dbo].[WRK_CovidDeaths]  cd
--join [Covid-19].[dbo].[WRK_covid19_vacination] cv
--on cd.location = cv.location
--and 
--cd.date = cv.date
--and cd.continent is not null
--and LEN(cd.continent)<>0

----order by cd.location
--)
--select *,
--case
--when total_Vacination=0 then null
--when population=0 then null


--else (cast(total_Vacination as float)/cast(population as float))*100 
--end as totalpercentage
--from cte_vacipercentage

--order by  location

-- =============================================
-- In previous querry we created calculated field and performe calculation
-- in this querry we will create TEMP table to find the maximum of totalpercentage vacination
-- =============================================

create table #maximum_Percentage_ofvacination
(
continent varchar(100),
location varchar (100),
population bigint,
date date,
new_vaccinations bigint,
total_Vacination bigint
)

insert into #maximum_Percentage_ofvacination

select cd.continent,cd.location,cd.population,
cv.date,cv.new_vaccinations
,SUM(cv.new_vaccinations)  over (partition by cd.location order by cd.location, cd.date) as total_Vacination

from [Covid-19].[dbo].[WRK_CovidDeaths]  cd
join [Covid-19].[dbo].[WRK_covid19_vacination] cv
on cd.location = cv.location
and 
cd.date = cv.date
and cd.continent is not null
and LEN(cd.continent)<>0

select location,population,max(total_Vacination) from #maximum_Percentage_ofvacination
group by location, population
order by location



END
