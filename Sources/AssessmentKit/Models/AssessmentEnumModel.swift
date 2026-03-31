//
//  AssessmentEnumModel.swift
//  AssessmentKit
//

import SwiftUI

// MARK: - ContentType

/// Describes the question/content format for an assessment item.
public enum ContentType: String, Codable {
    case image               = "Image"
    case imageText           = "ImageText"
    case textVideo           = "TextVideo"
    case textAudio           = "TextAudio"
    case objective           = "Objective"
    case subjective          = "Subjective"
    case objectiveWithImage  = "ObjectiveImageOption"
    case subjectiveWithImage = "SubjectiveImageOption"
    case emoji               = "emoji"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .objective
            return
        }
        let rawValue = try container.decode(String.self)
        switch rawValue.lowercased() {
        case "image":                self = .image
        case "imagetext":            self = .imageText
        case "textvideo":            self = .textVideo
        case "textaudio":            self = .textAudio
        case "objective":            self = .objective
        case "subjective":           self = .subjective
        case "objectiveimageoption": self = .objectiveWithImage
        case "subjectiveimageoption":self = .subjectiveWithImage
        case "emoji":                self = .emoji
        default:                     self = .objective
        }
    }
}

public extension ContentType {
    var displayName: String {
        switch self {
        case .image:               return "Image"
        case .imageText:           return "Text & Image"
        case .textVideo:           return "Text & Video"
        case .objective:           return "Objective"
        case .subjective:          return "Subjective"
        case .textAudio:           return "Text & Audio"
        case .subjectiveWithImage: return "Subjective with Image"
        case .objectiveWithImage:  return "Objective with Image"
        case .emoji:               return ""
        }
    }
}

// MARK: - OptionType

public enum OptionType: String, Codable {
    case singleSelection   = "SingleSelection"
    case subjective        = "subjective"
    case multipleSelection = "MultipleSelection"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        switch rawValue {
        case "singleselection":   self = .singleSelection
        case "subjective":        self = .subjective
        case "multipleselection": self = .multipleSelection
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid value for OptionType: \(rawValue)"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

// MARK: - Section

public enum Section: String, Codable {
    case objective = "objective"
    case subjective = "subjective"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        switch rawValue {
        case "objective":  self = .objective
        case "subjective": self = .subjective
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid Section value: \(rawValue)"
            )
        }
    }
}

// MARK: - OptionWithAnsModel

public struct OptionWithAnsModel: Identifiable, Hashable {
    public var referenceQuestionID: Int32?
    public var optionType: String?
    public var arrOptionAnswerId: [Int32]?
    public var selectedAnswer: String?
    public var correctAns: Bool?

    public var optionTypeEnum: OptionType? {
        OptionType(rawValue: optionType ?? "")
    }

    public var id: Int32? { referenceQuestionID }

    public init(
        referenceQuestionID: Int32? = nil,
        optionType: String? = nil,
        arrOptionAnswerId: [Int32]? = nil,
        selectedAnswer: String? = nil,
        correctAns: Bool? = nil
    ) {
        self.referenceQuestionID = referenceQuestionID
        self.optionType = optionType
        self.arrOptionAnswerId = arrOptionAnswerId
        self.selectedAnswer = selectedAnswer
        self.correctAns = correctAns
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(referenceQuestionID)
    }

    public static func == (lhs: OptionWithAnsModel, rhs: OptionWithAnsModel) -> Bool {
        lhs.referenceQuestionID == rhs.referenceQuestionID
    }
}
