# custom_address

A Flutter app that stores Nepal's administrative hierarchy in a local JSON asset and renders it in the UI.

## What is included

- National overview counts for provinces, districts, local levels, and wards
- All 77 districts grouped under Nepal's 7 provinces
- Sample lower-level hierarchy entries down to ward and tole/area for selected local levels
- A searchable UI backed entirely by local asset data

## Folder structure

```text
assets/data/nepal/administrative_hierarchy.json
lib/main.dart
lib/src/app.dart
lib/src/features/nepal_admin/data/nepal_administrative_repository.dart
lib/src/features/nepal_admin/model/nepal_administrative_hierarchy.dart
lib/src/features/nepal_admin/presentation/nepal_administrative_screen.dart
```

## Run

```bash
flutter pub get
flutter run
```

## Notes

- The JSON schema is ready for expansion if you want to add all 753 local levels and more ward-level data later.
- The current detailed ward and area records are illustrative samples based on the data you provided.
