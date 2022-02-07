-- <copyright file="INSTR_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S INSTR FUNCTIONALITY
-- PARAMETERS:
-- SOURCE_STRING: STRING - STRING WHERE THE SEARCH WILL BE CONDUCTED
-- SEARCH_STRING: STRING - STRING THAT THE FUNCTION SEARCHES FOR
-- POSITION (Optional): DOUBLE - CHARACTER INDEX WHERE THE SEARCH WILL START (STARTING AT 1)
-- OCCURRENCE (Optional): DOUBLE - OCCURRENCE OF SEARCH_STRING TO FIND
-- RETURNS: POSITION IN THE SOURCE STRING WHERE THE OCURRENCE IS FOUND (STARTING AT 1)
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING) 
RETURNS INT
IMMUTABLE
AS
$$
    POSITION(SEARCH_STRING, SOURCE_STRING)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING, POSITION INT) 
RETURNS INT
IMMUTABLE
AS
$$
    CASE WHEN POSITION >= 0 THEN POSITION(SEARCH_STRING, SOURCE_STRING, POSITION) ELSE 1 + LENGTH(SOURCE_STRING) - POSITION(SEARCH_STRING, REVERSE(SOURCE_STRING), ABS(POSITION)) END
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING, POSITION DOUBLE, OCCURRENCE DOUBLE)
RETURNS DOUBLE
LANGUAGE JAVASCRIPT
IMMUTABLE
AS
'
function INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION, N)
{
  var I = SOURCE_STRING.indexOf(SEARCH_STRING, POSITION);
  return(N == 1 ? I : INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, I + 1, N - 1));
}

function LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION, N)
{
  var I = SOURCE_STRING.lastIndexOf(SEARCH_STRING, POSITION);
  return(N == 1 ? I : LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, I - 1, N - 1));
}

function INSTR(SOURCE_STRING, SEARCH_STRING, POSITION, OCCURRENCE)
{
  if(OCCURRENCE < 1) return - 1;
  if(POSITION == 0) POSITION = 1;
  if(POSITION > 0) {
    var INDEX = INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION - 1, OCCURRENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
  else {
    var INDEX = LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, SOURCE_STRING.length + POSITION, OCCURRENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
}

return INSTR(SOURCE_STRING, SEARCH_STRING, POSITION, OCCURRENCE);
';