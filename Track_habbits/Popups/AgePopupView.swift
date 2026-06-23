import SwiftUI

struct AgePopupView: View {

    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {

        ZStack {

            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Text("Вам есть 18 лет?")
                    .font(.largeTitle)
                    .bold()
                    .fontDesign(.rounded)

                Text("Это приложение предназначено только для лиц старше 18 лет.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                VStack(spacing: 14) {

                    Button {

                        onAccept()

                    } label: {

                        Text("Да")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .cornerRadius(14)
                    }

                    Button {

                        onDecline()

                    } label: {

                        Text("Нет")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .cornerRadius(14)
                    }
                }
            }
            .padding(30)
            .background(.white)
            .cornerRadius(30)
            .shadow(radius: 30)
            .padding(40)
        }
    }
}
