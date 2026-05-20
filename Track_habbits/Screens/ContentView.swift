import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var manager = HabitTrackerManager()
    @State private var showWelcomePopup = false
    @State private var showStopConfirmation = false
    @State private var showReasonSheet = false
    @State private var stopReasonText = ""
    @State private var trackerToStop: HabitTracker?
    @State private var showHistory = false
    @State private var showAchievements = false

    var body: some View {
        NavigationStack {
            ZStack {
                if let tracker = manager.selectedTracker {
                    EmojiWallpaperView(preset: tracker.preset)
                } else {
                    Color(.systemGray6).ignoresSafeArea()
                }

                VStack {
                    if let tracker = manager.selectedTracker {
                        Text("Дней без \(tracker.preset.presetName)")
                            .font(.system(size: 34))
                            .foregroundStyle(tracker.preset.textColor)
                            .fontDesign(.rounded)
                            .bold()
                            .padding(.bottom, 12)

                        Text(timeString(for: tracker))
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundStyle(tracker.preset.textColor)
                            .fontDesign(.rounded)

                        TimerButton(
                            isOn: tracker.isOn
                        ) {
                            if tracker.isOn {
                                trackerToStop = tracker
                                showStopConfirmation = true
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

                if manager.showTrackersList {
                    TrackersListView(
                        manager: manager,
                        onDelete: { tracker in
                            trackerToStop = tracker
                            showStopConfirmation = true
                        }
                    )
                    .zIndex(1)
                    .animation(.spring(response: 0.45, dampingFraction: 0.75), value: manager.showTrackersList)
                }

                if showWelcomePopup {
                    WelcomePopupView(
                        usedPresets: manager.trackers.map { $0.preset },
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
                    Menu {
                        Button("Мои трекеры") {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                manager.showTrackersList = true
                            }
                        }
                        Button("Добавить привычку") {
                            showWelcomePopup = true
                        }
                        Button("История") {
                            showHistory = true
                        }
                        Button("Достижения") { // Новый пункт
                            showAchievements = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                            .accessibilityLabel("Меню")
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                HistoryView(manager: manager)
            }
            .sheet(isPresented: $showAchievements) { // new sheet
                AchievementsView(manager: manager)
            }
            .alert("Вы уверены?", isPresented: $showStopConfirmation, actions: {
                Button("Да", role: .destructive) {
                    showReasonSheet = true
                }
                Button("Нет", role: .cancel) { }
            }, message: {
                Text("Причина рецидива будет сохранена в истории. Продолжить?")
            })
            .sheet(isPresented: $showReasonSheet, onDismiss: {
                stopReasonText = ""
            }) {
                VStack(spacing: 24) {
                    Text("Причина рецидива?")
                        .font(.title2)
                        .bold()
                    TextField("можно не заполнять", text: $stopReasonText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .opacity(0.7)
                        .padding(.horizontal)
                    HStack(spacing: 20) {
                        Button("Подтвердить") {
                            if let tracker = trackerToStop {
                                manager.finishTracker(tracker, reason: stopReasonText)
                                stopReasonText = ""
                                trackerToStop = nil
                                showReasonSheet = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Отмена") {
                            stopReasonText = ""
                            trackerToStop = nil
                            showReasonSheet = false
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .presentationDetents([.medium])
            }
        }
    }

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
