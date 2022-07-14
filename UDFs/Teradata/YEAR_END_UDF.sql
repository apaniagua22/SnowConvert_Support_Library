-- <copyright file="YEAR_END_UDF.sql" company="Mobilize.Net">
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
-- RETURNS: THE LAST DAY OF DECEMBER WITH ISO YEAR, USED TO CALCULATE THE RESULT OF PUBLIC.YEAR_END_ISO_UDF
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET DECEMBER LAST DAY USING  ISO YEAR
-- EXAMPLE:
--  SELECT PUBLIC.LAST_DAY_DECEMBER_OF_ISO(DATE '2022-01-01');
-- RETURNS 2021-12-31
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.LAST_DAY_DECEMBER_OF_ISO(INPUT TIMESTAMP_TZ)
RETURNS DATE 
IMMUTABLE 
AS
$$
    date_from_parts(YEAROFWEEKISO(INPUT),12,31)
$$;

-- ======================================================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S TD_YEAR_END(Date,'ISO') FUNCTIONALITY
-- DEPENDING OF DAYOFWEEKISO OF PUBLIC.LAST_DAY_DECEMBER_OF_ISO ADD OR SUBSTRACT DAYS
-- TO FIND THE SUNDAY CLOSER TO PUBLIC.LAST_DAY_DECEMBER_OF_ISO WHICH WOULD BE THE 
-- LAST DAY OF YEAR USING ISO CALENDAR
-- PARAMETERS: INPUT: DATE TO GET THE THE LAST DAY OF YEAR USING ISO CALENDAR
-- RETURNS: THE LAST DAY OF YEAR USING ISO CALENDAR
--
-- EXAMPLE:
--  SELECT  PUBLIC.YEAR_END_ISO_UDF(DATE '2022-01-01'),
--  PUBLIC.YEAR_END_ISO_UDF(DATE '2022-04-12');
-- RETURNS 2022-01-02, 2023-01-01
--
-- EQUIVALENT: TERADATA'S TD_YEAR_END(Date,'ISO') FUNCTIONALITY
-- EXAMPLE:
--  SELECT TD_YEAR_END(DATE '2022-01-01', 'ISO'),
--  TD_YEAR_END(DATE '2022-04-12', 'ISO');
-- RETURNS 2022-01-02, 2023-01-01
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.YEAR_END_ISO_UDF(INPUT date)
RETURNS DATE 
IMMUTABLE 
AS
$$
     CASE 
     WHEN DAYOFWEEKISO(LAST_DAY_DECEMBER_OF_ISO(INPUT))<=3 THEN DATEADD(day,-DAYOFWEEKISO(LAST_DAY_DECEMBER_OF_ISO(INPUT)),LAST_DAY_DECEMBER_OF_ISO(INPUT))
     WHEN DAYOFWEEKISO(LAST_DAY_DECEMBER_OF_ISO(INPUT))<=6 THEN DATEADD(day,7-DAYOFWEEKISO(LAST_DAY_DECEMBER_OF_ISO(INPUT)),LAST_DAY_DECEMBER_OF_ISO(INPUT))
     ELSE LAST_DAY_DECEMBER_OF_ISO(INPUT)
     END
$$;

-- ======================================================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S TD_YEAR_END(DATE) OR TD_YEAR_END(DATE, 'COMPATIBLE') FUNCTIONALITY
-- RETURNS: THE LAST DAY OF THE YEAR
-- PARAMETERS:
--      INPUT: DATE TO GET THE LAST DAY OF YEAR
--
-- EXAMPLE:
--  SELECT  PUBLIC.YEAR_END_UDF(DATE '2022-01-01'),
--  PUBLIC.YEAR_END_UDF(DATE '2022-04-12');
-- RETURNS 2022-12-31, 2022-12-31
--
-- EQUIVALENT: TERADATA'S TD_YEAR_END FUNCTIONALITY
-- EXAMPLE:
--  SELECT TD_YEAR_END(DATE '2022-01-01', 'COMPATIBLE'),
--  TD_YEAR_END(DATE '2022-04-12');
-- RETURNS 2022-12-31, 2022-12-31
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.YEAR_END_UDF(INPUT date)
RETURNS DATE 
IMMUTABLE 
AS
$$
     LAST_DAY(INPUT,'year')
$$;
