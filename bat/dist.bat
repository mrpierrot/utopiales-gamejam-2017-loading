
call adt -package 
    -storetype pkcs12 
    -keystore loading-air.p12
    -target native 
    ..\air\loading.exe 
    ..\application.xml 
    ..\bin