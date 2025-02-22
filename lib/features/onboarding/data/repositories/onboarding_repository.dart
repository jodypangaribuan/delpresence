import '../../domain/models/onboarding_content.dart';

class OnboardingRepository {
  List<OnboardingContent> getOnboardingContents() {
    return const [
      OnboardingContent(
        title: "Quick & Easy Attendance",
        image: "assets/images/image1.png",
        desc:
            "Mark your attendance with just one tap. No more queues or paper registers.",
      ),
      OnboardingContent(
        title: "Real-time Tracking",
        image: "assets/images/image2.png",
        desc:
            "Keep track of your attendance records instantly. Stay updated with your attendance percentage.",
      ),
      OnboardingContent(
        title: "Smart Notifications",
        image: "assets/images/image3.png",
        desc:
            "Get timely reminders for classes and alerts about your attendance status.",
      ),
    ];
  }
}
