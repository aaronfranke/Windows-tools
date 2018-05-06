#Windows 10 Decrapifier 2.0: ULTRA-DECRAPIFIER
#By CSAND
#March 16 2018
#
#
#OFFICIAL DOWNLOAD:
#https://community.spiceworks.com/scripts/show/3298-windows-10-decrapifier-v2
#
#
#Join the Spiceworks Decrapifier community group on Spiceworks to get help or make suggestions!
#https://community.spiceworks.com/user-groups/windows-decrapifier-group
#
#
#***Please follow the how-tos below for best results!!! These are the only ways I suggest to run this script. Meant to be run on a new machine. Running from an existing user profile will give good, but incomplete results.***
#
#Single machine how-to:
#https://community.spiceworks.com/how_to/148624-how-to-clean-up-a-single-windows-10-machine-image-using-decrapifier
#
#Basic MDT how-to:
#https://community.spiceworks.com/how_to/150455-shoehorn-decrapifier-into-your-mdt-task
#
#WARNING: This script will alter Windows 10. The changes can be difficult to undo! It does exactly what it says, however I encourage you to research these changes beforehand. 
#         I described each section with comments, so please read first. The less heavy-handed original version of the Decrapifier is available.
#		  It's always a decent idea to backup your PC before running scripts like this.
#
#Decrapifier Version 1:
#https://community.spiceworks.com/scripts/show/3977-windows-10-decrapifier-version-1
#
#PURPOSE: Eliminate much of the bloat that comes with Windows 10. By default - change a large amount of privacy settings in your favour. Remove built-in advertising, Cortana, OneDrive. Disable most data collection. 
#         Clean up the start menu for new user accounts.  Remove a bunch of pre-insalled apps, or all of them (including the store).  Create a clean, professional looking W10 experience.  Changes some settings no longer available
#		  via GPO for Professional edition.
#
#
#
#
#***Switches! Customize your decrapification!***
# 
#Switch         Function
#---------------------------
#No switches    Decrapifies current user account only. Leaves other user accounts alone. Still disables services and scheduled tasks. Removes all apps but Store, Photos, Sound Recorder, 3D Paint, and Calculator.
#-allusers      Decrapifies the current user account, and the default user account.  Run on the first login to your new machine, and only decrapify once!
#-allapps       Removes ALL apps including the store.  Use wisely!
#-leavetasks    Leaves scheduled tasks alone.
#-leaveservices Leaves services alone.
#-clearstart    Applies a clean start menu with only the File Explorer, Snipping Tool, and Control Panel pinned.  Applies to all subsequent new users on the PC. Customize your pinned apps by editing the layout right in this script! (Find the ClearStartMenu function).
#-appsonly      Only removes apps, doesn't touch privacy settings, services, and scheduled tasks. Cannot be used with -settingsonly switch. Can be used with all the others.
#-settingsonly  Only adjusts privacy settings, services, and scheduled tasks.  Leaves apps.  Cannot be used with -appsonly switch.  Can be used with all others (-allapps won't do anything in that case, obviously).
#
#
[cmdletbinding(DefaultParameterSetName="Decrapifier")]
param (
	[switch]$allusers,
	[switch]$allapps,
    [switch]$leavetasks,
    [switch]$leaveservices,
    [switch]$clearstart,
    [Parameter(ParameterSetName="AppsOnly")]
    [switch]$appsonly,
    [Parameter(ParameterSetName="SettingsOnly")]
    [switch]$settingsonly
	)


#Appx removal
Function RemMostApps {
    If ($allusers) {  
        Write-Host "***Removing all apps and provisioned appx packages for this machine except Store, Photos, and Calculator...***"      
        Get-AppxPackage -AllUsers | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Xbox*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*sticky*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*" -and $_.name -notlike "*MSPaint*"} | Remove-AppxPackage -erroraction silentlycontinue
        Get-AppxPackage -AllUsers | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Xbox*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*sticky*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*" -and $_.name -notlike "*MSPaint*"} | Remove-AppxPackage -erroraction silentlycontinue
        Get-AppxProvisionedPackage -online | where-object {$_.displayname -notlike "*Store*" -and $_.displayname -notlike "*Calculator*" -and $_.displayname -notlike "*sticky*" -and $_.displayname -notlike "*Windows.Photos*" -and $_.displayname -notlike "*SoundRecorder*"  -and $_.displayname -notlike "*MSPaint*"} | Remove-AppxProvisionedPackage -online -erroraction silentlycontinue
       
}    Else {
        Write-Host "***Removing all apps for the current user, except Store, Photos and Calculator...***"                 
        Get-AppxPackage | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Weather*" -and $_.name -notlike "*Xbox*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*sticky*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*" -and $_.name -notlike "*MSPaint*"} | Remove-AppxPackage -erroraction silentlycontinue
        Get-AppxPackage | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Weather*" -and $_.name -notlike "*Xbox*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*sticky*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*" -and $_.name -notlike "*MSPaint*"} | Remove-AppxPackage -erroraction silentlycontinue
}        
}
    
Function RemAllApps {
    If ($allusers) {
        Write-Host "***Removing all apps and provisioned appx packages for this machine...***"
        Get-AppxPackage -AllUsers | Remove-AppxPackage -erroraction silentlycontinue
        Get-AppxPackage -AllUsers | Remove-AppxPackage -erroraction silentlycontinue
        Get-AppxProvisionedPackage -online | Remove-AppxProvisionedPackage -online -erroraction silentlycontinue

}    Else {
        Write-Host "***Removing all apps for the current user...***"
        Get-Appxpackage | Remove-Appxpackage -erroraction silentlycontinue
        Get-Appxpackage | Remove-Appxpackage -erroraction silentlycontinue
}
}


#Scheduled task removal
#Tasks: Send Smartscreen filtering data to MS, CEIP options that used to be able to be disabled earlier Windows (now mandatory) - functions self explanatory based on the name
#       Send error reports in the queue to MS, installation of ads, cloud content, etc
Function RemTasks {
    If ($leavetasks) {
        Write-Host "***Leavetasks switch set - leaving scheduled tasks intact...***"
 
}    Else {
        Write-Host "***Disabling some unecessary scheduled tasks...***"
        Get-Scheduledtask "SmartScreenSpecific","Microsoft Compatibility Appraiser","Consolidator","KernelCeipTask","UsbCeip","Microsoft-Windows-DiskDiagnosticDataCollector", "GatherNetworkInfo","QueueReporting" -erroraction silentlycontinue | Disable-scheduledtask 
}
}

#Disable services
Function DisService {
    If ($leaveservices) {
        Write-Host "***Leaveservices switch set - leaving services enabled...***"

}    Else {
        Write-Host "***Stopping and disabling diagnostics tracking services, Onesync service (syncs contacts, mail, etc, needed for OneDrive), various Xbox services, and Windows Media Player network sharing (you can turn this back on if you share your media libraries with WMP)...***"
        #Diagnostics tracking and xbox services
		Get-Service Diagtrack,OneSyncSvc,XblAuthManager,XblGameSave,XboxNetApiSvc,WMPNetworkSvc -erroraction silentlycontinue | stop-service -passthru | set-service -startuptype disabled
		#WAP Push Message Routing  NOTE Sysprep w/ Generalize WILL FAIL if you disable the DmwApPushService.  Commented out by default.
		#Get-Service DmwApPushService -erroraction silentlycontinue | stop-service -passthru | set-service -startuptype disabled
}
}

        
#Registry change functions

#Load default user hive
Function loaddefaulthive {
    reg load "$reglocation" c:\users\default\ntuser.dat
}
#unload default user hive
Function unloaddefaulthive {
    [gc]::collect()
    reg unload "$reglocation"
}

Function RegSetCUOnly {
    
    #Setting Windows 10 privacy options user settings, these are all available from the settings menu
    #Can apps access...
    #Location
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_DWORD /V "SensorPermissionState" /D 0 /F
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_SZ /V "Value" /D DENY /F
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /T REG_SZ /V "Value" /D DENY /F
    #Camera
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /T REG_SZ /V "Value" /D DENY /F
    #Calendar
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /T REG_SZ /V "Value" /D DENY /F
    #Contacts
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /T REG_SZ /V "Value" /D DENY /F
    #Notifications
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /T REG_SZ /V "Value" /D DENY /F
    #Microphone
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /T REG_SZ /V "Value" /D DENY /F
    #Account Info
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /T REG_SZ /V "Value" /D DENY /F
    #Call history
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /T REG_SZ /V "Value" /D DENY /F
    #Email, may break the Mail app?
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /T REG_SZ /V "Value" /D DENY /F
    #TXT/MMS
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /T REG_SZ /V "Value" /D DENY /F
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" /T REG_SZ /V "Value" /D DENY /F
    #Radios
    Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /T REG_SZ /V "Value" /D DENY /F
}

#Set default user settings
Function RegSetUser {
    #Disabling Suggested Apps, Feedback, Lockscreen Spotlight, and File Explorer ads
    #Start menu suggestions
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SystemPaneSuggestionsEnabled" /D 0 /F
    #Lockscreen suggestions, rotating pictures
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SoftLandingEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenEnabled" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenOverlayEnabled" /D 0 /F
    #Preinstalled apps, Minecraft Twitter etc all that - Enterprise only it seems
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEverEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "OEMPreInstalledAppsEnabled" /D 0 /F
    #Stop MS shoehorning apps quietly into your profile
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SilentInstalledAppsEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "ContentDeliveryAllowed" /D 0 /F
    #1709, doesn't work - Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContentEnabled" /D 0 /F
    #Ads in File Explorer
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /T REG_DWORD /V "ShowSyncProviderNotifications" /D 0 /F
    
    #Disabling auto update and download of Windows Store Apps - enable if you are not using the store
    #Reg Add "$reglocation\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "AutoDownload" /D 2 /F
    
    #Disabling Onedrive startup run user settings
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 0300000021B9DEB396D7D001 /F
        
    #Let websites provide local content by accessing language list
    Reg Add "$reglocation\Control Panel\International\User Profile" /T REG_DWORD /V "HttpAcceptLanguageOptOut" /D 1 /F
    
    #Let apps share and sync non-explicitly paired wireless devices over uPnP
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /T REG_SZ /V "Value" /D DENY /F
    
    #Don't ask for feedback
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "NumberOfSIUFInPeriod" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "PeriodInNanoSeconds" /D 0 /F
    
    #Stopping Cortana/Microsoft from getting to know you"
    Reg Add "$reglocation\SOFTWARE\Microsoft\Personalization\Settings" /T REG_DWORD /V "AcceptedPrivacyPolicy" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /T REG_DWORD /V "Enabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitTextCollection" /D 1 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitInkCollection" /D 1 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /T REG_DWORD /V "HarvestContacts" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Input\TIPC" /T REG_DWORD /V "Enabled" /D 0 /F
    
    #Disabling Cortana and Bing search user settings"
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaEnabled" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "BingSearchEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "DeviceHistoryEnabled" /D 0 /F
    
	#Below takes search bar off the taskbar, personal preference
    #Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "SearchboxTaskbarMode" /D 0 /F
    
    #Stop Cortana from remembering history"
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "HistoryViewEnabled" /D 0 /F
}

#Set local machine policies    
Function RegSetMachine {

    #--Local GP settings--
    #Can be adjusted in GPedit.msc in Pro+ editions.
    #Local Policy/Computer Config/Admin Templates/Windows Components			
	#/App Privacy			
    #Account Info			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessAccountInfo"/D 2 /F
	#Calendar			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessCalendar"/D 2 /F
    #Call History			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessCallHistory" /D 2 /F
    #Camera			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessCamera" /D 2 /F
    #Contacts			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessContacts" /D 2 /F
    #Email			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessEmail" /D 2 /F
    #Location			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessLocation" /D 2 /F
    #Messaging			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessMessaging" /D 2 /F
    #Microphone			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessMicrophone" /D 2 /F
    #Motion			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessMotion" /D 2 /F
    #Notifications			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessNotifications" /D 2 /F
    #Make Phone Calls			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessPhone" /D 2 /F
    #Radios			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessRadios" /D 2 /F
    #Access trusted devices			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessTrustedDevices" /D 2 /F
    #Sync with devices			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsSyncWithDevices" /D 2 /F

    #/Application Compatibility
    #Turn off Application Telemetry			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "AITEnable" /D 0 /F			
    #Turn off inventory collector			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "DisableInventory" /D 1 /F
    #Turn off steps recorder
    Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "DisableUAR" /D 1 /F

    #/Cloud Content			
    #Do not show Windows Tips			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableSoftLanding" /D 1 /F
    #Turn off Consumer Experiences			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableWindowsConsumerFeatures" /D 1 /F
    
    #/Data Collection and Preview Builds			
    #Set Telemetry to basic (switches to 1:basic for W10Pro and lower, disabled altogether by disabling service anyways)			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "AllowTelemetry" /D 0 /F
    #Disable pre-release features and settings			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /T REG_DWORD /V "EnableConfigFlighting" /D 0 /F
    #Do not show feedback notifications			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "DoNotShowFeedbackNotifications" /D 1 /F

    #/Delivery optimization			
    #Disable DO; set to 1 to allow DO over LAN only			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /T REG_DWORD /V "DODownloadMode" /D 0 /F
    #Non-GPO DO settings, may be redundant after previous.
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DownloadMode" /D 0 /F
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DODownloadMode" /D 0 /F
        
    #/Location and Sensors			
    #Turn off location			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /T REG_DWORD /V "DisableLocation" /D 1 /F
	#Turn off Sensors			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /T REG_DWORD /V "DisableSensors" /D 1 /F

    #/Microsoft Edge			
    #Always send do not track			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /T REG_DWORD /V "DoNotTrack" /D 1 /F

    #/OneDrive			
    #Prevent usage of OneDrive			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 1 /F
    Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 1 /F
			
    #/Search			
    #Disallow Cortana			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowCortana" /D 0 /F
    #Disallow Cortana on lock screen			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowCortanaAboveLock" /D 0 /F
    #Disallow web search from desktop search			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "DisableWebSearch" /D 1 /F
    #Don't search the web or display web results in search			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "ConnectedSearchUseWeb" /D 0 /F

    #/Store			
    #Turn off Automatic download/install of app updates - comment in if you aren't using the store		
    #Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "AutoDownload" /D 2 /F
    			
    #Disable all apps from store, left disabled by default			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "DisableStoreApps" /D 1 /F
    			
    #Turn off Store, left disabled by default			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "RemoveWindowsStore" /D 1 /F

    #/Sync your settings			
    #Do not sync (anything)			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /T REG_DWORD /V "DisableSettingSync" /D 2 /F
    #Disallow users to override this
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /T REG_DWORD /V "DisableSettingSyncUserOverride" /D 1 /F

    #/Windows Update			
    #Turn off featured software notifications through WU (basically ads)			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /T REG_DWORD /V "EnableFeaturedSoftware" /D 0 /F

    #--Non Local-GP Settings--
    #Disabling advertising info and device metadata collection for this machine
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /V "PreventDeviceMetadataFromNetwork" /T REG_DWORD /D 1 /F

    #Prevent apps on other devices from opening apps on this one
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" /T REG_DWORD /V "UserAuthPolicy " /D 0 /F
    
    #Prevent using sign-in info to automatically finish setting up after an update
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /T REG_DWORD /V "ARSOUserConsent" /D 2 /F
    
    #Disable Malicious Software Removal Tool through WU, and CEIP.  Left MRT enabled by default.
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /T REG_DWORD /V "DontOfferThroughWUAU" /D 1 /F
    Reg Add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /T REG_DWORD /V "CEIPEnable" /D 0 /F
	
	#Filter web content through smartscreen. Left enabled by default.
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /T REG_DWORD /V "EnableWebContentEvaluation" /D 0 /F
    
    #User Config/Admin Templates/Windows Components	(work in progress, don't seem to work)		
    #/Cloud Content			
    #Turn off spotlight on lock screen			
    #Reg Add	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{8F5431C8-CECD-4977-92D5-0C52E9705084}User\Software\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "ConfigureWindowsSpotlight" /D 2 /F
    #Reg Add	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{8F5431C8-CECD-4977-92D5-0C52E9705084}User\Software\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "IncludeEnterpriseSpotlight" /D 0 /F
    			
    #Do not suggest 3rd party content			
    #Reg Add	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{8F5431C8-CECD-4977-92D5-0C52E9705084}User\Software\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableThirdPartySuggestions" /D 1 /F
    			
    #Turn off all spotlight features			
    #Reg Add	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{8F5431C8-CECD-4977-92D5-0C52E9705084}User\Software\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableWindowsSpotlightFeatures" /D 1 /F  
}           

#Call correct registry changing functions
Function RegChange {
     If ($allusers) {
        Write-Host "***Setting registry for current and default user, and policies for local machine...***"
        regsetCUonly
        $reglocation = "HKCU"
        regsetuser
        $reglocation = "HKLM\AllProfile"
        loaddefaulthive; regsetuser; unloaddefaulthive
        $reglocation = $null
        regsetmachine
        Write-Host "***Registry set current user and default user, and policies set for local machine!***"
 
}    Else {
        Write-Host "***Allusers switch not set - setting registry for current user only, ignoring local machine settings/polices...***"
        regsetCUonly
        $reglocation = "HKCU"
        regsetuser
        Write-Host "***Allusers switch not set - registry set for current user only! Machine settings/policies untouched.***"
}
}

#Clean up the default start menu    
Function ClearStartMenu {
     If ($clearstart) {
        Write-Host "***Setting clean start menu for new profiles...***"
        $startlayoutstr = @"
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
        <start:Group Name="" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Snipping Tool.lnk" />
		  <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@
        add-content $Env:TEMP\startlayout.xml $startlayoutstr
        import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
        remove-item $Env:TEMP\startlayout.xml

}    Else {
        Write-Host "***Clearstart switch not present - menu tiles left untouched.***"
}
}


#Goodbye Message Function

Function Goodbye {
    Write-Host "*******Decrapification complete.*******"
	Write-Host "*******Remember to set your execution policy back!  Set-Executionpolicy restricted is the Windows 10 default.*******"
    Write-Host "*******Reboot your computer now!*******"
       
}

#Decrapify based on allapps switch, and settingsonly or appsonly switches

Write-Host "******Decrapifying Windows 10...******"
If ($appsonly) {
        If ($allapps) {
            RemAllApps
            ClearStartMenu
            Goodbye

}        Else {
            RemMostApps
            ClearStartMenu
            Goodbye
}

}Elseif ($settingsonly) {
         Remtasks
         DisService
         RegChange
         ClearStartMenu
         Goodbye

}Else {
        If ($allapps) {
            RemAllApps
            Remtasks
            DisService
            RegChange
            ClearStartMenu
            Goodbye

}        Else {
            RemMostApps
            Remtasks
            DisService
            RegChange
            ClearStartMenu
            Goodbye
}
}









