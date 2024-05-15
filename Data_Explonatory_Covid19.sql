-- SQL Data Exploration of comparaison between vaccination cases and death cases from corona

select * 
from death$
order by 3,4

select * 
from death$
where continent is null

select Location, date, total_cases, total_deaths, population
from death$
where continent is not null 
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/cast(total_cases as float)) *100 as DeathPercetage
from death$
where location like 'moro%'
where continent is not null 
order by 1,2

-- Look at Total Cases vd Population
select Location, date, total_cases, population, (cast(total_cases as float)/population) *100 as DeathPercetage
from death$
where location like 'moro%'
and continent is not null 
order by 1,2

-- Looking at countries with the hightest Rate compared to population
select Location, MAX(total_cases) as HeighestInfection, population, MAX((cast(total_cases as float)/population)) *100 as Percetagepopinfcted
from death$

group by location, population
order by Percetagepopinfcted desc

-- showing countries with highest Death count per population

select location, MAX(cast(Total_deaths as int)) as totaldeath
From death$
where continent is not null
group by location
order by totaldeath desc

select Max(cast(Total_deaths as int)) as totaldeath
from death$


select location, population, MAX(total_deaths), MAX(total_deaths/population ) *100 as percPerDeath 
from death$
where location like 'morocco'
and continent is not null 
Group by location, population
order by percPerDeath desc

-- Let's break things down by continent
-- showing continents with highest death count
select continent, MAX(cast(Total_deaths as int)) as totaldeath
From death$
where continent is not  null
group by continent
order by totaldeath desc

-- Global Number
select  date,   sum(cast(new_cases as float)) as totalCases, sum(cast(new_deaths as float)) as totalDeath, sum(cast(new_deaths as int)) / sum(nullif(cast(new_cases as float),0)) as Pecentage	
from death$
where continent is not null
group by date
order by 1,2

select    sum(cast(new_cases as float)) as totalCases, sum(cast(new_deaths as int)) as totalDeath, sum(cast(new_deaths as int)) / sum(nullif(cast(new_cases as float),0)) as Pecentage	
from death$
where continent is not null
order by 1,2

-- Join vaccination and death
select * 
from death$ 
join vaccination$ 
on death$.date = vaccination$.date 
and death$.location = vaccination$.location  

-- Looking at Total Population vs vaccination
select death$.continent, death$.location, death$.date, death$.population, 
				vaccination$.new_vaccinations
from death$ 
join vaccination$ 
on death$.date = vaccination$.date 
and death$.location = vaccination$.location  
where death$.continent is not null
and vaccination$.new_vaccinations > 0
order by 2,3

--2
select death$.continent, death$.location, death$.date, death$.population, vaccination$.new_vaccinations, sum(cast(vaccination$.new_vaccinations as float))
over (partition by death$.location
order by death$.location, death$.date) as RollingPeopleVaccinated
from death$ 
join vaccination$ 
on death$.date = vaccination$.date 
and death$.location = vaccination$.location  
where death$.continent is not null
and vaccination$.new_vaccinations is not null
order by 3

-- Use CTE
with  PopvsVac (Continent, Location, Date, Population, New_Vaccinations,  RollingPeopleVaccinated)
as
(
select death$.continent, death$.location, death$.date, death$.population, vaccination$.new_vaccinations, sum(cast(vaccination$.new_vaccinations as float))
over (partition by death$.location
order by death$.location, death$.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

from death$ 
join vaccination$ 
on death$.date = vaccination$.date 
and death$.location = vaccination$.location  
where death$.continent is not null
and vaccination$.new_vaccinations is not null

--order by 3
)
select *, (RollingPeopleVaccinated / Population)*100
from PopvsVac



