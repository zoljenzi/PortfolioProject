Select *
From PortfolioProject..CovidDeaths
 where continent <> ''
ORDER by 3,4

Select *
From PortfolioProject..CovidVaccinations
ORDER by 3,4

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Group by date
ORDER by 1,2

Select [continent] , MAX(Total_deaths) as TotalDeathcount
From PortfolioProject..CovidDeaths
--where continent <> ''
Group By continent
ORDER by TotalDeathcount DESC

UPDATE PortfolioProject..CovidDeaths
SET new_cases = 0
WHERE new_cases = NULL

UPDATE PortfolioProject..CovidDeaths
SET new_deaths = NULL
WHERE new_deaths = 0

SELECT *
From PortfolioProject..CovidDeaths
where location like 'Serbia'

select a.continent, a.location, a.date, a.population,b.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION by a.location Order By a.location, a.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
    On a.[location] = b.[location]
    and a.date = b.date 
where a.continent is not null
order by 2,3

--CTE 

WITH PopvsVac (continent, Location, date , population, new_vaccinations, RollingPeopleVaccinated)
as

(select a.continent, a.location, a.date, a.population,b.new_vaccinations,
SUM(cast(new_vaccinations as float))OVER (PARTITION by a.location Order By a.location, a.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
    On a.[location] = b.[location]
    and a.date = b.date 
where a.continent IS NOT NULL)
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

--TEMP Table
DROP Table If EXISTS #PercentPopulationsVaccinated
Create Table #PercentPlpulationsVaccinated
(continent nvarchar (255),
Location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert INTO #PercentPopulationsVaccinated
select a.continent, a.location, a.date, a.population,b.new_vaccinations,
SUM(cast(new_vaccinations as float))OVER (PARTITION by a.location Order By a.location, a.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
    On a.[location] = b.[location]
    and a.date = b.date 
where a.continent IS NOT NULL
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100
From #PercentPlpulationsVaccinated

--Creating View to store data for later visualizations 
Create View PercentPopulationsVaccinated as 
select a.continent, a.location, a.date, a.population,b.new_vaccinations,
SUM(cast(new_vaccinations as float))OVER (PARTITION by a.location Order By a.location, a.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
    On a.[location] = b.[location]
    and a.date = b.date 
where a.continent IS NOT NULL


Select * 
From PercentPopulationsVaccinated