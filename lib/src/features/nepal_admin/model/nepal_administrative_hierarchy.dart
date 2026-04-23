class NepalAdministrativeHierarchy {
  const NepalAdministrativeHierarchy({
    required this.metadata,
    required this.overview,
    required this.provinces,
  });

  factory NepalAdministrativeHierarchy.fromJson(Map<String, dynamic> json) {
    return NepalAdministrativeHierarchy(
      metadata: HierarchyMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? const {},
      ),
      overview: HierarchyOverview.fromJson(
        json['overview'] as Map<String, dynamic>? ?? const {},
      ),
      provinces: (json['provinces'] as List<dynamic>? ?? const [])
          .map(
            (province) => Province.fromJson(province as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final HierarchyMetadata metadata;
  final HierarchyOverview overview;
  final List<Province> provinces;
}

class HierarchyMetadata {
  const HierarchyMetadata({
    required this.country,
    required this.description,
    required this.dataScope,
    required this.wardLevelNote,
    required this.lastUpdated,
    required this.sources,
  });

  factory HierarchyMetadata.fromJson(Map<String, dynamic> json) {
    return HierarchyMetadata(
      country: json['country'] as String? ?? 'Nepal',
      description: json['description'] as String? ?? '',
      dataScope: json['dataScope'] as String? ?? '',
      wardLevelNote: json['wardLevelNote'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
      sources: (json['sources'] as List<dynamic>? ?? const [])
          .map((source) => DataSource.fromJson(source as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final String country;
  final String description;
  final String dataScope;
  final String wardLevelNote;
  final String lastUpdated;
  final List<DataSource> sources;
}

class DataSource {
  const DataSource({required this.label, required this.url});

  factory DataSource.fromJson(Map<String, dynamic> json) {
    return DataSource(
      label: json['label'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  final String label;
  final String url;
}

class HierarchyOverview {
  const HierarchyOverview({
    required this.provinces,
    required this.districts,
    required this.localLevels,
    required this.wards,
  });

  factory HierarchyOverview.fromJson(Map<String, dynamic> json) {
    return HierarchyOverview(
      provinces: (json['provinces'] as num?)?.toInt() ?? 0,
      districts: (json['districts'] as num?)?.toInt() ?? 0,
      localLevels: LocalLevelBreakdown.fromJson(
        json['localLevels'] as Map<String, dynamic>? ?? const {},
      ),
      wards: WardBreakdown.fromJson(
        json['wards'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final int provinces;
  final int districts;
  final LocalLevelBreakdown localLevels;
  final WardBreakdown wards;
}

class LocalLevelBreakdown {
  const LocalLevelBreakdown({
    required this.total,
    required this.metropolises,
    required this.subMetropolises,
    required this.municipalities,
    required this.ruralMunicipalities,
  });

  factory LocalLevelBreakdown.fromJson(Map<String, dynamic> json) {
    return LocalLevelBreakdown(
      total: (json['total'] as num?)?.toInt() ?? 0,
      metropolises: (json['metropolises'] as num?)?.toInt() ?? 0,
      subMetropolises: (json['subMetropolises'] as num?)?.toInt() ?? 0,
      municipalities: (json['municipalities'] as num?)?.toInt() ?? 0,
      ruralMunicipalities: (json['ruralMunicipalities'] as num?)?.toInt() ?? 0,
    );
  }

  final int total;
  final int metropolises;
  final int subMetropolises;
  final int municipalities;
  final int ruralMunicipalities;
}

class WardBreakdown {
  const WardBreakdown({
    required this.total,
    required this.minimumPerLocalLevel,
    required this.maximumPerLocalLevel,
  });

  factory WardBreakdown.fromJson(Map<String, dynamic> json) {
    return WardBreakdown(
      total: (json['total'] as num?)?.toInt() ?? 0,
      minimumPerLocalLevel:
          (json['minimumPerLocalLevel'] as num?)?.toInt() ?? 0,
      maximumPerLocalLevel:
          (json['maximumPerLocalLevel'] as num?)?.toInt() ?? 0,
    );
  }

  final int total;
  final int minimumPerLocalLevel;
  final int maximumPerLocalLevel;
}

class Province {
  const Province({required this.name, required this.districts});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      name: json['name'] as String? ?? '',
      districts: (json['districts'] as List<dynamic>? ?? const [])
          .map(
            (district) => District.fromJson(district as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String name;
  final List<District> districts;
}

class District {
  const District({required this.name, required this.localLevels});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'] as String? ?? '',
      localLevels: (json['localLevels'] as List<dynamic>? ?? const [])
          .map(
            (localLevel) =>
                LocalLevel.fromJson(localLevel as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String name;
  final List<LocalLevel> localLevels;
}

class LocalLevel {
  const LocalLevel({
    required this.name,
    required this.type,
    required this.wards,
  });

  factory LocalLevel.fromJson(Map<String, dynamic> json) {
    return LocalLevel(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      wards: (json['wards'] as List<dynamic>? ?? const [])
          .map((ward) => WardEntry.fromJson(ward as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final String name;
  final String type;
  final List<WardEntry> wards;
}

class WardEntry {
  const WardEntry({required this.number, required this.areas});

  factory WardEntry.fromJson(Map<String, dynamic> json) {
    return WardEntry(
      number: (json['number'] as num?)?.toInt() ?? 0,
      areas: (json['areas'] as List<dynamic>? ?? const [])
          .map((area) {
            if (area is String) {
              return AreaEntry(name: area, buildings: const []);
            }
            return AreaEntry.fromJson(area as Map<String, dynamic>);
          })
          .toList(growable: false),
    );
  }

  final int number;
  final List<AreaEntry> areas;
}

class AreaEntry {
  const AreaEntry({required this.name, required this.buildings});

  factory AreaEntry.fromJson(Map<String, dynamic> json) {
    return AreaEntry(
      name: json['name'] as String? ?? '',
      buildings: (json['buildings'] as List<dynamic>? ?? const [])
          .map((building) => building as String)
          .toList(growable: false),
    );
  }

  final String name;
  final List<String> buildings;
}
