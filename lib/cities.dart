//made with https://javiercbk.github.io/json_to_dart/

class cities {
  String? city;
  int? temperature;
  String? condition;
  String? icon;

  cities({this.city, this.temperature, this.condition, this.icon});

  cities.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    temperature = json['temperature'];
    condition = json['condition'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['temperature'] = this.temperature;
    data['condition'] = this.condition;
    data['icon'] = this.icon;
    return data;
  }
}