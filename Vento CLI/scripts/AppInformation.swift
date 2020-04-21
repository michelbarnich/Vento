import Foundation
import AppKit

func getBundleIdentifierOfApplication(path: String) -> String {
    
    return (Bundle(path: path)?.bundleIdentifier)!
    
}

func getApplicationIconName(path: String) -> String {    
    return Bundle(path: path)?.infoDictionary!["CFBundleIconFile"] as! String
}
