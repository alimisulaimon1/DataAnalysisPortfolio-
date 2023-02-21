Select *
 From CovidProject..CovidDeaths
 order by 3,4

 --Select *
 --From CovidProject..CovidVaccinations
 --order by 3,4
 
 -- select data we want to use

 Select Location, date, total_cases, new_cases, total_deaths, population
 From CovidProject..CovidDeaths

 -- looking at pacentage of death

 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 From CovidProject..CovidDeaths

 -- looking at percentage of death in united state

 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 From CovidProject..CovidDeaths
 Where location like '%states%'

 -- total case vs population
 -- show what percentage of population got covid
 Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage_cases
 From CovidProject..CovidDeaths

 -- Looking at Countries with Highest infection Rate compared to Population
 Create View Countries_highest_covid as
 Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as Percentage_cases
 From CovidProject..CovidDeaths
 Group by location, population
 --order by Percentage_cases desc

 --Showing Countries with Highest Death Count per population
 Create View Countries_with_highest_death as
 Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From CovidProject..CovidDeaths
 Where continent is not null
 Group by location
-- order by TotalDeathCount desc

 -- showing Total death by continent
 Create View Total_death_by_continent as
 select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From CovidProject..CovidDeaths
 Where continent is not  null
 Group by continent
 --order by TotalDeathCount desc

 -- total populaton against total Vaccination
 with PopvsVac (continent, location, date, population, new_vaccination, PeopleVaccinated)
 as
 (

 Select death.continent, death.location, death.date, death.population, vac.new_vaccinations
 , SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by death.location order by death.location, death.date) as PeopleVaccinated
 --,(people_vaccinated/population)*100
 From CovidProject..CovidDeaths death
 join CovidProject..CovidVaccinations vac
   on death.location = vac.location
   and death.date = vac.date
Where death.continent is not null
--order by 2,3
)
Select*, (PeopleVaccinated/population)* 100 From PopvsVac

-- Creating View for data visualixation
Create View DeathPercentage as
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 From CovidProject..CovidDeaths
 --Select * from DeathPercentage
 Create View Death_in_united_state as
 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 From CovidProject..CovidDeaths
 Where location like '%states%'

 Create View People_with_covid as
 Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage_cases
 From CovidProject..CovidDeaths

 Create View OercentagePopulationVaccinated as
 Select death.continent, death.location, death.date, death.population, vac.new_vaccinations
 , SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by death.location order by death.location, death.date) as PeopleVaccinated
 --,(people_vaccinated/population)*100
 From CovidProject..CovidDeaths death
 join CovidProject..CovidVaccinations vac
   on death.location = vac.location
   and death.date = vac.date
Where death.continent is not null
--order by 2,3


