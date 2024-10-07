class GoldConverter {
  // Convert 18k to 21k equivalent
  double convert18kTo21k(double weight18k) {
    return weight18k * (6 / 7);
  }

  // Convert 21k to 24k equivalent
  double convert21kTo24k(double weight21k) {
    return weight21k * (21 / 24);
  }

  // Convert 24k to 21k equivalent
  double convert24kTo21k(double weight24k) {
    return weight24k * (24 / 21);
  }

  // Convert 24k to 18k equivalent
  double convert24kTo18k(double weight24k) {
    return convert24kTo21k(weight24k) * (7 / 6);
  }

  // Convert 21k to 18k equivalent
  double convert21kTo18k(double weight21k) {
    return weight21k * (7 / 6);
  }

  // Convert 18k to 24k equivalent
  double convert18kTo24k(double weight18k) {
    return weight18k * (24 / 18);
  }
}
