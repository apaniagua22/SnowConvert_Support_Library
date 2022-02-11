﻿-- <copyright file="DATEDIFF_UDF.sql" company="Mobilize.Net">
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

-- =========================================================================================================
-- Description: The DATEDIFF_UDF() is used as a template for all the cases when there is a substraction
-- between a date type and an unknown type.
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM DATE)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	FIRST_PARAM - SECOND_PARAM
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM TIMESTAMP)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	FIRST_PARAM - SECOND_PARAM::DATE
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM INTEGER)
RETURNS DATE
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEADD(day,SECOND_PARAM*-1 ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM TIMESTAMP)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEDIFF(day,SECOND_PARAM ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM DATE)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEDIFF(day,SECOND_PARAM ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM NUMBER)
RETURNS TIMESTAMP
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEADD(day,SECOND_PARAM*-1,FIRST_PARAM)
$$;