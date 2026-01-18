-- a. Datewise Likelihood of dying due to Covid total cases vs total death in India
SELECT 
	date, 
	total_cases, 
	total_deaths 
FROM "CovidDeaths" 
WHERE location LIKE '%India%';

-- b. Total % of deaths out of entire population in India
-- population is a character, that is why we need to convert it into number
SELECT 
	(MAX(total_deaths)/AVG(population::numeric)*100) 
FROM "CovidDeaths" 
WHERE location LIKE '%India%';


-- c. Verify b by getting info separately
SELECT 
	population, 
	total_deaths 
FROM "CovidDeaths" 
WHERE location LIKE '%India%';

-- d. Country with highest death as a % of population
SELECT 
	location, 
	(MAX(total_deaths)/AVG(population::numeric)*100) AS death_percentage 
FROM "CovidDeaths" 
GROUP BY location 
ORDER BY death_percentage;

-- e. Total % of Covid positive cases in India
SELECT 
	(MAX(total_cases)/AVG(population::numeric)*100) 
FROM "CovidDeaths" 
WHERE location LIKE '%India%';

-- f. Country wise total % of Covid positive cases in the world
SELECT 
	location, 
	(MAX(total_cases)/AVG(population::numeric)*100) AS case_percentage 
FROM "CovidDeaths" 
GROUP BY location; 

-- g. Continent wise positive cases
SELECT 
    continent, 
    SUM(max_cases_per_country) AS total_continent_cases
FROM (
    SELECT 
        continent, 
        location, 
        MAX(total_cases) AS max_cases_per_country
    FROM "CovidDeaths"
    WHERE continent IS NOT NULL
    GROUP BY continent, location
) AS country_level_totals
GROUP BY continent
ORDER BY total_continent_cases DESC;

-- h. Continent wise deaths
SELECT 
    continent, 
    SUM(max_deaths_per_country) AS total_continent_deaths
FROM (
    SELECT 
        continent, 
        location, 
        MAX(total_deaths) AS max_deaths_per_country
    FROM "CovidDeaths"
    WHERE continent IS NOT NULL
    GROUP BY continent, location
) AS country_level_totals
GROUP BY continent
ORDER BY total_continent_deaths DESC;

-- i. Daily new cases vs hospitalizations vs ICU patients in India
SELECT
	date,
	new_cases, 
	hosp_patients,
	icu_patients
FROM "CovidDeaths"
WHERE location LIKE '%India%';

-- j. Country wise total vaccinated people are age 65 and above
SELECT 
    location, 
    MAX(people_vaccinated::numeric) AS total_people_vaccinated,
    AVG(aged_65_older::numeric) AS pct_aged_65_older,
    ROUND(
        (MAX(people_vaccinated::numeric)*(AVG(aged_65_older::numeric)/100)), 0
    ) AS estimated_vaccinated_65_older
FROM "CovidVaccinations"
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY estimated_vaccinated_65_older DESC;

-- k. Country wise total fully vaccinated people
SELECT 
    location, 
    MAX(people_fully_vaccinated::numeric)
FROM "CovidVaccinations"
WHERE continent IS NOT NULL
GROUP BY location;

-- Reference: https://www.youtube.com/watch?v=DGQrV1v8ALU