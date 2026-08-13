//
//  File.swift
//  AssessmentKit
//
//  Created by Kashif Hussain on 31/03/26.
//

//  LocalizedString.swift
//  AssessmentKit

import Foundation

public enum AssessmentKitLocalization {
    nonisolated(unsafe) private static var languageCode = "en"

    public static func configure(languageCode: String) {
        self.languageCode = normalized(languageCode)
    }

    static var locale: Locale {
        Locale(identifier: languageCode)
    }

    static func localizedString(for key: String) -> String {
        let selected = NSLocalizedString(key, bundle: bundle, value: key, comment: "")
        guard selected == key, let englishBundle = localizedBundle(for: "en") else {
            return selected
        }
        return NSLocalizedString(key, bundle: englishBundle, value: key, comment: "")
    }

    private static var bundle: Bundle {
        localizedBundle(for: languageCode)
        ?? localizedBundle(for: "en")
        ?? .assessmentKit
    }

    private static func localizedBundle(for code: String) -> Bundle? {
        guard let path = Bundle.assessmentKit.path(forResource: code, ofType: "lproj") else {
            return nil
        }
        return Bundle(path: path)
    }

    private static func normalized(_ code: String) -> String {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "en" }
        if trimmed.caseInsensitiveCompare("ur-in") == .orderedSame { return "ur-IN" }
        return String(trimmed.prefix(2)).lowercased()
    }
}

public extension String {
    var localized: String {
        AssessmentKitLocalization.localizedString(for: self)
    }
    
    func assessmentLocalized(in language: String) -> String {
        guard
            let path = Bundle.assessmentKit.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return AssessmentKitLocalization.localizedString(for: self)
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
