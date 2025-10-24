// SunDialWidgetView.swift
import SwiftUI
import WidgetKit

struct SunDialWidgetEntryView: View {
    var entry: SunDialProvider.Entry

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let sideInset = geo.size.width * 0.010
            VStack(alignment: .leading, spacing: 6) {
                // Top row: current time + title
                HStack(alignment: .center) {
                    Text(entry.date, style: .time)
                        .font(.system(size: h * 0.26, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                    Text("SunDial")
                        .font(.system(size: h * 0.19, weight: .semibold))
                        .foregroundColor(.orange)
                }

                // Solar Arc Visualization + sunrise/sunset
                VStack(spacing: h * 0.02) {
                    SolarArcView(entry: entry)
                        .frame(height: h * 0.34)
                        .frame(maxWidth: .infinity)

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "sunrise.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: h * 0.13))
                            Text(entry.sunrise, style: .time)
                                .font(.system(size: h * 0.13))
                                .foregroundColor(.white.opacity(0.85))
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Text(entry.sunset, style: .time)
                                .font(.system(size: h * 0.13))
                                .foregroundColor(.white.opacity(0.85))
                            Image(systemName: "sunset.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: h * 0.13))
                        }
                    }
                }

                // Bottom label
                Text("Solar Arc")
                    .font(.system(size: h * 0.10))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, sideInset)
            .padding(.vertical, h * 0.025)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.3),
                        Color(red: 0.05, green: 0.1, blue: 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct SolarArcView: View {
    let entry: SunDialEntry

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background arc
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: geometry.size.height)

                // Gradient progress arc
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.orange, .yellow, .white, .orange, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * entry.currentProgress)
                    Spacer(minLength: 0)
                }
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 2))

                // Current time indicator
                HStack {
                    Spacer()
                        .frame(width: max(0, geometry.size.width * entry.currentProgress - 1))

                    Rectangle()
                        .fill(Color.black)
                        .frame(width: max(2, geometry.size.height * 0.10),
                               height: geometry.size.height * 1.1)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

