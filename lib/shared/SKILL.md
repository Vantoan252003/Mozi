# shared/ — Reusable UI Building Blocks

## Rules
- ZERO business logic — no BLoC/Cubit injection inside widgets
- ZERO imports from features/ — only core/ imports allowed
- All interaction via callback props (VoidCallback, Function(T))
- All styling via AppColors, AppTypography, AppDimensions — no hardcoded values
- All widgets must have const constructors where possible
- Export all from shared/widgets/widgets.dart barrel file

## Subdirectories
| Directory    | Contents                                    |
|--------------|---------------------------------------------|
| `widgets/`   | Pure UI components                          |
| `extensions/`| Dart extension methods                      |
| `mixins/`    | StatefulWidget mixins                       |
