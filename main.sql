-- Getting an insight of Covid_Deaths dataset

--SELECT * FROM dbo.Covid_Deaths
--ORDER BY 3,4

--SELECT location,date,total_cases,new_cases,total_deaths,population 
--FROM dbo.Covid_Deaths
--ORDER BY 1,2

-- TOTAL CASES VS TOTAL DEATHS 
-- What percentage of cases end up dead

--SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS death_percentage
--FROM dbo.Covid_Deaths ORDER BY 1,2

-- TOTAL CASES VS POPULATION 
-- What percentage of India population got infected 

--SELECT location,date , population, total_cases, (total_cases/population) AS infected_percentage
--FROM dbo.Covid_Deaths
--WHERE location LIKE '%India%'
--ORDER BY 1,2

-- Countries with Highest Infection Rate as compared to Population

--SELECT location,population, MAX(total_cases) AS highest_infection_count, 
--MAX((total_cases/population)*100) AS highest_infected_percentage
--FROM dbo.Covid_Deaths
--GROUP BY location,population
--ORDER BY highest_infected_percentage DESC

-- Countries with Highest Death Rate as compared to Population

--SELECT location , MAX(cast(total_deaths as int)) AS highest_death_count
--FROM dbo.Covid_Deaths
--WHERE continent IS NOT NULL
--GROUP BY location
--ORDER BY highest_death_count DESC

-- Continent with Highest Death Rate
 
--SELECT continent , MAX(cast(total_deaths as int)) AS highest_death_count
--FROM dbo.Covid_Deaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY highest_death_count DESC

-- GLOBAL NUMBERS

--SELECT date, SUM(new_cases) AS total_new_cases
--FROM dbo.Covid_Deaths
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2

--SELECT date,SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_new_deaths, 
--SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as death_percentage
--FROM dbo.Covid_Deaths
--WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_cases <> 0
--GROUP BY date
--ORDER BY 1,2

--SELECT SUM(new_cases) AS total_cases,
--SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as death_percentage
--FROM dbo.Covid_Deaths
--WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_cases <> 0

-- Getting insight of Covid_Vaccination dataset

--SELECT * FROM Covid_Vaccinations
--ORDER BY 3,4;

--VACCINATION VS POPULATION 
--Select dc.continent,dc.location,dc.date,dv.new_vaccinations
--FROM dbo.Covid_Deaths dc
--JOIN dbo.Covid_Vaccinations dv
--ON dc.location = dv.location
--AND
--dc.date=dv.date
--WHERE dc.continent IS NOT NULL
--ORDER BY 2,3

--Select dc.continent,dc.location,dc.date,dv.new_vaccinations, 
--SUM(cast(dv.new_vaccinations AS bigint)) OVER (PARTITION BY dc.location ORDER BY dc.location) AS total_people_vaccinated
--FROM dbo.Covid_Deaths dc
--JOIN dbo.Covid_Vaccinations dv
--ON dc.location = dv.location
--AND
--dc.date=dv.date
--WHERE dc.continent IS NOT NULL
--ORDER BY 2,3

--WITH Pop_Vac (continent, location,population, date, new_vaccinations,total_people_vaccinated)
--AS
--(
--Select dc.continent,dc.location,dc.population,dc.date,dv.new_vaccinations, 
--SUM(CONVERT(bigint,dv.new_vaccinations)) OVER (PARTITION BY dc.location ORDER BY dc.location) AS total_people_vaccinated
--FROM dbo.CovidDeaths dc
--JOIN dbo.CovidVaccinations dv
--ON dc.location = dv.location
--AND
--dc.date=dv.date
--WHERE dc.continent IS NOT NULL)

--SELECT *,(total_people_vaccinated/population)*100 AS per_population_vaccination FROM Pop_Vac;

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--continent varchar(255),
--location varchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--total_people_vaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--Select dc.continent,dc.location,dc.date,dc.population,dv.new_vaccinations, 
--SUM(CONVERT(bigint,dv.new_vaccinations)) OVER (PARTITION BY dc.location ORDER BY dc.location) AS total_people_vaccinated
--FROM dbo.Covid_Deaths dc
--JOIN dbo.Covid_Vaccinations dv
--ON dc.location = dv.location
--AND
--dc.date=dv.date
--WHERE dc.continent IS NOT NULL

--SELECT *,(total_people_vaccinated/population) * 100  AS per_pop_vacc FROM #PercentPopulationVaccinated;

--SELECT dc.continent, dc.location, dc.date, dc.population
--, MAX(dv.total_vaccinations) as people_vaccinated
--FROM dbo.Covid_Deaths dc
--JOIN dbo.Covid_Vaccinations dv
--	ON dc.location = dv.location
--	and dc.date = dv.date
--WHERE dc.continent IS NOT NULL
--GROUP BY dc.continent, dc.location, dc.date, dc.population
--ORDER BY 1,2,3

--SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) AS total_deaths, 
--SUM(cast(new_deaths as bigint))/SUM(new_Cases)*100 AS death_percentage
--FROM dbo.Covid_Deaths 
--WHERE continent IS NOT NULL
--ORDER BY 1,2

---- The above can be verified for given data for World

--SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS bigint)) AS total_deaths, 
--SUM(cast(new_deaths AS bigint))/SUM(new_Cases)*100 as death_percentage
--From dbo.Covid_Deaths
--WHERE location = 'World'
--ORDER BY 1,2

--SELECT location, SUM(cast(new_deaths AS bigint)) AS total_death_count
--From dbo.Covid_Deaths
--WHERE continent is null AND  location NOT IN ('World', 'European Union', 'International')
--GROUP BY location
--ORDER BY total_death_count DESC

--SELECT location, population, MAX(total_cases) as highest_infection_count, 
--Max((total_cases/population))*100 as percent_population_infected
--FROM dbo.Covid_Deaths
--GROUP by location, population
--ORDER BY percent_population_infected DESC



-- QUERIES WHOSE RESULTS ARE USED TO CREATE VISUALIZATION

SELECT SUM(new_cases) AS total_cases,
SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as death_percentage
FROM dbo.Covid_Deaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_cases <> 0
ORDER BY 1,2

SELECT location, SUM(cast(new_deaths AS bigint)) AS total_death_count
From dbo.Covid_Deaths
WHERE continent IS NULL AND  location NOT IN ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
GROUP BY location
ORDER BY total_death_count DESC

SELECT location, population, MAX(total_cases) as highest_infection_count, 
Max((total_cases/population))*100 as percent_population_infected
FROM dbo.Covid_Deaths
GROUP by location, population
ORDER BY percent_population_infected DESC

SELECT location,population, date,MAX(total_cases) AS highest_infection_count, 
MAX((total_cases/population)*100) AS highest_infected_percentage
FROM dbo.Covid_Deaths
GROUP BY location,population,date
ORDER BY highest_infected_percentage DESC

