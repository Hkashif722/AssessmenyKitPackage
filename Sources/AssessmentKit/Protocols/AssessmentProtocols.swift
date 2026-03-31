//
//  AssessmentProtocols.swift
//  AssessmentKit
//

import Foundation

// MARK: - AssessmentOptionProtocol

/// Defines the interface for any option model used in assessment views.
/// Conform your own model to this protocol to swap `OptionModel` at the call-site.
public protocol AssessmentOptionProtocol: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var imagePath: URL? { get }
    var isSelected: Bool { get set }
    var questionID: Int? { get }
    var optionText: String? { get }
    var selectedOptionId: Int32? { get }
    var isReview: Bool { get }
    var isCorrectAnswer: Bool? { get }
}

// MARK: - SharedAssessmentBottomSegmentProtocol

/// Namespace enum containing the protocol for segment info models.
public enum SharedAssessmentBottomSegmentProtocol {
    public protocol SegmentInfoProtocol: Identifiable, Comparable, Hashable where ID: Hashable {
        var sequenceNo: Int { get }
        var attempted: Bool { get }
        var notAttempted: Bool { get }
        var visited: Bool { get }
        var colorState: SharesAssessmentBottomSegmentDataModel.SegmentColorState { get }
    }
}

public extension SharedAssessmentBottomSegmentProtocol.SegmentInfoProtocol {
    var segmentTextRepresentable: String { "\(sequenceNo)" }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }

    static func < (lhs: Self, rhs: Self) -> Bool { lhs.sequenceNo < rhs.sequenceNo }
}
