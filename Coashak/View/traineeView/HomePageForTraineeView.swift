//
//  HomePageForTraineeView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 20/01/2025.
//

import SwiftUI

// MARK: - TrainerCardView
struct TrainerCardView: View {
    var imageName: String
    var name: String
    var description: String
    var rating: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding(6)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(8)
            }
            
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("View")
                        .foregroundColor(Color.colorPink)
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color(red: 0.73, green: 0.36, blue: 0.36))
                }
            }

            
        }
        .padding()
        .frame(width: 320, height: 280)
        .background(Color.white)
        .shadow(radius: 0.3)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
}

// MARK: - HomePageTraineeView
struct HomePageTraineeView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack {
                        Text("Train Your Body,")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.colorPink)
                        Text("Transform Your Mind")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    TextField("Search", text: .constant(""))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    HStack {
                        Image("icon_1")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Explore Our Programs")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    AutoScrollingProgramListView(samplePrograms: samplePrograms)

                    
                    HStack {
                        Image("icon_2")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Meet Our Trainers")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(mockTrainerProfiles) { trainer in
                                TrainerCardView(
                                    imageName: trainer.profileImageName,
                                    name: trainer.name,
                                    description: trainer.bio,
                                    rating: trainer.rating
                                )
                            }
                        }
                    }
                    
                    HStack {
                        Image("icon_3")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Personalized Meal Plan")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Craft your ideal meal plan tailored to your goals. Available to all Coachak members.")
                                .multilineTextAlignment(.leading)
                            NavigationLink(destination: MealPlanFormView()) {
                                Text("Create Plan")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(colors: [Color.colorPink, Color.white],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                    )
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        Image("personalizedMealplanImage")
                            .resizable()
                            .frame(width: 180, height: 180)
                    }
                    //.frame(width: 343, height: 180, alignment: .center)
                    HStack {
                        Image(systemName: "message.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Our AI Assistance")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    FitBotAssistantCard()
                }
                .padding()
            }
        }
        .padding(.bottom,85)
        .navigationBarBackButtonHidden()
    }
    
}

struct AutoScrollingProgramListView: View {
    let samplePrograms: [Program] // Your model
    @State private var currentIndex = 0

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(samplePrograms.enumerated()), id: \.1.title) { index, program in
                        ProgramCardView(program: program)
                            .id(index) // 👈 assign unique id for scrolling
                    }
                }
            }
            .onAppear {
                startAutoScroll(proxy: proxy)
            }
        }
    }

    private func startAutoScroll(proxy: ScrollViewProxy) {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            withAnimation {
                proxy.scrollTo(currentIndex, anchor: .center)
            }

            currentIndex += 1
            if currentIndex >= samplePrograms.count {
                currentIndex = 0 // loop back to start
            }
        }
    }
}


// MARK: - ProgramCardView
struct ProgramCardView: View {
    let program: Program
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(program.icon)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(program.title)
                .font(.title3)
                .bold()
            
            Text(program.description)
                .font(.body)
                .lineLimit(nil)
            
            Spacer()
            
            HStack {
                Spacer()
                NavigationLink(destination: TrainersTraineeView()) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.colorPink, Color.colorPurple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .frame(width: 220, height: 240)
        .background(Color(red: 0.73, green: 0.36, blue: 0.36))
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

// MARK: - Sample Data
struct Program {
    var icon: String
    var title: String
    var description: String
}

let samplePrograms: [Program] = [
    Program(icon: "fitness_icon", title: "Fitness", description: "Build strength, improve endurance, and enhance flexibility."),
    Program(icon: "cardio_icon", title: "Cardio", description: "Boost your stamina and burn calories."),
    Program(icon: "weight_gain_icon", title: "Weight Gain", description: "Gain muscle with personalized training."),
    Program(icon: "weight_loss_icon", title: "Weight Loss", description: "Achieve sustainable results with nutrition and workouts."),
    Program(icon: "yoga_icon", title: "Yoga", description: "Increase flexibility and reduce stress."),
    Program(icon: "gym_icon", title: "Gymnastics", description: "Coordination, strength, and flexibility."),
    Program(icon: "str_icon", title: "Strength", description: "Increase muscle mass and metabolism."),
    Program(icon: "ryh_icon", title: "Rhythmic Activities", description: "Blend dance and fitness for fun.")
]

let mockTrainerProfiles: [TrainerProfile] = [
    TrainerProfile(
        name: "Mohamed Magdy",
        bio: "Certified strength coach with 5+ years of experience helping clients build muscle and confidence.",
        email: "mohamed@example.com",
        experienceYears: 5,
        subscribers: "1.2K",
        certifications: ["NASM", "CrossFit L1"],
        availability: ["Mon": true, "Tue": true, "Wed": true, "Thu": true, "Fri": true, "Sat": false, "Sun": false],
        rating: 4.8,
        reviews: [
            Review(reviewerName: "Ahmed", rating: 5, comment: "Great trainer! Very motivating."),
            Review(reviewerName: "Laila", rating: 4, comment: "Helped me a lot with my form.")
        ],
        profileImageName: "edited_profile_upwork",
        specialties: ["Strength Training", "Muscle Gain"]
    ),
    TrainerProfile(
        name: "Yousef Ayman",
        bio: "Cardio and fat-loss expert with a personalized approach to every client.",
        email: "yousef@example.com",
        experienceYears: 4,
        subscribers: "980",
        certifications: ["ACE", "CPR Certified"],
        availability: ["Mon": false, "Tue": false, "Wed": false, "Thu": false, "Fri": false, "Sat": true, "Sun": true],
        rating: 4.5,
        reviews: [
            Review(reviewerName: "Nora", rating: 4, comment: "Saw results in just 3 weeks."),
            Review(reviewerName: "Karim", rating: 5, comment: "Very professional and friendly.")
        ],
        profileImageName: "yousef_pic",
        specialties: ["Cardio", "Fat Loss"]
    ),
    TrainerProfile(
        name: "Sara Tarek",
        bio: "Yoga instructor with a passion for mental and physical wellness.",
        email: "sara@example.com",
        experienceYears: 6,
        subscribers: "2.1K",
        certifications: ["RYT 500", "Mindfulness Coach"],
        availability: ["Mon": true, "Wed": true, "Fri": true],
        rating: 4.9,
        reviews: [
            Review(reviewerName: "Huda", rating: 5, comment: "Her sessions are so relaxing."),
            Review(reviewerName: "Ali", rating: 5, comment: "Improved my flexibility a lot.")
        ],
        profileImageName: "coach_pic",
        specialties: ["Yoga", "Mindfulness"]
    ),
    TrainerProfile(
        name: "Omar Elshayeb",
        bio: "Bodybuilding trainer focused on hypertrophy and nutrition balance.",
        email: "omar@example.com",
        experienceYears: 7,
        subscribers: "1.5K",
        certifications: ["ISSA", "Nutrition Coach"],
        availability: ["Mon": true, "Tue": true, "Wed": true, "Thu": true, "Fri": true, "Sat": true, "Sun": true],
        rating: 4.7,
        reviews: [
            Review(reviewerName: "Mostafa", rating: 5, comment: "Knows his stuff! Gained 6kg muscle."),
            Review(reviewerName: "Rania", rating: 4, comment: "Pushes you to your limits.")
        ],
        profileImageName: "yousef_pic",
        specialties: ["Bodybuilding", "Nutrition"]
    ),
    TrainerProfile(
        name: "Mona Khaled",
        bio: "Expert in postpartum fitness and rehab training for women.",
        email: "mona@example.com",
        experienceYears: 3,
        subscribers: "860",
        certifications: ["Prenatal & Postnatal Cert", "CPT"],
        availability: ["Tue": true, "Wed": true, "Thu": true],
        rating: 4.6,
        reviews: [
            Review(reviewerName: "Dina", rating: 5, comment: "Felt safe and supported post-baby."),
            Review(reviewerName: "Salma", rating: 4, comment: "Very understanding and kind.")
        ],
        profileImageName: "coach_pic",
        specialties: ["Postnatal Fitness", "Rehab"]
    )
]


import SwiftUI

struct TrainersTraineeView: View {
    @StateObject private var viewModel = TrainerForClientsViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
            VStack(spacing: 0) {
                // Top Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.colorPurple, Color.colorPink]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(70,corners: .bottomRight)
                .frame(height: 200)
                
                
                .overlay(
                    Text("Fitness Trainers")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 120)
                )

                ScrollView(.vertical, showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading Trainers...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if let trainers = viewModel.trainers {
                        LazyVStack(spacing: 20) {
                            ForEach(trainers) { trainer in
                                NavigationLink(destination: TrainerView(id: trainer.id)) {
                                    TrainerCardView(
                                        imageName: trainer.profilePhoto,
                                        name: "\(trainer.firstName) \(trainer.lastName)",
                                        description: "Avg Rating: \(trainer.avgRating)",
                                        rating: Double(trainer.avgRating) ?? 0.0
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    } else {
                        Text("No trainers found.")
                            .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.colorPink)
                    }
                    .foregroundStyle(Color.colorPurple)
                  
                }
            })
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                viewModel.fetchTrainers()
            }
       
        
    }
    
}

struct MealPlanTraineeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Personalized Meal Plan").font(.largeTitle).bold()
        }
        .padding()
    }
}
struct FitBotAssistantCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Assistant Item
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Circle()
                        .fill(Color.colorPurple)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image("Ai_icon")
                                .resizable()
                                .frame(width: 24, height: 24)
                        )
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("FitBot Assistant")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Ask me anything about fitness!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    
                }
                HStack{
                    VStack{
                        Text("Hi! I'm here to help with your fitness journey. Ask me about workouts, nutrition, or any health-related questions!")
                            .padding(.top, 8)
                            .padding(.bottom)
                        
                        NavigationLink(destination: ChatView()) {
                            Text("Start Chatting")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color.colorPurple, Color.white],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    Image("Ai_image")
                        .resizable()
                        .frame(width: 140, height: 140)
                }
//                .frame(width: 343, height: 240, alignment: .center)
                    
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}


#Preview {
    HomePageTraineeView()
}
