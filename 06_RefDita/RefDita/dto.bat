@echo off
for /f %%f in ('dir /b src\*_*_*') do (
   call regex "_([^_]*)_" %%f 
   echo(
)
