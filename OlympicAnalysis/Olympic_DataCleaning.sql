

-- Table of data we will use to visualize Summer Olympics data.
-- The main task is to visualize (dashboard) historical performance for different countries in summer games, 
-- with the possibility to select your own country (slicer)

SELECT 
	[ID],
	[Name] as 'Competitor Name',  -- Renamed Column
	CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END as Sex,		    -- Seperating M/F
	[Age],
	CASE WHEN [AGE] < 18 THEN 'Under 18'								-- Creating labels/ buckets for consumers
		WHEN [AGE] BETWEEN 18 AND 25 THEN '18-25'
		WHEN [AGE] BETWEEN 25 AND 30 THEN '25-30'
		WHEN [AGE] > 30  THEN 'Over 30'
	END AS [Age Grouping],
	[Height],
	[Weight],
	[NOC] as 'Nation Code',										        -- Explained abbreviation
--	CHARINDEX(' ', Games)-1 AS '4 flag',						        -- Returns 4, i.e. returns 5-1=4
--	CHARINDEX(' ', REVERSE(Games))-1 as '6 flag',						-- Returns 6, 
	LEFT(Games, CHARINDEX(' ', Games) -1) as 'Year',					 -- Split column to isolate year
--	RIGHT(Games, CHARINDEX(' ', REVERSE(Games)) -1) as 'Season', 
	RIGHT(Games, CHARINDEX(' ', (Games)) + 1) as 'Season',				 -- Split column to isolate Season
--	[Games],
	[Sport],
	[Event],
	CASE WHEN Medal = 'NA' THEN 'Not Registered' ELSE Medal END AS Medal -- Replaced NA with Not Registered
FROM [olympic_games].[dbo].[athletes_event_results]
WHERE RIGHT(Games, CHARINDEX(' ', REVERSE(Games))-1) = 'Summer';         -- Filtering to Summer Games for buisness problem.

