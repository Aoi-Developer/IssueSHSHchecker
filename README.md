# Issue SHSH checker

A bash script that allows you to easily check and obtain restorable iOS versions, including beta versions.  


# Available OS

MacOS  
intel_x86_64_Debian  

# dependencies

MacOS, please install Homebrew  

# Execution method

Usage: bash Issue_SHSH_checker.sh [device MODEL] [ECID] [apNonce]  

Running shsh.sh will start searching  

例:) bash <(curl -s https://raw.githubusercontent.com/Aoi-Developer/IssueSHSHchecker/Ver2.1/shsh.sh) iPhone10,3  

![test](Docs/test.png)

If you specify ECID as an argument, you can get all issued SHSH including the beta version that can be restored with Pwndfu  

例:) bash <(curl -s https://raw.githubusercontent.com/Aoi-Developer/IssueSHSHchecker/Ver2.1/shsh.sh) iPhone10,3 8237910564814894  

![test](Docs/shsh.png)

If you specify apNonce as an argument, you can get all issued SHSHs with apNonce specified  

例:) bash <(curl -s https://raw.githubusercontent.com/Aoi-Developer/IssueSHSHchecker/Ver2.1/shsh.sh) iPhone10,3 8237910564814894 0x1111111111111111  

# Credits

@tihmstar  
https://github.com/tihmstar/tsschecker
https://github.com/tihmstar/partialZipBrowser  

@m1stadev  
https://github.com/m1stadev/ios-beta-api


# 取得元  
https://github.com/m1stadev/ios-beta-api  
https://api.ipsw.me/



