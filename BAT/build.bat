@echo on    
mode 100,30
color 0A

REM ************************************************************************************************************************************************************************ 
    
    REM *********************
    REM Variablen definieren
    REM *********************
    
    set /p version=<Version.txt
        
        :WORKDIR_SET 
            color 0C
            cls
        echo Fortschritt: [#.                ] 0 / 8
            echo.   
            echo (0) Default (nur Versionsnummer)
            echo (1) Custom (Eingabe + Versionsnummer)
            echo.             
            set /p i="Welcher Buildresult Ordner soll verwendet werden? "
                if %i%==0 goto WORKDIR_DEFAULT            
                if %i%==1 goto WORKDIR_CUSTOM  
            echo Falsche Eingabe
            pause
            goto WORKDIR_SET
            
        :WORKDIR_DEFAULT
            set workdir=%version%
            goto WORKDIR_END    
  
        :WORKDIR_CUSTOM
            set /p userinput="Bitte eigenen Namen (ohne Leerzeichen) eingeben: "            
            set workdir=%userinput%-%version%
            goto WORKDIR_END
            
        :WORKDIR_END
            color 0A        
            
REM ************************************************************************************************************************************************************************             
    
    REM *********************    
    REM Verzeichnise erstellen
    REM *********************
    
        cls
        echo Fortschritt: [###.              ] 1 / 8
        echo.             
        echo Verzeichnise werden erstellt...
        echo.
            @ping -n 1 localhost> nul              
                rmdir Buildresult\%workdir% /S /Q
                mkdir Buildresult\%workdir%\Dockerfiles\
                echo Version %version% > Buildresult\%workdir%\Dockerfiles\build.txt
                echo %date% >> Buildresult\%workdir%\Dockerfiles\build.txt
            @ping -n 3 localhost> nul   
            
REM ************************************************************************************************************************************************************************             
    
    REM *********************    
    REM Dockerfiles kopieren
    REM *********************
    
        cls
        echo Fortschritt: [#####.            ] 2 / 9
        echo.             
        echo Dockerfiles werden kopiert...
        echo.  
            @ping -n 1 localhost> nul              
                xcopy Data\DockerfilesRepo\*.* Buildresult\%workdir%\Dockerfiles\ /E /I /H
            @ping -n 3 localhost> nul
            
REM ************************************************************************************************************************************************************************             
            
    REM *********************    
    REM Tileserverfiles kopieren
    REM *********************      
    
        cls
        echo Fortschritt: [#######.          ] 3 / 9
        echo.             
        echo Optionale Tileserverfiles werden kopiert...
        echo.     
            @ping -n 1 localhost> nul              
                xcopy Data\OptionalTileserverSettings\*.* Buildresult\%workdir%\Dockerfiles\Tileserver\tileserver-init.d /E /I /H
            @ping -n 3 localhost> nul
            
REM ************************************************************************************************************************************************************************             
            
    REM *********************    
    REM PBF kopieren
    REM *********************   
    
        :PBF_AUSWAHL 
            color 0C
            cls
            echo Fortschritt: [#########.        ] 4 / 9
            echo.   
            echo (0) Default (muss im PBF Root liegen)
            echo (1) OSM DACHL
            echo (2) OSM EUROPA
            echo (3) HERE UK    
            echo (4) HERE DACHL            
            echo.             
            set /p i="Welche PBF soll verwendet werden? "
                if %i%==0 goto PBF_DEFAULT            
                if %i%==1 goto OSM_DACHL
                if %i%==2 goto OSM_EUROPE
                if %i%==3 goto HERE_UK
                if %i%==4 goto HERE_DACHL                
            echo Falsche Eingabe
            pause
            goto PBF_AUSWAHL  
                
        :PBF_DEFAULT
            echo.  
            color 0A        
                @ping -n 1 localhost> nul              
                    xcopy Data\PBF\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /I /H
                    xcopy Data\PBF\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /I /H  
                    xcopy Data\PBF\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /I /H
            goto PBF_END                
                
        :OSM_DACHL
            echo. 
            color 0A
                @ping -n 1 localhost> nul              
                    xcopy Data\PBF\OSM\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /I /H
                    xcopy Data\PBF\OSM\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /I /H  
                    xcopy Data\PBF\OSM\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /I /H         
                @ping -n 3 localhost> nul
            goto PBF_END
            
        :OSM_EUROPE
            echo. 
            color 0A
                @ping -n 1 localhost> nul              
                    xcopy Data\PBF\OSM\EUROPE\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /I /H
                    xcopy Data\PBF\OSM\EUROPE\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /I /H  
                    xcopy Data\PBF\OSM\EUROPE\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /I /H         
                @ping -n 3 localhost> nul
            goto PBF_END            
            
        :HERE_UK
            echo. 
            color 0A
                @ping -n 1 localhost> nul              
                    xcopy Data\PBF\HERE\UK\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /I /H
                    xcopy Data\PBF\HERE\UK\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /I /H  
                    xcopy Data\PBF\HERE\UK\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /I /H         
                @ping -n 3 localhost> nul
            goto PBF_END
            
        :HERE_DACHL
            echo. 
            color 0A
                @ping -n 1 localhost> nul              
                    xcopy Data\PBF\HERE\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /I /H
                    xcopy Data\PBF\HERE\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /I /H  
                    xcopy Data\PBF\HERE\DACHL\*.pbf Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /I /H         
                @ping -n 3 localhost> nul
            goto PBF_END              
            
        :PBF_END
            @ping -n 3 localhost> nul  
        
REM ************************************************************************************************************************************************************************         
        
    REM *********************    
    REM Style kopieren
    REM *********************  
    
        :STYLE_AUSWAHL 
            color 0C
            cls
            echo Fortschritt: [###########.      ] 5 / 9
            echo.
            echo (1) DE Truck
            echo (2) DE
            echo (3) UK Truck
            echo (4) UK            
            echo.             
            set /p i="Welcher Style soll verwendet werden? "
                if %i%==1 goto STYLE_DE_TRUCK           
                if %i%==2 goto STYLE_DE
                if %i%==3 goto STYLE_UK_TRUCK
                if %i%==4 goto STYLE_UK                  
            echo Falsche Eingabe
            pause
            goto STYLE:AUSWAHL
            
        :STYLE_DE_TRUCK
            echo.
            color 0A
                xcopy Data\StyleFiles\de_truck\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\ /E /I /H /Y
            goto STYLE_END            
            
        :STYLE_DE
            echo.
            color 0A
                xcopy Data\StyleFiles\de\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\ /E /I /H /Y
            goto STYLE_END
            
        :STYLE_UK_TRUCK
            echo.
            color 0A
                xcopy Data\StyleFiles\uk_truck\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\ /E /I /H /Y
            goto STYLE_END              
                
        :STYLE_UK
            echo.
            color 0A
                xcopy Data\StyleFiles\uk\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\ /E /I /H /Y
            goto STYLE_END   
                
        :STYLE_END
            @ping -n 3 localhost> nul
            
REM ************************************************************************************************************************************************************************             

    REM *********************    
    REM Routingserver kopieren
    REM *********************
    
        cls
        echo Fortschritt: [#############.    ] 6 / 9
        echo.             
        echo RoutingServer wird kopiert...
        echo.  
            @ping -n 1 localhost> nul              
                xcopy Data\RoutingServerFiles\*.* Buildresult\%workdir%\Dockerfiles\Routing\RoutingServer /E /I /H
            @ping -n 3 localhost> nul  
            
REM ************************************************************************************************************************************************************************             
            
    REM *********************    
    REM Graphhopper kopieren
    REM *********************  
    
        cls
        echo Fortschritt: [###############.  ] 7 / 9
        echo.             
        echo GraphHopper wird kopiert...
        echo.  
            @ping -n 1 localhost> nul              
                xcopy Data\GraphHopperFiles\*.* Buildresult\%workdir%\Dockerfiles\Routing\Graphhopper /E /I /H
            @ping -n 3 localhost> nul   
            
REM ************************************************************************************************************************************************************************             
            
    REM *********************    
    REM Postgres Config kopieren
    REM ********************* 
    
        cls
        echo Fortschritt: [#################.] 8 / 9
        echo.             
        echo Postgres Config wird kopiert...
        echo.  
            @ping -n 1 localhost> nul              
                xcopy Data\PostgresConfig\Tileserver\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import /E /I /H
                xcopy Data\PostgresConfig\Nominatim\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\nominatim\Import /E /I /H    
                xcopy Data\PostgresConfig\Routingserver\*.* Buildresult\%workdir%\Dockerfiles\Compose\mounts\routingserver\Import /E /I /H          
            @ping -n 3 localhost> nul   

REM ************************************************************************************************************************************************************************ 
                
    REM *********************    
    REM Tirex Batch erstellen
    REM *********************   
    
        :TIREX_AUSWAHL
            color 0C
            cls
            echo Fortschritt: [##################] 9 / 9
            echo. 
            set /p i="Soll eine Tirex Batch Datei erstellt werden? (J / N): "
                if %i%==J goto TIREX_ERSTELLEN   
                if %i%==j goto TIREX_ERSTELLEN               
                if %i%==N goto TIREX_END
                if %i%==n goto TIREX_END            
            echo Falsche Eingabe
            pause
            goto TIREX_AUSWAHL
            
        :TIREX_ERSTELLEN
            color 0C
            cls
            echo Fortschritt: [##################] 9 / 9
            echo. 
            echo (0) Manuelle Auswahl
            echo (1) DACHL (Zoom 0-18)
            echo.             
            set /p i="Boundingbox auswaehlen : "
                if %i%==0 goto TIREX_NEU
                if %i%==1 goto TIREX_DACHL
            echo Falsche Eingabe
            pause
            goto TIREX_ERSTELLEM  
            
        :TIREX_DACHL
            echo map=osm bbox=5,45,25,60 z=0-18 > Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\tirex.batch
            goto TIREX_MEHR_AUSWAHL
            
        :TIREX_NEU
            echo.
            color 0A
            set /p bbox="Bbox Daten eingeben (z.B.: 8,10,9,49): "
            set /p zoom="Zoomstufen eingeben (z.B.: 15-17): "
            echo map=osm bbox=%bbox% z=%zoom% > Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\tirex.batch
            goto TIREX_MEHR_AUSWAHL            
            
        :TIREX_MEHR_AUSWAHL
            cls
            echo Fortschritt: [##################] 9 / 9
            echo.         
            set /p i="Soll ein weiterer Eintrag erstellt werden? (J / N): "
                if %i%==J goto TIREX_MEHR 
                if %i%==j goto TIREX_MEHR             
                if %i%==N goto TIREX_END
                if %i%==n goto TIREX_END            
            echo Falsche Eingabe
            pause
            goto TIREX_MEHR_AUSWAHL 
            
        :TIREX_MEHR
            echo Fortschritt: [##################] 9 / 9
            echo.         
            set /p bbox="Bbox Daten eingeben (z.B.: 8,10,9,49): "
            set /p zoom="Zoomstufen eingeben (z.B.: 15-17): "        
            echo map=osm bbox=%bbox% z=%zoom% >> Buildresult\%workdir%\Dockerfiles\Compose\mounts\tileserver\Import\tirex.batch
            goto TIREX_MEHR_AUSWAHL
            
        :TIREX_END
            color 0A
                @ping -n 3 localhost> nul   
            
REM ************************************************************************************************************************************************************************ 
            
    REM *********************    
    REM Abschluss und optionale Tools kopieren
    REM *********************   
    
        cls
            xcopy Data\OptionalTools\*.* Buildresult\%workdir%\ /I /H
        cls
        echo Fortschritt: [##################] 9 / 9
        echo.  
        echo Dockerfiles in Verzeichnis Data\%workdir% abgelegt
        echo.            
            @ping -n 5 localhost> nul             
            
    END