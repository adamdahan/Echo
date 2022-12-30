//
//  PackageView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PackageView: View {

    let index: Int
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Text("")
                    .frame(height: 20)
                PackageHTTPMethod(package: package)
                PackageDates(package: package)
                PackageRequestHeaders(package: package)
                PackageResponseHeaders(package: package)
                if package.request.method.lowercased() == "post" {
                    PackageBody(package: package)
                }
                PackageResponse(package: package)
                PackageResponseSize(package: package)
            }.padding([.top, .bottom], 10)
        }
        .navigationBarTitle("\(index)")
    }
}
