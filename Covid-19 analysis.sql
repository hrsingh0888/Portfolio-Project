select * from coviddeaths
order by 3,4;

select * from covidvaccinations
order by 3, 4;

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths order by 1, 2;

-- Looking total Cases vs Total Deaths

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS Death_percentage
FROM
    coviddeaths
WHERE
    location LIKE '%states%'
ORDER BY 1 , 2;

-- Looking total Cases Vs Population
SELECT 
    location,
    total_cases,
    total_deaths,
    (total_cases / population) * 100 AS population_cases
FROM
    coviddeaths
ORDER BY 1 , 2;

-- Looking at countries with highest infection rate compared to poulation

SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX(total_cases / population) * 100 AS percent_population_infected
FROM
    coviddeaths
GROUP BY location , population
ORDER BY percent_population_infected desc;


-- Highest Death count per population

SELECT 
    location,
    population,
    MAX(total_deaths) AS Highest_deaths,
    MAX(total_deaths / population) * 100 AS perecnt_population_deaths
FROM
    coviddeaths
GROUP BY location , population
ORDER BY perecnt_population_deaths desc;

-- Global Numbers

select date, sum(new_cases), sum(new_deaths) as total_deaths ,sum(new_deaths)/ sum(new_cases)* 100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1, 2;


SELECT 
    *
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
        
-- Total Vaccination vs Population

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
ORDER BY 2 , 3;

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM((vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

