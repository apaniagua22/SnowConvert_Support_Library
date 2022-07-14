-- <copyright file="YEAR_BEGIN_UDF.sql" company="Mobilize.Net">
--        Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
-- 
--        This file is part of the Mobilize Frameworks, which is
--        proprietary and confidential.
-- 
--        NOTICE:  All information contained herein is, and remains
--        the property of Mobilize.Net Corporation.
--        The intellectual and technical concepts contained herein are
--        proprietary to Mobilize.Net Corporation and may be covered
--        by U.S. Patents, and are protected by trade secret or copyright law.
--        Dissemination of this information or reproduction of this material
--        is strictly forbidden unless prior written permission is obtained
--        from Mobilize.Net Corporation.
-- </copyright>

-- ======================================================================
-- RETURNS: THE FIRST DAY OF JANUARY WITH ISO YEAR, USED TO CALCULATE THE RESULT OF PUBLIC.YEAR_BEGIN_ISO_UDF
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET JANUARY FIRST USING  ISO YEAR
-- EXAMPLE:
--  SELECT PUBLIC.FIRST_DAY_JANUARY_OF_ISO(DATE '2022-01-01');
-- RETURNS 2021-01-01
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.FIRST_DAY_JANUARY_OF_ISO(INPUT TIMESTAMP_TZ)
RETURNS DATE 
IMMUTABLE 
AS
$$
    date_from_parts(YEAROFWEEKISO(INPUT),01,01)
$$;

-- ======================================================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S TD_YEAR_BEGIN(Date,'ISO') FUNCTIONALITY
-- DEPENDING OF DAYOFWEEKISO OF PUBLIC.FIRST_DAY_JANUARY_OF_ISO ADD OR SUBSTRACT DAYS
-- TO FIND THE MONDAY CLOSER TO PUBLIC.FIRST_DAY_JANUARY_OF_ISO WHICH WOULD BE THE 
-- FIRST DAY OF YEAR USING ISO CALENDAR
-- PARAMETERS: INPUT: DATE TO GET THE THE FIRST DAY OF YEAR USING ISO CALENDAR
-- RETURNS: THE FIRST DAY OF YEAR USING ISO CALENDAR
--
-- EXAMPLE:
--  SELECT  PUBLIC.YEAR_BEGIN_ISO_UDF(DATE '2022-01-01'),
--  PUBLIC.YEAR_BEGIN_ISO_UDF(DATE '2022-04-12');
-- RETURNS 2021-01-04, 2022-01-03
--
-- EQUIVALENT: TERADATA'S TD_YEAR_BEGIN(Date,'ISO') FUNCTIONALITY
-- EXAMPLE:
--  SELECT TD_YEAR_BEGIN(DATE '2022-01-01', 'ISO'),
--  TD_YEAR_BEGIN(DATE '2022-04-12', 'ISO');
-- RETURNS 2021-01-04, 2022-01-03
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.YEAR_BEGIN_ISO_UDF(INPUT DATE)
RETURNS DATE 
IMMUTABLE 
AS
$$
     CASE 
     WHEN DAYOFWEEKISO(FIRST_DAY_JANUARY_OF_ISO(INPUT))>=5 THEN DATEADD(day,8-DAYOFWEEKISO(FIRST_DAY_JANUARY_OF_ISO(INPUT)),FIRST_DAY_JANUARY_OF_ISO(INPUT))
     WHEN DAYOFWEEKISO(FIRST_DAY_JANUARY_OF_ISO(INPUT))>=2 THEN DATEADD(day,1-DAYOFWEEKISO(FIRST_DAY_JANUARY_OF_ISO(INPUT)),FIRST_DAY_JANUARY_OF_ISO(INPUT))
     ELSE FIRST_JUANARY_OF_ISO(INPUT)
     end
$$;


-- ======================================================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S TD_YEAR_BEGIN(DATE) OR TD_YEAR_BEGIN(DATE, 'COMPATIBLE') FUNCTIONALITY
-- RETURNS: THE FIRST DAY OF THE YEAR
-- PARAMETERS:
--      INPUT: DATE TO GET THE FIRST DAY OF YEAR
--
-- EXAMPLE:
--  SELECT  PUBLIC.YEAR_BEGIN_UDF(DATE '2022-01-01'),
--  PUBLIC.YEAR_BEGIN_UDF(DATE '2022-04-12');
-- RETURNS 2022-01-01, 2022-01-01
--
-- EQUIVALENT: TERADATA'S TD_YEAR_BEGIN FUNCTIONALITY
-- EXAMPLE:
--  SELECT TD_YEAR_BEGIN(DATE '2022-01-01', 'COMPATIBLE'),
--  TD_YEAR_BEGIN(DATE '2022-04-12');
-- RETURNS 2022-01-01, 2022-01-01
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.YEAR_BEGIN_UDF(INPUT date)
RETURNS DATE 
IMMUTABLE 
AS
$$
     date_from_parts(year(INPUT),01,01)
$$;