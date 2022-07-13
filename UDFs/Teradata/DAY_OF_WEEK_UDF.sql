-- <copyright file="DAY_OF_WEEK_UDF.sql" company="Mobilize.Net">
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
-- RETURNS THE DAY OF THE WEEK A TIMESTAMP BELONGS TO, HAS THE SAME BEHAVIOR AS THE TD_DAY_OF WEEK FUNCTION FROM TERADATA
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET THE DAY OF WEEK FROM
-- RETURNS:
--      AN INTEGER BETWEEN 1 AND 7 WHERE 1 = SUNDAY, 2 = MONDAY, ..., 7 = SATURDAY
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.TD_DAY_OF_WEEK_UDF(INPUT TIMESTAMP_TZ)
RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS
$$
    IFF(DAYOFWEEKISO(INPUT) = 7, 1, DAYOFWEEKISO(INPUT) + 1)
$$;

-- ======================================================================
-- RETURNS THE DAY OF THE WEEK A TIMESTAMP BELONGS TO, 
-- HAS THE SAME BEHAVIOR AS THE DAYNUMBER_OF_WEEK(DATE, 'COMPATIBLE') FUNCTION
-- WITH COMPATIBLE CALENDAR FROM TERADATA,FIRST DAY OF THE WEEK WILL BE THE SAME
-- DAY AS THE DAY OF THE FIRST OF JANUARY
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET THE DAY OF WEEK FROM
-- RETURNS:
--      AN INTEGER BETWEEN 1 AND 7 WHERE  IF JANUARY FIRST IS WEDNESDAY
--      1 = WEDNESDAY, 2 = THURSDAY, ..., 7 = TUESDAY
--
-- EXAMPLE:
--  SELECT PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(DATE '2022-01-01'),
--  PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(DATE '2023-05-05');
-- RETURNS 1, 6
--
-- EQUIVALENT: TERADATA'S DAYNUMBER_OF_WEEK FUNCTIONALITY
-- EXAMPLE:
--  SELECT DAYNUMBER_OF_WEEK (DATE '2022-01-01', 'COMPATIBLE'),
--  DAYNUMBER_OF_WEEK (DATE '2023-05-05', 'COMPATIBLE');
-- RETURNS 1, 6
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(INPUT TIMESTAMP_TZ)
RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS
$$
  IFF(DAYOFWEEKISO(INPUT)=DAYOFWEEKISO(date_from_parts(year(INPUT),1,1)),1,DAYOFWEEKISO(DATEADD(DAY,-DAYOFWEEKISO(date_from_parts(year(INPUT)-1,12,31)),INPUT)))

$$;
