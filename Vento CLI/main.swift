import Foundation

print("""
-------------------------------
|          Vento CLI          |
|    made by @michelbarnich   |
-------------------------------
This sowftware is meant for development purposes only! Even though it is very unlikely, I'm not responsible for any damage that might be caused by using vento or vento CLI.

usage:
-b  print Bundle Identifiers of Apps in "/Applications" Use this if a specific Icon doesnt show up, maybe the Info.plist of the Application messes up the "XML Parser"

-a  prints out the App Icon Names. No specific usage to be honest.

-i  installing a theme, the next argument has to be the path of the folder containing the theme!

-e  export theme. This will take the current Icons of the Apps, and compile a theme out of them. This is used to create a backup of the original icons. The backup Theme can be found on your Desktop. It will create a folder named "vento_backup"
------------------------------
""")

if CommandLine.arguments.contains("-b") {
    print("[INFO:] printing Bundle Identifiers of Apps installed in \"/Applications\"")
    
    let installedAppsInfo = getInstalledAppsInfoArray()
    
    for appArray in installedAppsInfo {
        print("[INFO:] \(appArray[0]): \(getBundleIdentifierOfApplication(path: appArray[1]))")
    }
}

if CommandLine.arguments.contains("-i") {
    
    if CommandLine.arguments.firstIndex(of: "i") != CommandLine.arguments.count {
        installTheme(themeFolderPath: CommandLine.arguments[CommandLine.arguments.firstIndex(of: "-i")! + 1])
    }
    
}

if CommandLine.arguments.contains("-a") {
    print("[INFO:] printing Icon Names of Apps installed in \"/Applications\"")
    
    let installedAppsInfo = getInstalledAppsInfoArray()
    
    for appArray in installedAppsInfo {
        print("[INFO:] \(appArray[0]): \(getApplicationIconName(path: appArray[1]))")
    }
}

if CommandLine.arguments.contains("-e") {
    backupCurrentTheme()
}

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
