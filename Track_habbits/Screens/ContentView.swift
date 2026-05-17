//
//  ContentView.swift
//  Track_habbits
//
//  Created by Егор Ерохин on 11/12/2025.
//

import SwiftUI
import Combine

struct ContentView: View {

    @State private var totalSec = 0
    @State private var isOn = false

    @State private var selectedPreset = WallpaperPreset.blank

    @State private var showWelcomePopup = true

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

    var body: some View {
        NavigationStack {
            ZStack {

                EmojiWallpaperView(
                    preset: selectedPreset
                )

                VStack {

                    Text("Дней без \(selectedPreset.presetName)")
                        .font(.system(size: 50))
                        .foregroundStyle(selectedPreset.textColor)
                        .fontDesign(Font.Design.rounded)
                        .bold()

                    TimerText(
                        selectedPreset: selectedPreset, timeString: timeString
                    )

                    // --- Градиентная кнопка "Старт/Стоп" с градиентом на тексте и обводке ---
                    TimerButton(isOn: isOn) {
                        if isOn {
                            isOn = false
                            totalSec = 0
                            startDate = 0
                        } else {
                            isOn = true
                            startDate = Date().timeIntervalSince1970
                        }
                    }
                    .padding(.vertical, 32)
                    // -------------------------------------------------------------------------
                    
                    /*
                    // --- СТАРАЯ КНОПКА СТАРТ/СТОП ---
                    // TimerButton(
                    //     isOn: isOn
                    // ) {
                    //     if isOn {
                    //         isOn = false
                    //         totalSec = 0
                    //         startDate = 0
                    //     } else {
                    //         isOn = true
                    //         startDate = Date().timeIntervalSince1970
                    //     }
                    // }
                    // ---------------------------------
                    */

                    if isOn {
                        Text("Так держать!")
                            .font(.system(size: 50))
                            .foregroundStyle(selectedPreset.textColor)
                            .fontDesign(Font.Design.rounded)
                            .bold()
                    }
                }

                if showWelcomePopup {

                    Color.black
                        .opacity(0.6)
                        .ignoresSafeArea()

                    WelcomePopupView { preset in

                        selectedPreset = preset //меняет пресет

                        showWelcomePopup = false // закрывает попап
                    }
                }
            }
            .onReceive(timer) { _ in

                if isOn {

                    totalSec = Int(
                        Date().timeIntervalSince1970 - startDate
                    )
                }
            }
            .onAppear {

                if startDate > 0 {

                    isOn = true

                    totalSec = Int(
                        Date().timeIntervalSince1970 - startDate
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // --- Бургер-меню в правом верхнем углу ---
                    Menu {
                        // Эта кнопка вызывает попап выбора привычки
                        Button("Изменить привычку") {
                            showWelcomePopup = true
                        }
                        // Добавляйте сюда новые кнопки по аналогии:
                        // Button("Другая опция") { ... }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                            .accessibilityLabel("Меню")
                    }
                    // ----------------------------------------
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

/*
// --- СТАРЫЙ КОМПОНЕНТ ДЛЯ КНОПКИ СТАРТ/СТОП ---
struct TimerButton: View {

    let isOn: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(alignment: .center) {

                VStack {

                    ZStack {

                        Circle()
                            .frame(width: 250, height: 250)
                            .foregroundStyle(
                                isOn ? .red : .green
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color(.clear), lineWidth: 5)
                                            //Color(red: 0.486, green: 0.125, blue: 0.137) :
                                            //Color(red: 0.1137, green: 0.5176, blue: 0.2157),
                                            //lineWidth: 3)
                                    .blur(radius: 5))
                            .shadow(radius: 5)

                        Text(isOn ? "STOP" : "START")
                            .foregroundStyle(isOn ?
                                             Color(red: 0.486, green: 0.125, blue: 0.137) :
                                             Color(red: 0.1137, green: 0.5176, blue: 0.2157))
                            .blur(radius: 0.5)
                            .fontWeight(.bold)
                            .font(.system(size: 50))
                            .fontDesign(Font.Design.rounded)
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
*/
