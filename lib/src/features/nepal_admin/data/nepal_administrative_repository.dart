import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/nepal_administrative_hierarchy.dart';

abstract class NepalAdministrativeRepository {
  Future<NepalAdministrativeHierarchy> loadHierarchy();
}

class AssetNepalAdministrativeRepository
    implements NepalAdministrativeRepository {
  AssetNepalAdministrativeRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const String assetPath =
      'assets/data/nepal/administrative_hierarchy.json';

  final AssetBundle _bundle;

  @override
  Future<NepalAdministrativeHierarchy> loadHierarchy() async {
    final jsonString = await _bundle.loadString(assetPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return NepalAdministrativeHierarchy.fromJson(jsonMap);
  }
}
