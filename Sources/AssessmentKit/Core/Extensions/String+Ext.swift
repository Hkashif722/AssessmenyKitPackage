//
//  File.swift
//  AssessmentKit
//
//  Created by Kashif Hussain on 31/03/26.
//

//  LocalizedString.swift
//  AssessmentKit

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .main, comment: "")
    }
    
    func assessmentLocalized(in language: String) -> String {
        guard
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(self, bundle: .main, comment: "")
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
