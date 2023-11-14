
SELECT * FROM PortfoliProjectAlex..CovidDeaths
SELECT * FROM PortfoliProjectAlex..CovidVaccinations
--SELECT location,date, population, total_cases,total_deaths
--FROM PortfoliProjectAlex..CovidDeaths 
--WHERE location like '%kingdom'
--ORDER BY 1,2

/* Looking at total Cases Vs total deaths */

/* Number of case and the the number of death per country */

/* Total case and deaths in Morocco */
SELECT  location, date, total_cases, total_deaths
FROM PortfoliProjectAlex..CovidDeaths
WHERE location = 'Morocco'

SELECT Location, total_deaths, population
FROM PortfoliProjectAlex..CovidDeaths
ORDER BY 1,2,3

-- Looking at Total Cases Vs Total Deaths per Cosuntry

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathsPercentage
FROM PortfoliProjectAlex..CovidDeaths
WHERE location  like '%Kingdom%'
ORDER BY 1,2

-- Total cases VS Population
-- Shows what kind of population got Covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfoliProjectAlex..CovidDeaths
-- WHERE location  like '%Kingdom%'
ORDER BY 1,2

-- Looking at countries with the highest infection compared to population

SELECT location, population, MAX (total_cases) AS MaxTotalCases, MAX (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfoliProjectAlex..CovidDeaths
-- WHERE location  like '%Kingdom%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing countries with the highest death count per population

SELECT location, MAX (CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfoliProjectAlex..CovidDeaths
-- WHERE location  like '%Kingdom%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Lest's break thinks down by continent 
--- Showing continent with highest death count per population 

SELECT location, MAX (CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfoliProjectAlex..CovidDeaths
-- WHERE location  like '%Kingdnom%'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT continent, MAX (CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfoliProjectAlex..CovidDeaths
-- WHERE location  like '%Kingdnom%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--- GLOBAL NUMBERS
-- Showing tatal cases and toatl death by date (per day) in the world

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathsPercentage
FROM PortfoliProjectAlex..CovidDeaths
--WHERE location  like '%Kingdom%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- OVERALL
-- Showing tatal cases and toatl deaths in the world since Covid has started

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathsPercentage
FROM PortfoliProjectAlex..CovidDeaths
--WHERE location  like '%Kingdom%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--- COVIDVACCINATION 

SELECT * FROM PortfoliProjectAlex..CovidVaccinations

-- Join the two tables

SELECT * FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date

-- Looking at the total Population VS Vaccinations 
-- How many people or the toatl amount of people in the world that have been vaccinated

SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Let's look at the toatl vacciniation per country Example Morocco

-- Total vaccination in Morocco per date
SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND dea.location = 'Morocco' 
AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3

-- Overall total and percentage of vaccinated people in Morocco 

SELECT dea.location, dea.population, SUM (CAST (vac.new_vaccinations AS INT)) AS TotalVaccinatedPeople, 
(SUM (CAST (vac.new_vaccinations AS INT))/dea.population)*100 AS PercentageVaccinatedPeople
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.location = 'Morocco' 
GROUP By dea.location,dea.population

-- Overall total and percentage of vaccinationed people in the world 

--SELECT dea.location, dea.population, SUM (CAST (vac.new_vaccinations AS INT)) AS TotalVaccinatedPeople,
--(SUM (CAST (vac.new_vaccinations AS INT))/dea.population)*100 AS PercentageVaccinatedPeople
--FROM PortfoliProjectAlex..CovidDeaths dea
--JOIN PortfoliProjectAlex..CovidVaccinations vac
--    ON dea.location = vac.location
--    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--GROUP By dea.location,dea.population
--ORDER BY PercentageVaccinatedPeople DESC

-- Looking at the total Vaccinations per location

--SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location) AS TotalVaccination
--FROM PortfoliProjectAlex..CovidDeaths dea
--JOIN PortfoliProjectAlex..CovidVaccinations vac
--    ON dea.location = vac.location
--    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL 
--AND dea.location = 'MOROCCO'
--ORDER BY 2,3

SELECT DISTINCT dea.continent,dea.location, dea.population,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location) AS TotalVaccination
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY  dea.location

-- Looking at Total Population Vs Vaccination

-- Looking First at Rolling people vaccinated per location and per date
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY  2,3

-- Looking at Total population VS RollingPeopleVaccinated 
-- Looking First at Rolling people vaccinated per location and per date

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date)/dea.population)*100 
--AS PercentageVaccinatedPeople
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY  2,3

-- USE CTE 

WITH PopVsVac (continent,location, date, population,new_vaccination, RollingPeopleVaccinated )
AS
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date)/dea.population)*100 
--AS PercentageVaccinatedPeople
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
----AND dea.location = 'Albania'
--ORDER BY  2,3
)

SELECT *, (p.RollingPeopleVaccinated/p.population )*100
 AS PercentagePeopleVaccinated FROM PopVsVac p


 -- Use Temp Table

 DROP TABLE IF EXISTS #PercentPopulationVaccinated
 CREATE TABLE #PercentPopulationVaccinated
 ( 
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccination numeric,
 RollingpeopleVaccinated numeric,
 )

 INSERT INTO #PercentPopulationVaccinated
 
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date)/dea.population)*100 
--AS PercentageVaccinatedPeople
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
AND dea.location = 'Albania'
--ORDER BY  2,3


SELECT *, (p.RollingPeopleVaccinated/p.population )*100
 AS PercentagePeopleVaccinated FROM #PercentPopulationVaccinated p

 -- Use Views
 -- Creating view to store data for later visualization 

 CREATE VIEW PercentagePeopleVaccinated
 AS
 SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location order by dea.location,dea.date)/dea.population)*100 
--AS PercentageVaccinatedPeople
FROM PortfoliProjectAlex..CovidDeaths dea
JOIN PortfoliProjectAlex..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--AND dea.location = 'Albania'
--ORDER BY  2,3
 
 SELECT * FROM PercentagePeopleVaccinated

 -- Use stored procedure