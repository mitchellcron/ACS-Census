/*
I began this query intending to use PowerBI for visuals, but for public access I switched to Tableau.
"census" is the database I made and then uploaded all excel tables to.
*/

USE census
GO

SELECT *
FROM education_age;
GO

SELECT *
FROM education_race;
GO

SELECT *
FROM poverty;
GO

SELECT *
FROM major_by_age;
GO

SELECT *
FROM major_over25;
GO

--Created a View of general poverty data
--This was before I decided not to bother with views, as they won't work with Tableau
CREATE VIEW [PercentPovertyAge] as
SELECT state, Total_Population, Under_18, Ages_18_to_64, Ages_65_and_over
FROM poverty;
GO

SELECT *
FROM PercentPovertyAge;
GO

SELECT *
FROM ab_education_age;
GO

/*SELECT
	pov.State, pov.Total_Population, pov.Under_18, pov.Ages_18_to_64, pov.Ages_65_and_over,
	edu.B_L9, edu.B_B912, edu.B_HSE, edu.B_SCN, edu.B_AD, edu.B_BD, edu.B_GP, edu.B_TH, edu.B_TB
FROM census..poverty pov
JOIN census..ab_education_age edu
ON pov.State = edu.State
go
*/


--Comparison of State Poverty Levels and distribution of education type for those 25 years old and older
SELECT
	pov.State, pov.Total_Population as PercentPopulationInPoverty,
	edu.B_L9 as LessThan9th, edu.B_B912 as Between9thAnd12th, edu.B_HSE as HighSchoolOrEquivalent, edu.B_SCN as SomeCollegeNoDegree, edu.B_AD as AssociatesDegree, edu.B_BD as BachelorsDegree, edu.B_GP as GraduateProfessional, edu.B_TH as TotalHighSchoolHigher, edu.B_TB as TotalBachelorsHigher
FROM census..poverty pov
JOIN census..ab_education_age edu
ON pov.State = edu.State
GO

--Comparison of the share that "Science and Engineering" majors have amongst different age cohorts
SELECT state, SE_25_to_39 Ages25to39, SE_40_to_64 Ages40to64, SE_65_and_over as Over65
FROM major_by_age;
GO

--Comparison of the share that "Science and Engineering Related Fields" majors have amongst different age cohorts
SELECT state, SERF_25_to_39 Ages25to39, SERF_40_to_64 Ages40to64, SERF_65_and_over as Over65
FROM major_by_age;
GO

--Comparison of the share that "Business" majors have amongst different age cohorts
SELECT state, B_25_to_39 Ages25to39, B_40_to_64 Ages40to64, B_65_and_over as Over65
FROM major_by_age;
GO

--Comparison of the share that "Education" majors have amongst different age cohorts
SELECT state, E_25_to_39 Ages25to39, E_40_to_64 Ages40to64, E_65_and_over as Over65
FROM major_by_age;
GO

--Comparison of the share that "Arts, Humanities and Others" majors have amongst different age cohorts
SELECT state, AH_25_to_39 Ages25to39, AH_40_to_64 Ages40to64, AH_65_and_over as Over65
FROM major_by_age;
GO

--Comparison of Overall Households Income Data
SELECT *
FROM households;
GO

--Comparison of Family Households Income Data
SELECT *
FROM families;
GO


--Comparison of Married-Couple Family Households Income Data
SELECT *
FROM married_couple_families;
GO


--Comparison of Non-Family Households Income Data
SELECT *
FROM nonfamily_households;
GO

--Comparison of Incomes, Overall % in Poverty, and Education

SELECT
	house.State, house.Median_income_dollars as MedianIncome, house.Mean_income_dollars as MeanIncome,
	pov.Total_Population as PercentPopPoverty,
	edu.B_TH as HighSchoolOrHigher, edu.B_TB as BachelorsOrHigher
FROM census..households house
JOIN census..poverty pov
ON house.State = pov.State
JOIN census..ab_education_age edu
ON house.State = edu.State;
GO

--Determine Highest Median Income by State

SELECT state, cast(replace(Median_income_dollars,',','') as int) as MedianIncome
FROM households
ORDER BY MedianIncome DESC;
GO

--Determine Highest Mean Income By State

SELECT state, cast(replace(Mean_income_dollars,',','') as int) as MeanIncome
FROM households
ORDER BY MeanIncome DESC;
GO

--Comparison of percentages with high school graduate or higher
SELECT state,
	White_alone_not_Hispanic_or_Latino_High_school_graduate_or_highe as White,
	Black_alone_High_school_graduate_or_higher as Black,
	American_Indian_or_Alaska_Native_alone_High_school_graduate_or_h as AmericanIndianAlaskaNative,
	Asian_alone_High_school_graduate_or_higher as Asian,
	Native_Hawaiian_and_Other_Pacific_Islander_alone_High_school_gra as NativeHawaiianPacificIslander,
	Some_other_race_alone_High_school_graduate_or_higher as Other,
	Two_or_more_races_High_school_graduate_or_higher as TwoRacesOrMore,
	Hispanic_or_Latino_Origin_High_school_graduate_or_higher as HispanicOrLatino
FROM education_race;
GO

--Same comparison but for states with actual Native Hawaiian Or Other Pacific Islander Data
SELECT state,
	White_alone_not_Hispanic_or_Latino_High_school_graduate_or_highe as White,
	Black_alone_High_school_graduate_or_higher as Black,
	American_Indian_or_Alaska_Native_alone_High_school_graduate_or_h as AmericanIndianAlaskaNative,
	Asian_alone_High_school_graduate_or_higher as Asian,
	Native_Hawaiian_and_Other_Pacific_Islander_alone_High_school_gra as NativeHawaiianPacificIslander,
	Some_other_race_alone_High_school_graduate_or_higher as Other,
	Two_or_more_races_High_school_graduate_or_higher as TwoRacesOrMore,
	Hispanic_or_Latino_Origin_High_school_graduate_or_higher as HispanicOrLatino
FROM education_race
WHERE Native_Hawaiian_and_Other_Pacific_Islander_alone_High_school_gra <> 'N';
GO

--Comparison of percentages with bachelor's degree or higher
SELECT state,
	[White_alone,_not_Hispanic_or_Latino_Bachelors_degree_or_higher] as White,
	Black_alone_Bachelors_degree_or_higher as Black,
	American_Indian_or_Alaska_Native_alone_Bachelors_degree_or_highe as AmericanIndianAlaskaNative,
	Asian_alone_Bachelors_degree_or_higher as Asian,
	Native_Hawaiian_and_Other_Pacific_Islander_alone_Bachelors_degre as NativeHawaiianPacificIslander,
	Some_other_race_alone_Bachelors_degree_or_higher as Other,
	Two_or_more_races_Bachelors_degree_or_higher as TwoRacesOrMore,
	Hispanic_or_Latino_Origin_Bachelors_degree_or_higher as HispanicOrLatino
FROM education_race;