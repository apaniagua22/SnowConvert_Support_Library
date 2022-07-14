-- <copyright file="MONTHS_BETWEEN_UDF.sql" company="Mobilize.Net">
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

-- =============================================
-- DESCRIPTION: UDF THAT REPRODUCES MONTHS_BETWEEN FUNCTIONALITY
-- PARAMETERS: MONTHS_BETWEEN
-- FIRST_DATE: TIMESTAMP_LTZ
-- SECOND_DATE: TIMESTAMP_LTZ
-- RETURNS: NUMBER OF MONTHS BETWEEN FIRST_DATE AND SECOND_DATE
-- EXAMPLE:
--  SELECT MONTHS_BETWEEN_UDF('2022-02-14', '2021-02-14'); -- SELECT MONTHS_BETWEEN(TO_DATE('2022-02-14','YYYY-MM-DD'), TO_DATE('2021-02-14','YYYY-MM-DD')) FROM DUAL;
--  RETURNS 12
-- =============================================
CREATE OR REPLACE FUNCTION MONTHS_BETWEEN_UDF(FIRST_DATE TIMESTAMP_LTZ, SECOND_DATE TIMESTAMP_LTZ)
RETURNS NUMBER
IMMUTABLE
AS
$$
ROUND(MONTHS_BETWEEN(FIRST_DATE, SECOND_DATE))
$$
;