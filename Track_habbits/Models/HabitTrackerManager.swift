import Foundation
import SwiftUI
import Combine

// --------- ЛОГИКА: ХРАНИТ ВСЕ ТРЕКЕРЫ ---------
class HabitTrackerManager: ObservableObject {
    @Published var trackers: [HabitTracker] = [] // Все трекеры
    @Published var selectedTrackerID: UUID?      // id выбранного трекера
    @Published var showTrackersList: Bool = false // Показать список трекеров (для анимации)

    private var timerCancellable: AnyCancellable? // Для тиков времени

    init() {
        // Автоматический тик каждую секунду, чтобы обновлять вьюшки
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }

    // Добавить новый трекер/таймер
    func addTracker(name: String, preset: WallpaperPreset) {
        let tracker = HabitTracker(name: name, preset: preset, startDate: nil, isOn: false)
        trackers.append(tracker)
        selectedTrackerID = tracker.id
    }

    // Запустить таймер для выбранного трекера
    func startTracker(_ tracker: HabitTracker) {
        updateTracker(tracker.id) { t in
            t.isOn = true
            t.startDate = Date().timeIntervalSince1970
        }
    }

    // Остановить таймер для выбранного трекера
    func stopTracker(_ tracker: HabitTracker) {
        updateTracker(tracker.id) { t in
            t.isOn = false
            t.startDate = nil
        }
    }

    // Выбрать трекер
    func selectTracker(_ tracker: HabitTracker) {
        selectedTrackerID = tracker.id
    }

    // Получить выбранный трекер
    var selectedTracker: HabitTracker? {
        trackers.first(where: { $0.id == selectedTrackerID })
    }

    // Хелпер для мутабельного изменения по id
    private func updateTracker(_ id: UUID, mutate: (inout HabitTracker) -> Void) {
        guard let idx = trackers.firstIndex(where: { $0.id == id }) else { return }
        mutate(&trackers[idx])
    }
}
