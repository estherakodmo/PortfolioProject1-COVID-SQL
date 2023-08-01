

SELECT *
FROM Portofolio_Project1.dbo.CovidDeaths
ORDER BY 3, 4


--SELECT *
--FROM Portofolio_Project1.dbo.CovidVaccinations
--ORDER BY 3, 4


-- Select data that will be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portofolio_Project1.dbo.CovidDeaths
ORDER BY 1, 2

-- Looking for total cases vs total deaths
-- Shows the likelyhood of diying if you contract the disease in your country.

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
FROM Portofolio_Project1.dbo.CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2


-- Looking for total cases vs population
-- Shows what percentage of population got covid

SELECT location, date,population, total_cases, (total_cases/population)*100 as infected_population_percentage
FROM Portofolio_Project1.dbo.CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2


SELECT location, date,population, total_cases, (total_cases/population)*100 as total_casespercentage
FROM Portofolio_Project1.dbo.CovidDeaths
WHERE location LIKE '%Chad%'
ORDER BY 1, 2


-- Looking at countries with highest infection rate compared to population

SELECT TOP 20 location, population, Max(total_cases) as highest_infection_count, Max((total_cases/population))*100 as infected_population_percentage
FROM Portofolio_Project1.dbo.CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY infected_population_percentage DESC

-- Showing countries with highest total deaths per popilation

SELECT location, MAX(total_deaths) as total_deaths_count
FROM Portofolio_Project1.dbo.CovidDeaths
--WHERE location LIKE '%Chad%'
GROUP BY location
ORDER BY total_deaths_count DESC


-- Let's break it down by continent

SELECT continent, MAX(total_deaths) as total_deaths_count
FROM Portofolio_Project1.dbo.CovidDeaths
--WHERE location LIKE '%Chad%'
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY total_deaths_count DESC


-- Global numbers

-- Loking at the total population vs vaccination


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling PeopleVaccinated
--, (Rolling PeopleVaccinated/population)*100
FROM Portofolio_Project1.dbo.CovidDeaths as dea
JOIN Portofolio_Project1.dbo.CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null and dea.continent like '%africa%'
ORDER by 2, 3


-- USE CTE

With popVSvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portofolio_Project1.dbo.CovidDeaths as dea
JOIN Portofolio_Project1.dbo.CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null and dea.continent like '%africa%'
--ORDER by 2,3
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM popVSvac



-- TEMP TABLE


Drop table if exists #percentpopulationvaccinated  
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vacciations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentpopulationvaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portofolio_Project1.dbo.CovidDeaths as dea
JOIN Portofolio_Project1.dbo.CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null and dea.continent like '%africa%'
--ORDER by 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #percentpopulationvaccinated

create view percentpopulationvaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portofolio_Project1.dbo.CovidDeaths as dea
JOIN Portofolio_Project1.dbo.CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER by 2,3


SELECT *
FROM percentpopulationvaccinated

