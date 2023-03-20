$PathToSetup = "\\XXXXXXX\XXXXXX\XXXXXXX\glpi\"
$SetupName = "fusioninventory-agent_windows-x64_2.6.exe"
$SetupOptions = "/S /acceptlicense /installtasks=Collect,Deploy,Inventory,WakeOnLan /ca-cert-file=C:\Program Files\FusionInventory-Agent\certs\chain.pem /add-firewall-exception /ssl-check /execmode=service /runnow"
$GLPIUri = "https://glpi.cmin.fr/plugins/fusioninventory/"

### Function to define the address of the GLPI Server in the registry
    Function DefineGLPIServer{

        param(
            [string]$SetupName,
            [string]$GLPIUri
        )

        # Before change the "server" parameter, wait the end of the installation process
        Wait-Process -Name $SetupName.Replace(".exe","")

    if((Get-ItemProperty -Path "HKLM:\SOFTWARE\FusionInventory-Agent\" -Name "Server" -ErrorAction SilentlyContinue)){
                    
             # Modify in the registry the GLPI server URI
             Set-ItemProperty -Path "HKLM:\SOFTWARE\FusionInventory-Agent\" -Name "Server" -Value $GLPIUri

             # Restart "FusionInventory Agent" Service
             Restart-Service "FusionInventory Agent"

        } # if(Get-ItemProperty -Path "HKLM:\SOFTWARE\FusionInventory-Agent\" -Name "Server" )

    } # function DefineGLPIServer

### Function : Determine if a version is already installed
    Function AlreadyInstalledOrNot{

        # For 64 bits operating system

            if((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FusionInventory-Agent\" -ErrorAction SilentlyContinue).DisplayVersion){

                [version]$CurrentVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FusionInventory-Agent\" -ErrorAction SilentlyContinue).DisplayVersion

            }else{

                [version]$CurrentVersion = "0.0"

            }                        
            

        return $CurrentVersion

    } # Function AlreadyInstalledOrNot

### Determine Fusion Inventory Setup Version
    [version]$SetupVersion = (($SetupName).Split("_"))[2].Replace(".exe","")

    # Determine the full path to the setup
    $FullPathToSetup = $PathToSetup + "\" + $SetupName
    $FullPathToSetup = $FullPathToSetup.Replace("\\$SetupName","\$SetupName")
        
    # Check if the Fusion Inventory Agent is already installed or not (get the actual version)
    [version]$CurrentVersion = AlreadyInstalledOrNot
        
    # if $CurrentVersion is empty, we can install the Fusion Inventory agent
    if($CurrentVersion -eq "0.0"){

        Write-Output "Installation of Fusion Inventory Agent $SetupVersion necessary because it is not installed..."
        Write-Output "Path to the setup : $FullPathToSetup"

        if(Get-Service "FusionInventory Agent" -ErrorAction SilentlyContinue){ Stop-Service "FusionInventory Agent" }

        # Start the installation of the Fusion Inventory Agent, with your setup and your options
        Invoke-Expression "& $FullPathToSetup $SetupOptions"

        # Define the server URL
        DefineGLPIServer -SetupName $SetupName -GLPIUri $GLPIUri

    }elseif($SetupVersion -gt $CurrentVersion){

        Write-Output "Installation of Fusion Inventory Agent necessary because it is out of date... (Setup $SetupVersion VS Actual $CurrentVersion)"

        Write-Output "Path to the setup : $FullPathToSetup"

        if(Get-Service "FusionInventory Agent" -ErrorAction SilentlyContinue){ Stop-Service "FusionInventory Agent" }

        # Start the installation of the Fusion Inventory Agent, with your setup and your options
        Invoke-Expression "& $FullPathToSetup $SetupOptions"

        # Define the server URL
        DefineGLPIServer -SetupName $SetupName -GLPIUri $GLPIUri

    }elseif($SetupVersion -eq $CurrentVersion){

        Write-Output "The actual version is equal to the setup version (Setup $SetupVersion VS Actual $CurrentVersion)"

    }elseif($SetupVersion -lt $CurrentVersion){

        Write-Output "The actual version is more recent that the setup version (Setup $SetupVersion VS Actual $CurrentVersion)"

    }
 