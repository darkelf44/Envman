@ echo off

:: Folder configuration
set __BIN_FOLDER=%~dp0
set __ENV_FOLDER=%~dp0env\

:: Check command
if /I X%1 == X goto :HelpCommand
if /I X%1 == Xh goto :HelpCommand
if /I X%1 == Xhelp goto :HelpCommand
if /I X%1 == Xt goto :ListCommand
if /I X%1 == Xlist goto :ListCommand
if /I X%1 == Xl goto :LoadCommand
if /I X%1 == Xload goto :LoadCommand
if /I X%1 == Xc goto :ClearCommand
if /I X%1 == Xclear goto :ClearCommand
if /I X%1 == Xa goto :AliasCommand
if /I X%1 == Xalias goto :AliasCommand
if /I X%1 == Xi goto :InstallCommand
if /I X%1 == Xinstall goto :InstallCommand
if /I X%1 == Xd goto :DeleteCommand
if /I X%1 == Xdelete goto :DeleteCommand

:: Default command
echo [Environment Manager] Unkown command: %1
echo Use "envman help" to see all the commands
echo.
goto :Exit

:: Display help
:HelpCommand
	echo.
	echo [Environment Manager] Help:
	echo.	h, help                        - Display this help
	echo.	t, list                        - List the available environments
	echo.	l, load ^<list of environments^> - Load the specified list of environments in that order
	echo.	c, clear                       - Load a clean environment
	echo.	a, alias ^<name^> ^<environment^>  - Create an alias for the given environment
	echo.	i, install ^<name^> ^<path^>       - Install a new enviroment with a path
	echo.	d, delete ^<environment^>        - Delete an environment
	echo.
	
	
	:HelpCommand#Done
		goto :Exit
	

:: List the environments
:ListCommand
	echo.
	echo [Environment Manager] List of environments:
	for %%I in (%__ENV_FOLDER%env-*.cmd) do call :ListCommand#Inner %%~nI
	echo.
	goto :ListCommand#Done
	
	:ListCommand#Inner
		set __ListCommand_NAME=%1
		echo.	%__ListCommand_NAME:*env-=%
		goto :Exit
	
	:ListCommand#Done
		goto :Exit

:: Load the list of environments
:LoadCommand
	set __LoadCommand#LoadSingle_SKIP=1
	for %%x in (%*) do call :LoadCommand#LoadSingle %%x
	goto :LoadCommand#Done
		
	:LoadCommand#LoadSingle
		:: Skip first N elements
		if %__LoadCommand#LoadSingle_SKIP% GTR 0 (
			set /A __LoadCommand#LoadSingle_SKIP-=1
			goto :LoadCommand#LoadSingle#Skip
		)
	
		:: Execute the script
		if not exist %__ENV_FOLDER%env-%1.cmd goto :LoadCommand#LoadSingle#NotFoundError
		call %__ENV_FOLDER%env-%1.cmd
		if errorlevel 1 goto :LoadCommand#LoadSingle#FailedError
		goto :LoadCommand#LoadSingle#Done
		
		:LoadCommand#LoadSingle#NotFoundError
			echo [Environment Manager] Load failed: %1 not found!
			echo.
			goto :EOF
			
		:LoadCommand#LoadSingle#FailedError
			echo [Environment Manager] Load failed: %1 returned %errorlevel%!
			echo.
			goto :EOF
			
		:LoadCommand#LoadSingle#Done
			echo [Environment Manager] Loaded: %1
			echo.
			goto :EOF

		:LoadCommand#LoadSingle#Skip
			goto :EOF
			
	:LoadCommand#Done
		set "__LoadCommand#LoadSingle_SKIP="
		goto :Exit
			
:: Clear the environment
:ClearCommand
	if not exist %__ENV_FOLDER%\clear.cmd goto :ClearCommand#NotExistsError
	call %__ENV_FOLDER%clear.cmd
	
	:ClearCommand#NotExistsError
		echo [Environment Manager] Clear failed! %__ENV_FOLDER%clear.cmd does not exists
		echo.
		goto :Exit
	
	:ClearCommand#Done
		echo [Environment Manager] Path cleared!
		echo.
		goto :Exit

:: Alias an existing environment
:AliasCommand
	if exist %__ENV_FOLDER%env-%2.cmd goto :AliasCommand#AlreadyExistsError
	if not exist %__ENV_FOLDER%env-%3.cmd goto :AliasCommand#NotFoundError
	echo call %%__ENV_FOLDER%%env-%3.cmd>%__ENV_FOLDER%env-%2.cmd
	goto :AliasCommand#Done

	:AliasCommand#AlreadyExistsError
		echo [Environment Manager] Alias failed: %2 already exists!
		echo.
		goto :Exit
		
	:AliasCommand#NotFoundError
		echo [Environment Manager] Alias failed: %3 not found!
		echo.
		goto :Exit
	
	:AliasCommand#Done
		echo [Environment Manager] Alias created %2 ==^> %3
		echo.
		goto :Exit
		
	
:: Install a new environment
:InstallCommand
	if exist %__ENV_FOLDER%env-%2.cmd goto :InstallCommand#AlreadyExistsError
	echo set PATH=%3;%%PATH%%>%__ENV_FOLDER%env-%2.cmd
	goto :InstallCommand#Done
	
	:InstallCommand#AlreadyExistsError
		echo [Environment Manager] Install failed: %2 already exists!
		echo.
		goto :Exit
		
	:InstallCommand#Done
		echo [Environment Manager] Installed environment: %2
		echo.
		goto :Exit

:: Delete an environment 		
:DeleteCommand
	if not exist %__ENV_FOLDER%env-%2.cmd goto :DeleteCommand#NotFoundError
	del /Q %__ENV_FOLDER%env-%2.cmd
	goto :DeleteCommand#Done
	
	:DeleteCommand#NotFoundError
		echo [Environment Manager] Delete failed: %2 not found!
		echo.
		goto :Exit
		
	:DeleteCommand#Done
		echo [Environment Manager] Deleted environment: %2
		echo.
		goto :Exit

:: Clean up environment before exit
:Exit
	set "__BIN_FOLDER="
	set "__ENV_FOLDER="

:: End of file
:EOF
