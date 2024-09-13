select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccination
--order by 3,4

select  location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%russia%' and continent is not null
order by 1,2

select  location, date, population, total_cases, (total_cases/population)*100 as PercentPopulation?nfected
from PortfolioProject..CovidDeaths
-- where location like '%russia%'
order by 1,2

select  location, population, Max(total_cases) as Highest?nfectionCount, Max((total_cases/population))*100 as PercentPopulation?nfected
from PortfolioProject..CovidDeaths
-- where location like '%russia%'
where continent is not null
Group by location, population
order by PercentPopulation?nfected desc


select  location, Max (cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
-- where location like '%russia%'
where continent is not null
Group by location
order by TotalDeathsCount desc



select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths 
where continent is not null
group by date 
order by 1,2


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths 
where continent is not null
order by 1,2





-- Joins--


select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date


--Total population vs vaccination


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3




--CTE--


with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac



-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select*
from PercentPopulationVaccinated




