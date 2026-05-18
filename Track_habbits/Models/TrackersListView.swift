import SwiftUI

// --------- ВИЗУАЛЬНАЯ ЧАСТЬ: СПИСОК ТРЕКЕРОВ С АНИМАЦИЕЙ ---------
struct TrackersListView: View {
    @ObservedObject var manager: HabitTrackerManager // Логика

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        manager.showTrackersList = false // Скрыть список по тапу вне
                    }
                }

            VStack(spacing: 0) {
                Text("Мои трекеры") // Имя — заглушка
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(manager.trackers) { tracker in
                            Button {
                                // Открыть трекер на главном экране
                                manager.selectTracker(tracker)
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                    manager.showTrackersList = false
                                }
                            } label: {
                                HStack {
                                    Text(tracker.name)
                                        .font(.title2)
                                    Text(tracker.preset.presetName)
                                    Spacer()
                                    if tracker.isOn {
                                        Text("⏱")
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(14)
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white)
                    .shadow(radius: 18, y: 10)
            )
            .padding(40)
            .transition(.move(edge: .bottom).combined(with: .opacity)) // Интересный переход
        }
    }
}
