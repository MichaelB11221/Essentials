rem # Disable Driver Signature Enforcement

bcdedit.exe -set loadoptions ENABLE_INTEGRITY_CHECKS
bcdedit.exe -set TESTSIGNING OFF
bcdedit.exe -set nointegritychecks off

PAUSE