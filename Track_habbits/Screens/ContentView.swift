import SwiftUI
import Combine

struct ContentView: View {

/// менеджер привычек
    @StateObject private var manager = HabitTrackerManager() // управляет всеми трекерами
    @State private var showWelcomePopup = false // показывает окно выбора пресета

    
/// старая логика, на всякий случай
/*
    @State private var totalSec = 0
    @State private var isOn = false
    @State private var selectedPreset = WallpaperPreset.blank
    @AppStorage("startDate")
    private var startDate = 0.0
    private let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    var timeString: String {
        let days = totalSec / 86400
        let hours = (totalSec % 86400) / 3600
        let minutes = (totalSec % 3600) / 60
        let secs = totalSec % 60
        return String(
            format: "%02d:%02d:%02d:%02d",
            days,
            hours,
            minutes,
            secs
        )
    }
    */

    var body: some View {
        NavigationStack {
            ZStack {
///пресет выбранного трекера
                if let tracker = manager.selectedTracker {
                    EmojiWallpaperView(preset: tracker.preset)
                } else {
                    Color(.systemGray6).ignoresSafeArea()
                }

                VStack {
///ник привычки и мини таймер
                    if let tracker = manager.selectedTracker {
                        Text(tracker.preset.presetName)
                            .font(.system(size: 72))
                            .padding(.top, 16)

                        Text("Дней без \(tracker.preset.presetName)")
                            .font(.system(size: 34))
                            .foregroundStyle(tracker.preset.textColor)
                            .fontDesign(.rounded)
                            .bold()
                            .padding(.bottom, 12)

///время трекера
                        Text(timeString(for: tracker))
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundStyle(tracker.preset.textColor)
                            .fontDesign(.rounded)

///СТАРТ/СТОП
                        TimerButton(
                            isOn: tracker.isOn
                        ) {
                            if tracker.isOn {
/// при остановке привычка удаляется
                                manager.deleteTracker(tracker)
                            } else {
                                manager.startTracker(tracker)
                            }
                        }
                        .padding(.vertical, 32)

                        if tracker.isOn {
                            Text("Так держать!")
                                .font(.system(size: 44))
                                .foregroundStyle(tracker.preset.textColor)
                                .fontDesign(.rounded)
                                .bold()
                        }
                    } else {
                        Text("Нет трекеров")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .padding(.vertical, 100)
                    }
                }

///СПИСОК ТРЕКЕРОВ
                if manager.showTrackersList {
                    TrackersListView(manager: manager)
                        .zIndex(1) // Поверх контента
                        .animation(.spring(response: 0.45, dampingFraction: 0.75), value: manager.showTrackersList)
                }

///попап для выбора новой привычки
                if showWelcomePopup {
                    WelcomePopupView(
                        usedPresets: manager.trackers.map { $0.preset }, //уже занятые пресеты
                        onPresetSelected: { preset in
                            manager.addTracker(with: preset)
                            showWelcomePopup = false
                        },
                        onCancel: {
                            showWelcomePopup = false
                        }
                    )
                    .zIndex(2)
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
///меню
                    Menu {
///кнопка с трекерами
                        Button("Мои трекеры") {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                manager.showTrackersList = true //показать список
                            }
                        }
///кнопка добавления
                        Button("Добавить привычку") {
                            showWelcomePopup = true //показать меню выбора
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                            .accessibilityLabel("Меню")
                    }
                }
            }
        }
    }

///вспомогательная функция для отображения времени трекера
    func timeString(for tracker: HabitTracker) -> String {
        let totalSec = tracker.totalSeconds
        let days = totalSec / 86400
        let hours = (totalSec % 86400) / 3600
        let minutes = (totalSec % 3600) / 60
        let secs = totalSec % 60
        return String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, secs)
    }
}

#Preview {
    ContentView()
}
