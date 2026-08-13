//
//  BundleToken.swift
//  AssessmentKit
//
//  Created by Kashif Hussain on 31/03/26.
//


// Inside the package — Sources/AssessmentKit/Resources/BundleToken.swift

import Foundation

// Internal token to locate the package bundle
private class BundleToken {}

public extension Bundle {
    static let assessmentKit: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}
