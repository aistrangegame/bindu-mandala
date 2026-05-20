import SwiftUI

struct ClusterDotView: View {
    let cluster: Cluster
    var size: CGFloat = 7

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(cluster.color)
                .frame(width: size, height: size)
                .shadow(color: cluster.color, radius: 4)
            Text(cluster.label.uppercased())
                .font(.system(size: 10.5, weight: .regular))
                .tracking(2.0)
                .foregroundStyle(cluster.color)
        }
    }
}
