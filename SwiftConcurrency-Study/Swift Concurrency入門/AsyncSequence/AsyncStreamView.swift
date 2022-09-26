//
//  AsyncStreamView.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/17.
//

import SwiftUI

struct AsyncStreamView: View {

    @StateObject private var locationManager: LocationManager

    init() {
        self._locationManager = StateObject(wrappedValue: LocationManager())
    }


    var body: some View {
        VStack {
            Text("緯度:\(locationManager.coordinator.latitude)\n軽度:\(locationManager.coordinator.longitude)")
                .font(.largeTitle)

            List {
                Button {
                    locationManager.startLocation()
                } label: {
                    Text("位置情報読み取り開始")
                }

                Button {
                    locationManager.asyncStreamTask = Task {
                        for await coordinate in locationManager.locations {
                            print(coordinate)
                        }
                    }
                } label: {
                    Text("AsyncStreamを使う")
                }

                Button {
                    locationManager.asyncThrowingStreamTask = Task {
                        do {
                            for try await coordinate in locationManager.locationWithError {
                                print(coordinate)
                            }
                        } catch {
                            print("Error: ", error.localizedDescription)
                        }
                    }
                } label: {
                    Text("AsyncThrowingStreamを使う")
                }
            }
        }
        .alert(Text("位置情報を許可してください"), isPresented: $locationManager.showAuthorizationAlert) {
            Button("OK") {}
        }
        .onAppear {
            locationManager.setup()
        }
        .onDisappear {
            locationManager.cleanup()
        }
    }
}

//struct AsyncStream_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncStream()
//    }
//}
