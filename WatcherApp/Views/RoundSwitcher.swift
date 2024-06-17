//
//  RoundSwitcher.swift
//  WatcherApp
//
//  Created by macbook on 11.02.2024.
//

import SwiftUI

enum Option: String, CaseIterable {
    case option1 = "Option 1"
    case option2 = "Option 2"
    case option3 = "Option 3"
    case option4 = "Option 4"
    case option5 = "Option 5"
}

struct CustomView: View {
    @State private var selectedOption: Option = .option1
    @State private var switcherPosition: CGFloat = 0

    let circleRadius: CGFloat = 100
    let segmentCount: CGFloat = 5

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: circleRadius * 2, height: circleRadius * 2)

                ForEach(0..<Int(segmentCount)) { index in
                    segment(index: index)
                }

                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    //.offset(y: -circleRadius)
            }
            .padding()

            Text(selectedOption.rawValue)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()

            HStack(spacing: 0) {
                ForEach(Option.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .padding()
                        .background(selectedOption == option ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                selectedOption = option
                                switcherPosition = CGFloat(option.rawValue.count) * 10
                            }
                        }
                }
            }
        }
    }

    func segment(index: Int) -> some View {
        let angle = 360 / segmentCount * CGFloat(index)
        let startAngle = Angle(degrees: Double(angle))
        let endAngle = Angle(degrees: Double(angle + 360 / segmentCount))
        let startPoint = CGPoint(x: cos(startAngle.radians as Double) * circleRadius + circleRadius, y: sin(startAngle.radians) * circleRadius + circleRadius)
        let endPoint = CGPoint(x: cos(endAngle.radians as Double) * circleRadius + circleRadius, y: sin(endAngle.radians) * circleRadius + circleRadius)

        return Path { path in
            path.move(to: CGPoint(x: circleRadius, y: circleRadius))
            path.addLine(to: startPoint)
            path.addArc(center: CGPoint(x: circleRadius, y: circleRadius), radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.addLine(to: CGPoint(x: circleRadius, y: circleRadius))
        }
        .stroke(Color.gray, lineWidth: 2)
    }
}


#Preview {
    CustomView()
}
