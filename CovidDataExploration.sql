Select * 
From Covid..CovidDeaths
order by 3,4;

Select * 
From Covid..CovidDeaths
order by 3,4;

--Selecting Data that is needed

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid..CovidDeaths 
where continent is NOT null
order by 1,2

-- total cases vs total deaths 

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_percentage
From Covid..CovidDeaths 
where continent is NOT null
order by 1,2

--for specific country

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_percentage
From Covid..CovidDeaths 
Where location = 'India' AND continent is NOT null
order by 1,2

-- total cases vs Population 

Select Location, date, population, total_cases,(total_cases/population)*100 as Cases_percentage
From Covid..CovidDeaths 
where continent is NOT null
order by 1,2

--for specific country

Select Location, date, population, total_cases,(total_cases/population)*100 as Cases_percentage
From Covid..CovidDeaths 
Where location = 'India' AND continent is NOT null
order by 1,2

-- for total/highest infection rate and count compare to population

Select Location, population, max(total_cases)as highest_infected_cases,max((total_cases/population)*100)as Population_infected_percent
From Covid..CovidDeaths 
where continent is NOT null
Group by Location, population
order by Population_infected_percent desc

--for total/highest death rate and count compare to population

Select Location, population, max(cast(total_deaths as int))as highest_death_cases,max((total_deaths/population)*100)as Population_death_percent
From Covid..CovidDeaths 
where continent is not null
Group by Location, population
order by highest_death_cases desc

-- by continent

Select continent, max(cast(total_deaths as int))as highest_death_cases,max(total_cases)as highest_infected_cases
From Covid..CovidDeaths
where continent is NOT null
Group by continent

--GLOBAL NUMBERS

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
From Covid..CovidDeaths 
where continent is NOT null
order by 1,2

--by timeline globally or you can say by date

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
From Covid..CovidDeaths 
where continent is NOT null
group by date
order by 1

--joining tables

Select * 
From Covid..CovidDeaths dea
join Covid..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date

Select * 
From Covid..CovidDeaths dea
Left join Covid..CovidVaccinations vac
on dea.location = vac.location And dea.date = vac.date;

Select * 
From Covid..CovidDeaths dea
Right join Covid..CovidVaccinations vac
on dea.location = vac.location And dea.date = vac.date;

Select * 
From Covid..CovidDeaths dea
Full Outer join Covid..CovidVaccinations vac
 on dea.location = vac.location And dea.date = vac.date;

--population vs vacccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.location order by dea.location,dea.date) as rolling_vaccination_count
From Covid..CovidDeaths dea
join Covid..CovidVaccinations vac
on dea.location = vac.location and 
dea.date = vac.date
where dea.continent is not null
order by 2,3

--to calculate percentage of vaccinated on rolling count by using cte

With Popvsvac (Continent, location, date, population, new_vaccination, rolling_vaccination_count)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.location order by dea.location,dea.date) as rolling_vaccination_count
From Covid..CovidDeaths dea
join Covid..CovidVaccinations vac
on dea.location = vac.location and 
dea.date = vac.date
where dea.continent is not null
)
select Continent,location,population,max(rolling_vaccination_count) as rolling_vaccination_count, 
max((rolling_vaccination_count/population)*100) as rolling_vaccination_percent
from Popvsvac
group by location,Continent,population
order by 1,2

--temp table

create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinated numeric,
rolling_vaccination_count numeric
)
insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.location order by dea.location,dea.date) as rolling_vaccination_count
From Covid..CovidDeaths dea
join Covid..CovidVaccinations vac
on dea.location = vac.location and 
dea.date = vac.date

select *,(rolling_vaccination_count/Population)*100 as rolling_vaccination_percent
from #PercentPopulationVaccinated
 
DROP Table if exists #PercentPopulationVaccinated

-- creating view 

Create View PercentPopulationvaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.location order by dea.location,dea.date) as rolling_vaccination_count
From Covid..CovidDeaths dea
join Covid..CovidVaccinations vac
on dea.location = vac.location and 
dea.date = vac.date
where dea.continent is not null

select * from PercentPopulationvaccinated

-- Another View

Create View CovidCombined as
Select dea.location,dea.date,dea.total_cases,dea.new_cases,dea.total_deaths,vac.total_vaccinations,
vac.people_vaccinated,vac.people_fully_vaccinated
FROM Covid..CovidDeaths dea
Join Covid..CovidVaccinations vac
On dea.location = vac.location And dea.date = vac.date;

select * from CovidCombined

-- to find if view exist or not 

IF OBJECT_ID('PercentPopulationvaccinated', 'V') Is Not Null
    PRINT 'View exists'
ELSE
    PRINT 'View does not exist';

--to find under which schema

SELECT 
    v.name AS view_name,
    s.name AS schema_name
FROM 
    sys.views v
JOIN 
    sys.schemas s ON v.schema_id = s.schema_id
WHERE 
    v.name = 'PercentPopulationvaccinated';  

-- in which database

EXEC sp_MSforeachdb '
USE [?];
IF EXISTS (SELECT 1 FROM sys.views WHERE name = ''PercentPopulationvaccinated'')
    PRINT ''Found in database: [?]'';
';
--to drop
DROP VIEW PercentPopulationvaccinated;