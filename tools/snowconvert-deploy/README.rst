sc-deploy-db
===============

`sc-deploy-db` is a cross-platform command line tool for deploying scripts to Snowflake. 
For large data warehouses, it makes it easy when you have folders with a lot of source files
and you need a quick solution to deploy them to your Snowflake Warehouse.

`sc-deploy-db` will also handle dependendencies between objects. This tool uses a brute-force
approach. If an object fails due to a missing dependendency it will put on a queue and it will retried.
The tool will keep trying to deploy until it gets to a run where no more objects can be deployed.

It then makes it very handy on large warehouses because you can just point it to your code and just
let it do the deployment.

The tool will also provide useful logs that will help you to identify and track any deployment issues.
For projects using `SnowConvert`_.


Installation
------------

.. code:: bash

    $ pip install snowconvert-deploy-tool --upgrade
    
.. note:: If you run this command on MacOS change `pip` by `pip3`

You might need to install the python connector for snowflake: `pip install "snowflake-connector-python[pandas]"`



Usage
-----

For information about the different parameters or options just run it using the  `-h` option:

.. code:: bash

    $ sc-deploy-db -h

.. code:: bash

    usage: sc-deploy-db [-h] [-A ACCOUNT] [-D DATABASE] [-WH WAREHOUSE] [-R ROLE] [-U USER] [-P PASSWORD] [-W WORKSPACE] -I INPATH
                    [--activeConn ACTIVECONN] [--authenticator AUTHENTICATOR] [-L LOGPATH] [--SplitBefore SPLITBEFORE] [--SplitAfter SPLITAFTER]
                    [--ObjectType [OBJECTTYPE]]
    SnowConvertStudio Deployment Script
    ===================================
    This script helps you to deploy a collection of .sql files to a Snowflake Account.
    The tool will look for settings like:
    - Snowflake Account
    - Snowflake Warehouse
    - Snowflake Role
    - Snowflake Database
    If the tool can find a config_snowsql.ini file in the current directory or in the workspace\config_snowsql.ini location
    it will read those parameters from there.
    optional arguments:
    -h, --help            show this help message and exit
    -A ACCOUNT, --Account ACCOUNT
                          Snowflake Account
    -D DATABASE, --Database DATABASE
                          Snowflake Database
    -S SCHEMA, --Schema SCHEMA
                          Snowflake Initial Schema                          
    -WH WAREHOUSE, --Warehouse WAREHOUSE
                          Snowflake Warehouse
    -R ROLE, --Role ROLE  Snowflake Role
    -U USER, --User USER  Snowflake User
    -P PASSWORD, --Password PASSWORD
                          Password
    -W WORKSPACE, --Workspace WORKSPACE
                          Path for workspace root. Defaults to current dir
    -I INPATH, --InPath INPATH
                          Path for SQL scripts
    --activeConn ACTIVECONN
                          When given, it will be used to select connection parameters forn config_snowsql.ini or ~/.snowsql/config
    --authenticator AUTHENTICATOR
                          Use the authenticator with you want to use a different authentication mechanism
    -L LOGPATH, --LogPath LOGPATH
                          Path for process logs. Defaults to current dir
    --SplitBefore SPLITBEFORE
                          Regular expression that can be used to split code in fragments starting **BEFORE** the matching expression
    --SplitAfter SPLITAFTER
                          Regular expression that can be used to split code in fragments starting **AFTER** the matching expression
    --ObjectType [OBJECTTYPE]
                          Object Type to deploy table,view,procedure,function,macro
    --sync-folder-target SYNC_FOLDER_TARGET
                        Target folder where the lastest version of the scripts is kept
    --sync-folder-categories SYNC_FOLDER_CATEGORIES
                        It is expected that the workdir will organize code in folders like [table,view,function,macro,procedure]. This
                        parameter is a comma separated list of the categories you would like to sync                          

This tool assumes :

- that you have a collection of `.sql` files under a directory. It will then execute all those `.sql` files connecting to the specified database.
- that each file contains **only** one statement.

The tool can also read its values from environment variables. 

The following environment variables are recognized by this tool (the tool also recognizes `Snowsql Environment Variables`_):

.. list-table:: Environmental Variables
   :widths: 25 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - SNOW_USER or SNOWSQL_USER
     - The username that will be used for the connection
   * - SNOW_PASSWORD or SNOWSQL_PWD
     - The password that will be used for the connection
   * - SNOW_ROLE or SNOWSQL_ROLE
     - The snowflake role that will used for the connection
   * - SNOW_ACCOUNT or SNOWSQL_ACCOUNT
     - The snowflake accountname that will used for the connection
   * - SNOW_WAREHOUSE or SNOWSQL_WAREHOUSE
     - The warehouse to use when running the sql
   * - SNOW_DATABASE or SNOW_DATABASE
     - The database to use when running the sql

If you are a `Snowsql`_ user, this tool can use you configuration settings, using the 
`--activeConn connectionName` parameter will search for the `[connections.connectionName]`
section in your config file.


.. note::  If your files contains several statements you can use the SplitPattern argument, as explained below, so the tool will try to split the statements prior to execution.

Examples
--------

If you have a folder structure like:

::

    + code
       + procs
         proc1.sql
       + tables
         table1.sql
         + folder1
             table2.sql

You can deploy then by running:

:: 

    sc-deploy-db -A my_sf_account -WH my_wh -U user -P password -I code

If you want to use another authentication like Azure AD you can do:

::

    sc-deploy-db -A my_sf_account -WH my_wh -U user -I code --authenticator externalbrowser


A recommended approach is that you setup a bash shell script, for example `config.sh` with contents like:

::

    export SNOW_ACCOUNT="demo.us-east-1"
    export SNOW_WAREHOUSE="DEMO_WH"
    export SNOW_ROLE="DEMO_FULL_ROLE"
    export SNOW_DATABASE="DEMODB"
    echo "Reading User and Password. When you type values wont be displayed"
    read -s -p "User: "     SNOW_USER
    echo ""
    read -s -p "Password: " SNOW_PASSWORD
    echo ""
    export SNOW_USER
    export SNOW_PASSWORD

You can then run the script like: `source config.sh`. After that you can just run `sc-deploy-db -I folder-to-deploy`


Files with multiple statements
------------------------------

If your files have multiple statements, it will cause some failures are the snowflake Python API does not allow multiple statements on a single call.
In order to handle that, you give a tool a this pattern is a regular expression that can be used to split the file contents before
sending them to the database. This pattern could be used to split before the pattern: `--SplitBefore` or to split after the pattern `--SplitAfter`.

Let's see some example. 

If you have a file with contents like:

::

    CREATE OR REPLACE SEQUENCE SEQ1
    START WITH 1
    INCREMENT BY 1;

    /* <sc-table> TABLE1 </sc-table> */
    CREATE TABLE TABLE1 (
        COL1 VARCHAR
    );

You can use an argument like `--SplitAfter ';'` that will create a fragment from the file anytime a `;` is found.

If you have a file with statements like:

::
    
    CREATE TABLE OR REPLACE TABLE1 (
        COL1 VARCHAR
    );

    /* <sc-table> TABLE2 </sc-table> */
    CREATE TABLE TABLE2 (
        COL1 VARCHAR
    );

You can use an argument like `--SplitBefore 'CREATE (OR REPLACE)?'`. That will create a fragment each time a `CREATE` or `CREATE OR REPLACE` fragment is found;

Folder Syncronization
---------------------

A very common practice when using `SnowConvert`_ is to organize your files on folders per category [table,view,procedure,macro,function] 
and per schema. This makes it easier for team collaboration and progress tracking.

Another recommended practice is to have *unstabilized* code on a work directory and then run the `sc-deploy-db`, the tool
will generate execution logs with summaries of the found errors.

Data Engineers should work on removing the errors found and re-run the `sc-deploy-db`. 

At some point you might need to sync your progress on another folder. A common practice is that you will have a `Target` folder,
where you are supposed to have only the files that have been successfully deployed.

To ease that task the deploy tool provides a folder sync command.

For example to syncronize tables and views this command should be executed as: `sc-deploy-db -I WorkDir --sync-folder-target Target --sync-folder-categories "table,view"`

Reporting issues and feedback
-----------------------------

If you encounter any bugs with the tool please file an issue in the
`Issues`_ section of our GitHub repo.


License
-------

sc-deploy-db is licensed under the `MIT license`_.


.. _Issues: https://github.com/MobilizeNet/SnowConvert_Support_Library/issues
.. _MIT license: https://github.com/MobilizeNet/SnowConvert_Support_Library/tools/snowconvert-deploy/LICENSE.txt
.. _SnowConvert: https://www.mobilize.net/products/database-migrations/snowconvert
.. _Snowsql Environment Variables: https://docs.snowflake.com/en/user-guide/snowsql-start.html#connection-syntax
.. _Snowsql: https://docs.snowflake.com/en/user-guide/snowsql.html
