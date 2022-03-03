SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4


-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2



-- Looking at Total Cases vs. Total Deaths
-- Shows likelihood (DeathPercentage) of dieing if a US citizen was to contract covid.

Select Location, date, total_cases,total_deaths, 
(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2


-- Total cases vs Population
-- Shows what percentage of the population got Covid
-- As of March 1, 2022, 23.76% of the US population has contracted covid.

Select Location, date,  Population, 
(total_cases/Population)*100 as PercentPopulationInfected
from PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2


-- What countries have the highest infected rate compared to population?

Select Location, Population,  MAX(total_cases) as HighestInfectionCount,
Max((total_cases/Population))*100 as MaxPercentPopulationInfected
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by population,location
order by MaxPercentPopulationInfected desc




-- Fatalities
-- What countries have the highest death count per population?
-- totaldeaths is nvarchar need to cast it to int,

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



-- Location, excluding income classes.
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is null
and location not like '%income%'
group by location
order by TotalDeathCount desc





-- Looking at by continent
-- Showing continents with the highest death count per population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc





--										Global Numbers
-- total cases, total deaths, and death percentage time series for  global numbers
Select date, 
SUM(new_cases) as TotalCases,
SUM(cast(new_deaths as int)) as TotalDeaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))* 100  as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2


--  total cases, total deaths, and death percentage for the whole globe.
Select
SUM(new_cases) as TotalCases,
SUM(cast(new_deaths as int)) as TotalDeaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))* 100  as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2





--                 Vaccinations and Deaths

--	Total Population vs Vaccination
--  Whats the total amount of people in the world that have been vaccinated?

--Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select DTH.continent, DTH.location, DTH.date, DTH.population, VAX.new_vaccinations,
SUM(Cast(VAX.new_vaccinations as int)) 
OVER (Partition by DTH.location order by DTH.location, DTH.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as DTH
join PortfolioProject.dbo.CovidVaccinations as VAX
	on DTH.location=VAX.location 
	and DTH.date = VAX.date
where DTH.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/population) * 100
from PopvsVac






-- Temp table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(225),
location nvarchar(225), 
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated bigint
)

Insert into #PercentPopulationVaccinated
Select  DTH.continent, DTH.location, DTH.date, DTH.population, VAX.new_vaccinations,
SUM(Cast(VAX.new_vaccinations as int)) 
OVER (Partition by DTH.location order by DTH.location, DTH.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as DTH
join PortfolioProject.dbo.CovidVaccinations as VAX
	on DTH.location=VAX.location 
	and DTH.date = VAX.date
-- where DTH.continent is not null
-- order by 2,3


Select *, (RollingPeopleVaccinated/population) * 100
from #PercentPopulationVaccinated




-- Creating View to store data for later viz

Create View PercentPoulationVaccinated as
Select  DTH.continent, DTH.location, DTH.date, DTH.population, VAX.new_vaccinations,
SUM(Cast(VAX.new_vaccinations as int)) 
OVER (Partition by DTH.location order by DTH.location, DTH.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as DTH
join PortfolioProject.dbo.CovidVaccinations as VAX
	on DTH.location=VAX.location 
	and DTH.date = VAX.date
 where DTH.continent is not null
 
