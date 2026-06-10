import SwiftUI

// MARK: - 设计系统（移植自 MathApex）：统一间距 / 圆角 / 字阶 / 卡片样式

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
}

enum Radius {
    static let chip: CGFloat = 8
    static let inner: CGFloat = 12
    static let card: CGFloat = 20
    static let hero: CGFloat = 24
}

enum AppFont {
    static let sectionTitle = Font.headline
    static let cardTitle = Font.subheadline.weight(.bold)
    static let body = Font.subheadline
    static let caption = Font.caption
    static let chip = Font.system(size: 11, weight: .semibold)
    static func bigStat(_ size: CGFloat = 30) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
}

extension View {
    func cardShadow() -> some View {
        shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    func cardSurface(padding: CGFloat = Spacing.xl) -> some View {
        self
            .padding(padding)
            .background(Color.apexCardSurface)
            .cornerRadius(Radius.card)
            .cardShadow()
    }
}

// MARK: - 流式布局（标签自动换行）

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }
        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}

// MARK: - 通用小组件

/// 段位 / 标签药丸
struct TagChip: View {
    let text: String
    var color: Color = .apexLava
    var body: some View {
        Text(text)
            .font(AppFont.chip)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

/// 区块标题
struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil
    var accent: Color = .apexLava
    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage).foregroundColor(accent)
            }
            Text(title).font(AppFont.sectionTitle)
            Spacer()
        }
    }
}
