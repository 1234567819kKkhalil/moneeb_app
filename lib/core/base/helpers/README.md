# Helper Guide

- App Updater is an alert to update the application when u upload a new version to store either android or iOS
- it provides full control if u want to show or don't show the alert, enforce user to update if it's an urgent update or make it optional


### For Mobile ###
- # U must initialize # [lib/common/utils/app_updater] u can see Firebase remote config manger , it already initialized in FirebaseHelper
- call [VersionChecker.checkForAppUpdate(context)] in builder screen to handle alert showing 
- change the ui design in [UpdateAppAlert] as u like and  **#CHANGE STORE LINKS TO YOURS#** 

### For Firebase ###
- Just set remote config setup and put the keys like this 
- in parameter name put the key 'production_version'
- in its value put { "IOS" :{ "version" : "1.0.42", "required" : false, "show_alert":false }, "ANDROID":{ "version" : "1.0.42" , "required" :false,"show_alert":false } }
- choose data type as String