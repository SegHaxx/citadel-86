@echo off
:loop
CTDL %1
shift
if ERRORLEVEL 0 goto alldone
if ERRORLEVEL 1 goto lockfile
if ERRORLEVEL 2 FIXIT
if ERRORLEVEL 3 goto remote
if ERRORLEVEL 4 goto timeout
if ERRORLEVEL 5 goto door

:door
C86DOOR
goto loop

:remote
REM put here what you want remote terminations to cause to happen.
REM If you want to rerun CTDL, you'd have 'goto loop'.

:timeout
REM put here what you want timeouts to do (backups or whatever)
REM we assume you'd want to restart Citadel-86 afterwards.
goto loop

:lockfile
REM put here you tried to bring Citadel-86 when it already seems to be up.

:alldone
REM And now the sysop at the console took us down, so we'll die.
