--select *
--from CovidDeaths$
--where continent is not null
--order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

--select location, date,total_cases,new_cases, total_deaths, population
--from CovidDeaths$
--order by 1,2

--Looking at total  cases versus total deaths
--shows likelihood of dying if you contract Covid in your country

--select location, date,total_cases, total_deaths,(total_deaths/total_cases)*100 as PercentageDeath
--from CovidDeaths$
--where location like ('%states%')
--order by 1,2

--Looking at Total Cases versus Population
--shows what percentage of population got Covid

--select location, date,total_cases, population,(total_cases/population)*100 as PercentageDeath
--from CovidDeaths$
--where location like ('%states%')
--order by 1,2

--Looking at countries with highest infection rate  compared to population

--select location,population, Max (total_cases) as HighestInfectionCount,max (total_cases/population)*100 as PercentPopulationInfected
--from CovidDeaths$
--where location like ('%states%')
--group by location, population 
--order by 1,2 desc

--Showing countries with highest deathcount per populaton




--select Location, MAX (cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
----Where location like '%states%'
--where continent is not null
--group by location 
--order by TotalDeathCount desc

--Let's break data by continent

--select continent, MAX (cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
----Where location like '%states%'
--where continent is not null
--group by continent 
--order by TotalDeathCount desc




--Showing the continents with total deathcount per population

--select location, MAX (cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
----Where location like '%states%'
--where continent is null
--group by location 
--order by TotalDeathCount desc

--Global numbers

--select location, date,total_cases, population,(total_cases/population)*100 as PercentageDeath
--From CovidDeaths$
----where location like ('%states%')
--Where continent is not null
--order by 1,2


--select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as  total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
--From CovidDeaths$
----where location like ('%states%')
--Where continent is not null
----group by date
--order by 1,2

--Looking at Total Population versus Vaccinations

with PopvsVac (Continent,Location,Date,new_vaccinations,Population,RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/Population*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
----order by 2,3
)
select *, (RollingPeopleVaccinated/Population*100)
from PopvsVac

--use CTE

--with PopvsVac
--as

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert Into #PercentPopulationVaccinated

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/Population*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
----Where dea.continent is not null


select *, (RollingPeopleVaccinated/Population*100)
from #PercentPopulationVaccinated

----Creating Views to store data for later visualisations

Create View PercentPopulationVaccinated as

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/Population*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select everything 
from PercentPopulationVaccinated