import Foundation
import AppKit

func getInstalledAppsInfoArray() -> Array<Array<String>> {
    var installedAppsArray = [[String]]()
    
    do {
        let installedApps = try FileManager.default.contentsOfDirectory(atPath: "/Applications")
        
        for app in installedApps {
            
            if app.hasSuffix(".app") {
                installedAppsArray.append([app, "/Applications/\(app)"])
            }
        }
        
        return installedAppsArray
    } catch {
        return installedAppsArray
    }
}

func backupCurrentTheme() {
    print("[INFO:] creating Backup of current theme...")
    if(!FileManager.default.fileExists(atPath: "/Users/\(NSUserName())/Desktop/vento_backup")) {
        
        do {
            try FileManager.default.createDirectory(atPath: "/Users/\(NSUserName())/Desktop/vento_backup", withIntermediateDirectories: false, attributes: nil)
            
            for appInfo in getInstalledAppsInfoArray() {
                var iconName = getApplicationIconName(path: appInfo[1])
                
                if(!iconName.hasSuffix(".icns")) {
                    iconName = iconName + ".icns"
                }
                
                if(FileManager.default.fileExists(atPath: "/Applications/\(appInfo[0])/Contents/Resources/\(iconName)") && !FileManager.default.fileExists(atPath: "/Users/\(NSUserName())/Desktop/vento_backup/\(getBundleIdentifierOfApplication(path: appInfo[1])).icns")) {
                    
                    print("[INFO:] backing up \(getBundleIdentifierOfApplication(path: appInfo[1]))")
                    
                    try FileManager.default.copyItem(at: URL(fileURLWithPath: "/Applications/\(appInfo[0])/Contents/Resources/\(iconName)"), to: URL(fileURLWithPath: "/Users/\(NSUserName())/Desktop/vento_backup/\(getBundleIdentifierOfApplication(path: appInfo[1])).icns"))
                    
                }
            }
            
        } catch {
            print("[ERROR:] \(error)")
        }
        
    }
    
}

func installTheme(themeFolderPath: String) {
    backupCurrentTheme()
    
    print("[INFO:] installing Theme")
    
    var themeFolderPathCorrected = themeFolderPath
    if !themeFolderPath.hasSuffix("/") {
        themeFolderPathCorrected += "/"
    }
    
    let appInfoArray = getInstalledAppsInfoArray()
    
    for app in appInfoArray {
        
        do {
            
            var appIconName = getApplicationIconName(path: app[1])
            if !appIconName.hasSuffix(".icns") {
                appIconName = appIconName + ".icns"
            }
            
            let expectedIconPath = themeFolderPathCorrected + getBundleIdentifierOfApplication(path: app[1]) + ".icns"
            
            if FileManager.default.fileExists(atPath: expectedIconPath) {
                
                print("[INFO:] copying Icon for \(app[0])")
                
                NSWorkspace.shared.setIcon(NSImage(byReferencing: URL(fileURLWithPath: expectedIconPath)), forFile: "/Applications/\(app[0])", options: NSWorkspace.IconCreationOptions(rawValue: 0))
                
                var AppURL = URL(fileURLWithPath: "/Applications/\(app[0])")
                var InfoURL = URL(fileURLWithPath: "/Applications/\(app[0])/Info.plist")
                var resourceValues = URLResourceValues()
                resourceValues.contentModificationDate = Date()
                try? AppURL.setResourceValues(resourceValues)
                try? InfoURL.setResourceValues(resourceValues)
            }
            
        } catch {
            print("[ERROR:] \(error)")
        }
    }
    
}
