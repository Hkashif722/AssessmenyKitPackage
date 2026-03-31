# AssessmentKit

A SwiftUI Swift Package extracted from the Ujjivan/Enthral LMS platform.
Provides a complete, reusable assessment-question UI layer — header, media previews, answer inputs, and bottom navigation — ready to drop into any multi-tenant LMS target.

---

## Requirements

| | Minimum |
|---|---|
| iOS | 15.0 |
| Swift | 5.9 |
| Xcode | 15.0 |

---

## Installation

### Swift Package Manager

In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_ORG/AssessmentKit.git", from: "1.0.0")
]
```

Or via **Xcode → File → Add Package Dependencies**.

> ⚠️ **You must also resolve the `SwiftUIUtilities` dependency.** Update the URL in `Package.swift` to point to your private repo or Azure DevOps feed before building.

---

## Package Structure

```
Sources/AssessmentKit/
├── Models/
│   ├── AssessmentEnumModel.swift          // ContentType, OptionType, Section, OptionWithAnsModel
│   ├── OptionModel.swift                  // OptionModel + typealias SharedAssessmentOptionModel
│   └── SharesAssessmentBottomSegmentDataModel.swift
├── Protocols/
│   └── AssessmentProtocols.swift          // AssessmentOptionProtocol, SharedAssessmentBottomSegmentProtocol
├── Stubs/
│   └── AssessmentStubs.swift              // ⚠️ Replace: AssessmentImageSelection, EmojiFeedbackView
├── Views/
│   ├── Header/
│   │   └── SharedAssessmentHeaderView.swift
│   ├── Preview/
│   │   ├── AssessmentAudioPlayerView.swift
│   │   ├── AssessmentVideoPreview.swift
│   │   ├── AssessmentImagePreviewView.swift
│   │   └── SharedAssessmentPreviewType.swift
│   ├── Selection/
│   │   ├── SharedAssessmentSelectionTypeView.swift  // ← main dispatcher
│   │   ├── SharedAssessmentOptionListView.swift
│   │   ├── SharedAssessmentOptionListWithImageUploaderView.swift
│   │   ├── SharedAssessmentOptionAsImageView.swift
│   │   ├── SharedAssessmentSubjectiveView.swift
│   │   └── SharedAssessmentSubjectiveWithImageUploderView.swift
│   ├── BottomControl/
│   │   ├── SharedAssessmentBottomControlView.swift  // ← main bottom bar
│   │   ├── SharedAssessmentBottomSegmentControl.swift
│   │   ├── SharedAssessmentSegmentControlView.swift // internal
│   │   ├── SharedAssessmentSegmentListView.swift    // internal
│   │   └── SharedAssessmentSegmentItemView.swift    // internal
│   └── ImageUploader/
│       ├── ImageUploaderView.swift                  // iOS 16+
│       └── ImageUploaderViewModel.swift             // iOS 16+
```

---

## Quick-Start Usage

### Composing a question screen

```swift
import AssessmentKit

struct QuestionView: View {
    let question: MyQuestionModel   // your domain model
    @State private var answer = ""

    var body: some View {
        VStack(spacing: 16) {

            // 1. Header — question type label + question text
            SharedAssessmentHeaderView(
                contentType: question.contentType.displayName,
                questionText: AttributedString(question.text)
            )

            // 2. Media preview (video / audio / image) — nil-safe
            SharedAssessmentPreviewType(
                contentType: question.contentType,
                resourceURL: question.mediaURL,
                onZoomTap: { url in
                    // Push your zoomable image view here
                }
            )

            // 3. Answer input — auto-routes to the correct child view
            SharedAssessmentSelectionTypeView(
                contentType: question.contentType,
                options: question.options.map { OptionModel(title: $0.text) },
                isSelected: { option in answer == option.title },
                getTitle: { $0.title },
                handleSelection: { option in answer = option.title }
            )

            Spacer()

            // 4. Bottom navigation bar
            SharedAssessmentBottomControlView<Int32>(
                currentQuestionIndex: currentIndex,
                totalQuestions: totalCount,
                isFirstQuestion: currentIndex == 0,
                isLastQuestion: currentIndex == totalCount - 1,
                goToPreviousQuestion: { currentIndex -= 1 },
                goToNextQuestion:     { currentIndex += 1 },
                submitAssessment:     { submitExam() }
            )
        }
        .padding()
    }
}
```

---

## Key Design Decisions

### `SharedAssessmentOptionModel` typealias

All views reference `SharedAssessmentOptionModel`. This is a `typealias` for `OptionModel` defined in `OptionModel.swift`. If you need to use your own model, conform it to `AssessmentOptionProtocol` and update the typealias — no view call-sites change.

```swift
// OptionModel.swift
public typealias SharedAssessmentOptionModel = OptionModel   // swap here only
```

### `AssessmentImagePreviewView` — router kept as-is

The view retains `@Environment(\.router)` and `NavigationService` — these are provided by a peer package that `AssessmentKit` depends on. The only change from the original is fixing the naming collision bug (the private computed property was named identically to the struct, causing `body` to call itself recursively).

### Stubs — two views to replace

`AssessmentStubs.swift` contains functional but placeholder implementations of:

| Stub | Used by | Replace with |
|---|---|---|
| `AssessmentImageSelection` | `SharedAssessmentOptionAsImageView` | Your real image-grid view |
| `EmojiFeedbackView` | `SharedAssessmentSelectionTypeView` | Your real emoji-rating view |

Once you have the real files, delete `AssessmentStubs.swift` and add the real implementations to `Sources/AssessmentKit/Stubs/` (or wherever fits your layout). No other files need changing.

### `ImageUploaderView` / `ImageUploaderViewModel` — iOS 16+ gated

Both are marked `@available(iOS 16.0, *)`. All call-sites wrap them in `if #available(iOS 16.0, *)` blocks, so the package compiles cleanly on iOS 15.

---

## Adding a New Target (Multi-Tenant)

Because the package is entirely data-driven through closures and `ContentType`, onboarding a new tenant requires zero package changes — just pass different data from the host app.

---

## Roadmap / TODOs

- [ ] Replace `AssessmentImageSelection` stub with real implementation
- [ ] Replace `EmojiFeedbackView` stub with real implementation
- [ ] Add unit tests for `ContentType` custom decoder edge cases
- [ ] Add unit tests for `SharesAssessmentBottomSegmentDataModel` color-state resolution
- [ ] Swift 6 strict concurrency audit for `ImageUploaderViewModel`
