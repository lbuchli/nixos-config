{
 enable = true;
 settings = {
   bar = {
     density = "compact";
     position = "right";
     showCapsule = false;
     widgets = {
       left = [
         {
           id = "ControlCenter";
           useDistroLogo = false;
           logo = "home";
         }
         {
           id = "Network";
         }
         {
           id = "Bluetooth";
         }
       ];
       center = [
         {
           hideUnoccupied = false;
           id = "Workspace";
           labelMode = "none";
         }
       ];
       right = [
         {
           alwaysShowPercentage = false;
           id = "Battery";
           warningThreshold = 30;
         }
         {
           formatHorizontal = "HH:mm";
           formatVertical = "HH mm";
           id = "Clock";
           useMonospacedFont = true;
           usePrimaryColor = true;
         }
       ];
     };
   };
   colorSchemes.predefinedScheme = "Ayu";
   general = {
     avatarImage = "";
     radiusRatio = 0.2;
   };
   location = {
     monthBeforeDay = false;
     name = "Zurich, Switzerland";
   };
 };

 plugins = {
   sources = [
     {
       enabled = true;
       name = "Official Noctalia Plugins";
       url = "https://github.com/noctalia-dev/noctalia-plugins";
     }
   ];
   states = {
     kde-connect = {
       enabled = true;
       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
     };
     privacy-indicator = {
       enabled = true;
       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
     };
     activate-linux = {
       enabled = true;
       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
     };
   };
   version = 2;
 };
 # this may also be a string or a path to a JSON file.

 pluginSettings = {
 };
}
