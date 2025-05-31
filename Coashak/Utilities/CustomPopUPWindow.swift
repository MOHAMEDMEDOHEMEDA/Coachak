////
////  CustomPopUPWindow.swift
////  Coashak
////
////  Created by Mohamed Magdy on 14/12/2024.
////
//
//
//import SwiftUI
//
//struct CustomPopUPWindow: View {
//    let title: String
//    @State private var navigateToTraineeDetailView = false
//    @State private var navigateToTrainerDetailView = false
//    
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // Header with Close and Confirm Buttons
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title3)
//                        .foregroundColor(Color.purple)
//                }
//
//                Spacer()
//
//                Text(title)
//                    .font(.title3)
//                    .bold()
//                    .foregroundColor(Color.purple)
//
//                Spacer()
//                
//                EmptyView()
//
//            
//
//            }
//            .padding(.horizontal)
//
//            // Button Selection Section (Trainer vs Trainee)
//            HStack(spacing: 20) {
//                Button(action: {
//                    navigateToTrainerDetailView = true
//                }) {
//                    Text("Trainer")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 120, height: 40)
//                        .background(Color.colorPurple)
//                        .cornerRadius(8)
//                        .shadow(radius: 5)
//                }
//
//                Button(action: {
//                    navigateToTraineeDetailView = true
//                }) {
//                    Text("Trainee")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 120, height: 40)
//                        .background(Color.colorMidPink)
//                        .cornerRadius(8)
//                        .shadow(radius: 5)
//                }
//            }
//            .padding(.top)
//
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(radius: 10)
//        .frame(maxWidth: 350)
//        .opacity(0.95)  // Make the background slightly transparent to emphasize the popup
//        .animation(.easeInOut(duration: 0.3)) // Add smooth animation when the popup appears
//        .navigationDestination(isPresented: $navigateToTraineeDetailView) {
//            TraineeDataView()
//        }
//        .navigationDestination(isPresented: $navigateToTrainerDetailView) {
//             TrainerDetailView() // Add your trainer destination view here
//        }
//    }
//}
//
//struct CustomPopUPWindow_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPopUPWindow(title: "Please Choose")
//            .previewLayout(.sizeThatFits)
//    }
//}
