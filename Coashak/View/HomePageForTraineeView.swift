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
                NavigationLink(destination: TrainersTraineeView()) {
                    HStack(spacing: 4) {
                        Text("View")
                            .foregroundColor(Color.colorPink)
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color(red: 0.73, green: 0.36, blue: 0.36))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
        }
        .frame(width: 320, height: 280)
        .background(Color.white)
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(samplePrograms, id: \.title) { program in
                                ProgramCardView(program: program)
                            }
                        }
                    }
                    
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
                            Button("Create Plan") {}
                                .padding()
                                .background(LinearGradient(colors: [Color.colorPink, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Image("personalizedMealplanImage")
                            .resizable()
                    }
                    .frame(width: 343, height: 180, alignment: .center)
                }
                .padding()
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
        certifications: ["NASM", "CrossFit L1"],
        availability: "Mon–Fri: 8am–5pm",
        rating: 4.8,
        reviews: [
            Review(reviewerName: "Ahmed", rating: 5, comment: "Great trainer! Very motivating."),
            Review(reviewerName: "Laila", rating: 4, comment: "Helped me a lot with my form.")
        ],
        profileImageName: "edited_profile_upwork"
    ),
    TrainerProfile(
        name: "Yousef Ayman",
        bio: "Cardio and fat-loss expert with a personalized approach to every client.",
        email: "yousef@example.com",
        experienceYears: 4,
        certifications: ["ACE", "CPR Certified"],
        availability: "Weekends & Evenings",
        rating: 4.5,
        reviews: [
            Review(reviewerName: "Nora", rating: 4, comment: "Saw results in just 3 weeks."),
            Review(reviewerName: "Karim", rating: 5, comment: "Very professional and friendly.")
        ],
        profileImageName: "yousef_pic"
    ),
    TrainerProfile(
        name: "Sara Tarek",
        bio: "Yoga instructor with a passion for mental and physical wellness.",
        email: "sara@example.com",
        experienceYears: 6,
        certifications: ["RYT 500", "Mindfulness Coach"],
        availability: "Mon, Wed, Fri: 10am–2pm",
        rating: 4.9,
        reviews: [
            Review(reviewerName: "Huda", rating: 5, comment: "Her sessions are so relaxing."),
            Review(reviewerName: "Ali", rating: 5, comment: "Improved my flexibility a lot.")
        ],
        profileImageName: "coach_pic"
    ),
    TrainerProfile(
        name: "Omar Elshayeb",
        bio: "Bodybuilding trainer focused on hypertrophy and nutrition balance.",
        email: "omar@example.com",
        experienceYears: 7,
        certifications: ["ISSA", "Nutrition Coach"],
        availability: "Everyday: 9am–7pm",
        rating: 4.7,
        reviews: [
            Review(reviewerName: "Mostafa", rating: 5, comment: "Knows his stuff! Gained 6kg muscle."),
            Review(reviewerName: "Rania", rating: 4, comment: "Pushes you to your limits.")
        ],
        profileImageName: "yousef_pic"
    ),
    TrainerProfile(
        name: "Mona Khaled",
        bio: "Expert in postpartum fitness and rehab training for women.",
        email: "mona@example.com",
        experienceYears: 3,
        certifications: ["Prenatal & Postnatal Cert", "CPT"],
        availability: "Tues–Thurs: 11am–4pm",
        rating: 4.6,
        reviews: [
            Review(reviewerName: "Dina", rating: 5, comment: "Felt safe and supported post-baby."),
            Review(reviewerName: "Salma", rating: 4, comment: "Very understanding and kind.")
        ],
        profileImageName: "coach_pic"
    )
]


// MARK: - Other Views
struct TrainersTraineeView: View {
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [Color.colorPink,Color.colorCards,Color.colorPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: .infinity, height: 250)
                .clipShape(RoundedCorner(radius: 90,corners: .bottomRight))
                .ignoresSafeArea()
            
            Text("Fitness Trainers")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.leading,-130)

        }
      
            
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(mockTrainerProfiles) { trainer in
                    TrainerCardView(
                        imageName: trainer.profileImageName,
                        name: trainer.name,
                        description: trainer.bio,
                        rating: trainer.rating
                    )
                    .shadow(radius: 3)
                }
            }
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

struct TrainingPlanView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Training Schedule").font(.largeTitle).bold()
            HStack {
                ForEach(["Wed", "Thurs", "Fri", "Sat"], id: \.self) { day in
                    VStack {
                        Text(day)
                        Circle()
                            .fill(day == "Fri" ? Color.purple : Color.gray)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomePageTraineeView()
}
