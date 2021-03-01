for /f "tokens=1 delims=" %%a in ('dir /b /s *.sql') do (
	SQLCMD -S yourdomain,port\MSSQLSERVERINSTANCE -d DBNAME -U username -P yourpassword -i "%%a"	
)

@PAUSE