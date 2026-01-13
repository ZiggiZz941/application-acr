class AllureRange {
  final double minPourcentage;
  final double maxPourcentage;

  AllureRange(this.minPourcentage, this.maxPourcentage);
}

class AllureHelper {
  static AllureRange? getAllureRange(int selectedPosition) {
    switch (selectedPosition) {
      case 1: // Allure 1
        return AllureRange(60, 70);
      case 2: // Allure 2
        return AllureRange(70, 80);
      case 3: // Allure 3
        return AllureRange(80, 85);
      case 4: // Allure 4
        return AllureRange(85, 90);
      case 5: // Allure 5
        return AllureRange(90, 95);
      case 6: // Allure VMA
        return AllureRange(100, 100);
      default:
        return null;
    }
  }
}
