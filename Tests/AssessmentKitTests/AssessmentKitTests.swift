import XCTest
@testable import AssessmentKit

// MARK: - ContentType Decoder Tests

final class ContentTypeTests: XCTestCase {

    func test_contentType_decodesKnownValues() throws {
        let cases: [(String, ContentType)] = [
            ("Objective",            .objective),
            ("OBJECTIVE",            .objective),
            ("Subjective",           .subjective),
            ("Image",                .image),
            ("ImageText",            .imageText),
            ("TextVideo",            .textVideo),
            ("TextAudio",            .textAudio),
            ("ObjectiveImageOption", .objectiveWithImage),
            ("SubjectiveImageOption",.subjectiveWithImage),
            ("emoji",                .emoji)
        ]

        for (raw, expected) in cases {
            let json = "\"\(raw)\"".data(using: .utf8)!
            let decoded = try JSONDecoder().decode(ContentType.self, from: json)
            XCTAssertEqual(decoded, expected, "Failed for raw value: \(raw)")
        }
    }

    func test_contentType_unknownValueDefaultsToObjective() throws {
        let json = "\"UnknownType\"".data(using: .utf8)!
        let decoded = try JSONDecoder().decode(ContentType.self, from: json)
        XCTAssertEqual(decoded, .objective)
    }
}

// MARK: - SegmentColorState Tests

final class SegmentColorStateTests: XCTestCase {

    func test_colorState_correct() {
        let model = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel(
            id: UUID(), sequenceNo: 1, correct: true
        )
        XCTAssertEqual(model.colorState, .correct)
    }

    func test_colorState_notCorrect() {
        let model = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel(
            id: UUID(), sequenceNo: 1, notCorrect: true
        )
        XCTAssertEqual(model.colorState, .notCorrect)
    }

    func test_colorState_attempted() {
        let model = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel(
            id: UUID(), sequenceNo: 1, attempted: true, notAttempted: false
        )
        XCTAssertEqual(model.colorState, .attempted)
    }

    func test_colorState_visited() {
        let model = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel(
            id: UUID(), sequenceNo: 1, notAttempted: false, visited: true
        )
        XCTAssertEqual(model.colorState, .visited)
    }

    func test_colorState_notAttempted() {
        let model = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel(
            id: UUID(), sequenceNo: 1
        )
        XCTAssertEqual(model.colorState, .notAttempted)
    }
}

// MARK: - Subjective View Tests

final class SharedAssessmentSubjectiveViewTests: XCTestCase {

    func test_textCountProgressBar_isShownByDefault() {
        let view = SharedAssessmentSubjectiveView()

        XCTAssertTrue(view.showTextCountProgressBar)
    }

    func test_textCountProgressBar_canBeHidden() {
        let view = SharedAssessmentSubjectiveView(showTextCountProgressBar: false)

        XCTAssertFalse(view.showTextCountProgressBar)
    }
}

final class SharedAssessmentSubjectiveWithImageUploderViewTests: XCTestCase {

    func test_textCountProgressBar_isShownByDefault() {
        let view = SharedAssessmentSubjectiveWithImageUploderView()

        XCTAssertTrue(view.showTextCountProgressBar)
    }

    func test_textCountProgressBar_canBeHidden() {
        let view = SharedAssessmentSubjectiveWithImageUploderView(
            showTextCountProgressBar: false
        )

        XCTAssertFalse(view.showTextCountProgressBar)
    }
}
