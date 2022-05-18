--select *
--from PortfolioProject.dbo.Covid_fatal
--order by 3, 4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3, 4

-- Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.Covid_fatal
where continent is not null
order by 1, 2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, round((total_deaths / total_cases)*100,2) as DeathPercentage
from PortfolioProject.dbo.Covid_fatal
where location like 'United States'
order by 1, 2

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid
select Location, date, total_cases, population, round((total_cases / population)*100,2) as CovidCasesPercentage
from PortfolioProject.dbo.Covid_fatal
where location like 'United States'
order by 1, 2

-- Looking at top 5 Countries with Highest Infections Rate compared to Population
select top 5 Location, population, max(total_cases) as Highest_Infection_Count, max(round((total_cases / population)*100,2)) as MaxCovidCasesPercentage
from PortfolioProject.dbo.Covid_fatal
group by location, population
--where location like 'United States'
order by 4 desc

-- Showing Countries with Highest Covid Fatal Count
select Location, max(cast(total_deaths as int)) as Total_Fatal_Count--, max(round((total_deaths / population)*100,2)) as FatalCasesPercentage
from PortfolioProject.dbo.Covid_fatal
where continent is not null
group by location
--where location like 'United States'
order by 2 desc

-- Showing Continents with Highest Covid Fatal Count per population
select continent, max(cast(total_deaths as int)) as Total_Fatal_Count
from PortfolioProject.dbo.Covid_fatal
where continent is not null
group by continent
order by 2 desc


-- GLOBAL NUMBERS

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))  as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
from PortfolioProject.dbo.Covid_fatal
where continent is not null
--group by date
order by 1, 2

-- Looking at Total Population vs Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_fatal dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- USE CTE

with PopvsVac as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_fatal dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null)
select *, (RollingPeopleVaccinated/population)*100 as vaccinated
from PopvsVac

-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination bigint,
RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_fatal dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated2 AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_fatal dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated