//
//  CornerRadiusStyle.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

    extension View {
        func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape(RoundedCorner(radius: radius, corners: corners))
        }
    }

    struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .topRight

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }


