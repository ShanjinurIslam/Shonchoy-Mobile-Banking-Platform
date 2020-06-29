class Agent {
  final String businessOrganizationName;
  final String mobileNo;
  final String authToken;

  Agent(this.businessOrganizationName, this.mobileNo, this.authToken);

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
        json['businessOrganizationName'], json['mobileNo'], json['authToken']);
  }
}
