import Foundation
import SwiftUI

struct HabitTracker: Identifiable, Codable {

    let id: UUID

    var presetName: String
    var startDate: Double?
    var isOn: Bool

    init(
        id: UUID = UUID(),
        presetName: String,
        startDate: Double? = nil,
        isOn: Bool = false
    ) {
        self.id = id
        self.presetName = presetName
        self.startDate = startDate
        self.isOn = isOn
    }

    var totalSeconds: Int {

        guard isOn, let start = startDate else {
            return 0
        }

        return Int(Date().timeIntervalSince1970 - start)
    }

    var preset: WallpaperPreset {

        WallpaperPreset.allPresets.first {
            $0.presetName == presetName
        } ?? .blank
    }
}
