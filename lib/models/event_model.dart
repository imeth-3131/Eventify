class EventModel {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;
  final int registrationCount;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.registrationCount,
  });

  factory EventModel.fromMap(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: (data['title'] ?? '') as String,
      date: (data['date'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      registrationCount: (data['registrationCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'registrationCount': registrationCount,
    };
  }
}
