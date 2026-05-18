import Foundation
import SwiftUI
import Combine

class HabitTrackerManager: ObservableObject {

    @Published var trackers: [HabitTracker] = [] //все трекеры
    @Published var selectedTrackerID: UUID?      //айди выбранного трекера
    @Published var showTrackersList: Bool = false //показать список трекеров

    private var timerCancellable: AnyCancellable? //для тиков времени

    init() {
///обновление каждую секунду для таймеров
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }

///добавить новый трекер для выбранного пресета
    func addTracker(with preset: WallpaperPreset) {
///не добавлять если такой уже есть
        guard !trackers.contains(where: { $0.preset.presetName == preset.presetName }) else { return }
        let tracker = HabitTracker(
            preset: preset,
            startDate: nil,
            isOn: false
        )
        trackers.append(tracker)
        selectedTrackerID = tracker.id
    }

///старт трекера
    func startTracker(_ tracker: HabitTracker) {
        updateTracker(tracker.id) { t in
            t.isOn = true
            t.startDate = Date().timeIntervalSince1970
        }
    }

///остановить и удалить трекер
    func deleteTracker(_ tracker: HabitTracker) {
        // Если выбранный удаляется, сбросить выбор
        if selectedTrackerID == tracker.id {
            selectedTrackerID = nil
        }
        trackers.removeAll { $0.id == tracker.id }
    }

///выбрать трекер
    func selectTracker(_ tracker: HabitTracker) {
        selectedTrackerID = tracker.id
    }

    var selectedTracker: HabitTracker? {
        trackers.first(where: { $0.id == selectedTrackerID })
    }

    private func updateTracker(_ id: UUID, mutate: (inout HabitTracker) -> Void) {
        guard let idx = trackers.firstIndex(where: { $0.id == id }) else { return }
        mutate(&trackers[idx])
    }
}
