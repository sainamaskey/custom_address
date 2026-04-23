import 'package:flutter/material.dart';

import '../data/nepal_administrative_repository.dart';
import '../model/nepal_administrative_hierarchy.dart';

class NepalAdministrativeScreen extends StatefulWidget {
  const NepalAdministrativeScreen({super.key, required this.repository});

  final NepalAdministrativeRepository repository;

  @override
  State<NepalAdministrativeScreen> createState() =>
      _NepalAdministrativeScreenState();
}

class _NepalAdministrativeScreenState extends State<NepalAdministrativeScreen> {
  late final Future<NepalAdministrativeHierarchy> _hierarchyFuture;

  String? _selectedProvinceName;
  String? _selectedDistrictName;
  String? _selectedLocalLevelName;
  int? _selectedWardNumber;
  String? _selectedAreaName;
  String? _selectedBuildingName;

  @override
  void initState() {
    super.initState();
    _hierarchyFuture = widget.repository.loadHierarchy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<NepalAdministrativeHierarchy>(
        future: _hierarchyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load local address data.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final hierarchy = snapshot.requireData;
          final selectedProvince = _findProvince(hierarchy.provinces);
          final districts = selectedProvince?.districts ?? const <District>[];
          final selectedDistrict = _findDistrict(districts);
          final localLevels =
              selectedDistrict?.localLevels ?? const <LocalLevel>[];
          final selectedLocalLevel = _findLocalLevel(localLevels);
          final wards = selectedLocalLevel?.wards ?? const <WardEntry>[];
          final selectedWard = _findWard(wards);
          final areas = selectedWard?.areas ?? const <AreaEntry>[];
          final selectedArea = _findArea(areas);
          final buildings = selectedArea?.buildings ?? const <String>[];

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DropdownField<String>(
                        fieldKey: const Key('province_dropdown'),
                        label: 'Province',
                        hint: 'Select province',
                        value: _selectedProvinceName,
                        items: hierarchy.provinces
                            .map(
                              (province) => DropdownMenuItem<String>(
                                value: province.name,
                                child: Text(province.name),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          setState(() {
                            _selectedProvinceName = value;
                            _selectedDistrictName = null;
                            _selectedLocalLevelName = null;
                            _selectedWardNumber = null;
                            _selectedAreaName = null;
                            _selectedBuildingName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField<String>(
                        fieldKey: const Key('district_dropdown'),
                        label: 'District',
                        hint: 'Select district',
                        disabledHint: 'Select province first',
                        value: _selectedDistrictName,
                        items: districts
                            .map(
                              (district) => DropdownMenuItem<String>(
                                value: district.name,
                                child: Text(district.name),
                              ),
                            )
                            .toList(growable: false),
                        enabled: _selectedProvinceName != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedDistrictName = value;
                            _selectedLocalLevelName = null;
                            _selectedWardNumber = null;
                            _selectedAreaName = null;
                            _selectedBuildingName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField<String>(
                        fieldKey: const Key('local_level_dropdown'),
                        label: 'Municipality / Rural Municipality',
                        hint: 'Select local level',
                        disabledHint: 'Select district first',
                        value: _selectedLocalLevelName,
                        items: localLevels
                            .map(
                              (localLevel) => DropdownMenuItem<String>(
                                value: localLevel.name,
                                child: Text(localLevel.name),
                              ),
                            )
                            .toList(growable: false),
                        enabled: _selectedDistrictName != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedLocalLevelName = value;
                            _selectedWardNumber = null;
                            _selectedAreaName = null;
                            _selectedBuildingName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField<int>(
                        fieldKey: const Key('ward_dropdown'),
                        label: 'Ward',
                        hint: 'Select ward',
                        disabledHint: 'Select local level first',
                        value: _selectedWardNumber,
                        items: wards
                            .map(
                              (ward) => DropdownMenuItem<int>(
                                value: ward.number,
                                child: Text('Ward ${ward.number}'),
                              ),
                            )
                            .toList(growable: false),
                        enabled: _selectedLocalLevelName != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedWardNumber = value;
                            _selectedAreaName = null;
                            _selectedBuildingName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField<String>(
                        fieldKey: const Key('area_dropdown'),
                        label: 'Tole / Area',
                        hint: 'Select tole or area',
                        disabledHint: _selectedWardNumber == null
                            ? 'Select ward first'
                            : 'No national tole dataset loaded',
                        value: _selectedAreaName,
                        items: areas
                            .map(
                              (area) => DropdownMenuItem<String>(
                                value: area.name,
                                child: Text(area.name),
                              ),
                            )
                            .toList(growable: false),
                        enabled: areas.isNotEmpty,
                        onChanged: (value) {
                          setState(() {
                            _selectedAreaName = value;
                            _selectedBuildingName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField<String>(
                        fieldKey: const Key('building_dropdown'),
                        label: 'House / Building',
                        hint: 'Select house or building',
                        disabledHint: _selectedAreaName == null
                            ? 'Select tole or area first'
                            : 'No national building dataset loaded',
                        value: _selectedBuildingName,
                        items: buildings
                            .map(
                              (building) => DropdownMenuItem<String>(
                                value: building,
                                child: Text(building),
                              ),
                            )
                            .toList(growable: false),
                        enabled: buildings.isNotEmpty,
                        onChanged: (value) {
                          setState(() {
                            _selectedBuildingName = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Province? _findProvince(List<Province> provinces) {
    final provinceName = _selectedProvinceName;
    if (provinceName == null) {
      return null;
    }

    for (final province in provinces) {
      if (province.name == provinceName) {
        return province;
      }
    }

    return null;
  }

  District? _findDistrict(List<District> districts) {
    final districtName = _selectedDistrictName;
    if (districtName == null) {
      return null;
    }

    for (final district in districts) {
      if (district.name == districtName) {
        return district;
      }
    }

    return null;
  }

  LocalLevel? _findLocalLevel(List<LocalLevel> localLevels) {
    final localLevelName = _selectedLocalLevelName;
    if (localLevelName == null) {
      return null;
    }

    for (final localLevel in localLevels) {
      if (localLevel.name == localLevelName) {
        return localLevel;
      }
    }

    return null;
  }

  WardEntry? _findWard(List<WardEntry> wards) {
    final wardNumber = _selectedWardNumber;
    if (wardNumber == null) {
      return null;
    }

    for (final ward in wards) {
      if (ward.number == wardNumber) {
        return ward;
      }
    }

    return null;
  }

  AreaEntry? _findArea(List<AreaEntry> areas) {
    final areaName = _selectedAreaName;
    if (areaName == null) {
      return null;
    }

    for (final area in areas) {
      if (area.name == areaName) {
        return area;
      }
    }

    return null;
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.enabled = true,
    this.disabledHint,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final effectiveHint = enabled ? hint : (disabledHint ?? hint);

    return Container(
      key: fieldKey,
      child: DropdownButtonFormField<T>(
        key: ValueKey<Object>(Object.hash(label, value, enabled, items.length)),
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        hint: Text(effectiveHint),
        items: items,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
