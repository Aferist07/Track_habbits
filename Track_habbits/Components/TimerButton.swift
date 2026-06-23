import SwiftUI


struct TimerButton: View {
    var isOn: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
///большой круглый белый фон
                Circle()
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                    .shadow(color: .black.opacity(0.12), radius: 18, y: 7)

///градиентная обводка
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: isOn
                                ? [Color.red, Color.orange, Color.pink, Color.red]
                                : [Color.green, Color.teal, Color.blue, Color.green]
                            , startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 250, height: 250)

///градиентный текст
                Text(isOn ? "СТОП" : "СТАРТ")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isOn
                                ? [Color.red, Color.orange, Color.pink, Color.red]
                                : [Color.green, Color.teal, Color.blue, Color.green],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 2, y: 1)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isOn ? 1.03 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isOn)
        .accessibilityLabel(isOn ? "Остановить" : "Запустить")
    }
}





#Preview {
    ContentView()
}
