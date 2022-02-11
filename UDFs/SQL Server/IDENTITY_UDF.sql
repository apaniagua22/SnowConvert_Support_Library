﻿-- <copyright file="IDENTITY_UDF.cs" company="Mobilize.Net">
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
-- Description: The Identity() function Determines whether an expression is a valid numeric type. 
-- ISNUMERIC returns 1 when the input expression evaluates to a valid numeric data type; otherwise it returns 0.
-- =========================================================================================================

create or replace function IDENTITY_UDF()
returns INTEGER
language sql
as
$$
  SnowConvert_Temp_Seq.nextval
$$