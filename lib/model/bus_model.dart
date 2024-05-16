class BusModel {
  String uid;
  String ownerName;
  String busName;
  String registrationNumber;
  int mobileNumber;

  BusModel(
      {required this.busName,
      required this.mobileNumber,
      required this.ownerName,
      required this.registrationNumber,
      required this.uid});
}
