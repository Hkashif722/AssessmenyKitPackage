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
    static let assessmentKit: Bundle = Bundle(for: BundleToken.self)
}