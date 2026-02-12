@echo off
REM ==============================================================================
REM eSubmission Benchmark - Run Validation
REM ==============================================================================

echo ================================================================================
echo   eSubmission Benchmark - Consistency Validation
echo ================================================================================
echo.

REM Check if R is available
where Rscript >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: R is not installed or not in PATH
    echo Please install R from https://cran.r-project.org/
    pause
    exit /b 1
)

REM Navigate to validation directory
cd /d "%~dp0"

echo Running validation script...
echo.

REM Run the validation
Rscript run_full_validation.R

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Validation script failed
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo   Validation Complete
echo ================================================================================
echo.
echo Results saved to: validation_results.csv
echo.
pause
