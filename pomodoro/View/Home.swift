//
//  ContentView.swift
//  pomodoro
//
//  Created by 謝宇倫 on 2024/4/1.
//

import SwiftUI

struct CircularSector: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startPoint = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        
        return path
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                // Clock
                ZStack {
                    ForEach(0..<60,id: \.self) {i in
                        Rectangle()
                            .fill(Color(hex: 0x8d8989))
                        // 60/12 = 5
                            .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                            .offset(y: 160)
                            .rotationEffect(.init(degrees: Double(i) * 6))
                    }
                    
                    Circle()
                        .fill(Color(hex: 0xf2d0cf))
                        .frame(height: 230)
                    
                    CircularSector(startAngle: .degrees(0), endAngle: .degrees(pomodoroModel.timeRemaining / (60*60) * 360), radius: 115)
                        .fill(Color(hex: 0xe57b79))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                    //                        .shadow(radius: 10)
                    Circle()
                        .fill(Color(hex: 0xf9f0ef))
                        .frame(width: 65)
                        .shadow(radius: 5)
                    
                    Rectangle()
                        .fill(Color(hex: 0xee383a))
                        .frame(width: 10, height: 160)
                        .cornerRadius(.infinity)
                        .offset(y: 75)                        .rotationEffect(.degrees((pomodoroModel.timeRemaining / (60*60) * 360) + 180))
                        .shadow(color: Color(hex: 0xee383a, opacity: 0.8), radius: 5)
                    
                    Circle()
                        .fill(Color(hex: 0xfafafa))
                        .frame(width: 50)
                        .shadow(radius: 5)
                }
                .frame(maxWidth: 500)
                
                // Time
                Text(formattedTime())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .offset(y: 75)
                
                
                HStack {
                    Button {
                        pomodoroModel.isRunning.toggle()
                        if pomodoroModel.isRunning {
                            pomodoroModel.startTimer()
                        } else {
                            pomodoroModel.stopTimer()
                        }
                    } label: {
                        Image(systemName:
                                pomodoroModel.isRunning ? "stop.fill" : "play.fill")
                            .foregroundStyle(.foreground)
                            .frame(width: 50, height: 50)
                            .font(.largeTitle)
                            .offset(y: 40)
                            .padding()
                    }
                }

            }
            .padding(.horizontal, 30)
            .navigationTitle("What's your focus?")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
        
    private func formattedTime() -> String {
        let minutes = Int(pomodoroModel.timeRemaining) / 60
        let second = Int(pomodoroModel.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, second)
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroModel())
    }
}

