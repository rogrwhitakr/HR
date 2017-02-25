Wenn nicht über Workstation GUI möglich
	-->	get VMWARE virtual Network Editor
		-->	change directory to VMWARE directory
		->	rundll32.exe vmnetui.dll VMNetUI_ShowStandalone
		
Windows Services
	-->	sc
		SYNTAX:
		sc <Server> [Befehl] [Dienstname] <Option1> <Option2>...
	
	-->	sc delete "Service_name"
	-->	sc create "Service_name" bn-path options...	