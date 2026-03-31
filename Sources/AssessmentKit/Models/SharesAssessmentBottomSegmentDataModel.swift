//
//  SharesAssessmentBottomSegmentDataModel.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct SharesAssessmentBottomSegmentDataModel {

    // MARK: - SegmentColorState

    public enum SegmentColorState {
        case attempted
        case notAttempted
        case visited
        case correct
        case notCorrect

        public var getBorderColor: Color {
            switch self {
            case .attempted:    return ColorUtility.deepGreen
            case .notAttempted: return ColorUtility.lightGray
            case .visited:      return ColorUtility.deepYellow
            case .correct:      return ColorUtility.deepGreen
            case .notCorrect:   return ColorUtility.deepRed
            }
        }

        public var getBackgroundColor: Color {
            switch self {
            case .attempted:    return ColorUtility.deepGreen.opacity(0.3)
            case .notAttempted: return ColorUtility.lightGray.opacity(0.3)
            case .visited:      return ColorUtility.deepYellow.opacity(0.3)
            case .correct:      return ColorUtility.deepGreen.opacity(0.3)
            case .notCorrect:   return ColorUtility.deepRed.opacity(0.3)
            }
        }
    }

    // MARK: - SegmentDataInfoModel

    public struct SegmentDataInfoModel<ID: Hashable>: SharedAssessmentBottomSegmentProtocol.SegmentInfoProtocol {
        public let id: ID
        public let sequenceNo: Int
        public let attempted: Bool
        public let notAttempted: Bool
        public let visited: Bool
        public let correct: Bool
        public let notCorrect: Bool
        public let colorState: SegmentColorState

        public init(
            id: ID,
            sequenceNo: Int,
            attempted: Bool = false,
            notAttempted: Bool = true,
            visited: Bool = false,
            correct: Bool = false,
            notCorrect: Bool = false
        ) {
            self.id = id
            self.sequenceNo = sequenceNo
            self.attempted = attempted
            self.notAttempted = notAttempted
            self.visited = visited
            self.correct = correct
            self.notCorrect = notCorrect

            switch (correct, notCorrect, attempted, visited) {
            case (true, _, _, _):              self.colorState = .correct
            case (_, true, _, _):              self.colorState = .notCorrect
            case (false, false, true, _):      self.colorState = .attempted
            case (false, false, false, true):  self.colorState = .visited
            default:                           self.colorState = .notAttempted
            }
        }
    }

    // MARK: - SegmentStyleDataModel

    public struct SegmentStyleDataModel<SegmentProtocol: SharedAssessmentBottomSegmentProtocol.SegmentInfoProtocol> {
        public let segmentInfoDataModel: SegmentProtocol

        public init(segmentDataModel: SegmentProtocol) {
            self.segmentInfoDataModel = segmentDataModel
        }

        public var colorState: SegmentColorState {
            segmentInfoDataModel.colorState
        }

        public var getFontColor: Color {
            colorState.getBackgroundColor.getDynamicTextColor
        }
    }
}

// MARK: - Debug / Preview Helpers

#if DEBUG
public extension SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel where ID == UUID {

    static var attempted: Self {
        .init(id: UUID(), sequenceNo: 1, attempted: true, notAttempted: false, visited: true)
    }

    static var visited: Self {
        .init(id: UUID(), sequenceNo: 2, attempted: false, notAttempted: false, visited: true)
    }

    static var notAttempted: Self {
        .init(id: UUID(), sequenceNo: 3, attempted: false, notAttempted: true, visited: false)
    }

    static var allSamples: [Self] { [.attempted, .visited, .notAttempted] }

    static var sampleList: [Self] {
        [
            .init(id: UUID(), sequenceNo: 1, attempted: true,  notAttempted: false, visited: true),
            .init(id: UUID(), sequenceNo: 2, attempted: false, notAttempted: false, visited: true),
            .init(id: UUID(), sequenceNo: 3, attempted: false, notAttempted: true,  visited: false),
            .init(id: UUID(), sequenceNo: 4, attempted: true,  notAttempted: false, visited: true),
            .init(id: UUID(), sequenceNo: 5, attempted: false, notAttempted: false, visited: true)
        ]
    }

    static func makeSampleSegments(count: Int) -> [Self] {
        let states: [(Bool, Bool, Bool)] = [
            (true,  false, true),
            (false, false, true),
            (false, true,  false)
        ]
        return (1...count).map { index in
            let state = states[index % states.count]
            return .init(
                id: UUID(),
                sequenceNo: index,
                attempted: state.0,
                notAttempted: state.1,
                visited: state.2
            )
        }
    }
}

public extension SharesAssessmentBottomSegmentDataModel.SegmentStyleDataModel
where SegmentProtocol == SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<UUID> {
    static var attempted: Self    { .init(segmentDataModel: .attempted) }
    static var visited: Self      { .init(segmentDataModel: .visited) }
    static var notAttempted: Self { .init(segmentDataModel: .notAttempted) }
}
#endif
