# feature/profile — User Profile & Saved Addresses

## Entities
ProfileEntity (extends UserEntity) {
  + dateOfBirth?: DateTime, gender?: String ('male'|'female'|'other'),
    memberLevel: String, memberSince: DateTime
}

AddressLabel { home, work, other }
SavedAddressEntity {
  id, label: AddressLabel, customLabel: String (for 'other'),
  displayName: String, fullAddress: String,
  lat: double, lng: double, isDefault: bool
}

## UseCases
GetProfileUseCase           — call() → ProfileEntity
UpdateProfileUseCase        — call({name?, email?, dob?, gender?}) → ProfileEntity
UploadAvatarUseCase         — call(filePath: String) → String (new avatarUrl)
GetSavedAddressesUseCase    — call() → List<SavedAddressEntity>
SaveAddressUseCase          — call(SavedAddressEntity) → SavedAddressEntity (with server id)
UpdateAddressUseCase        — call(SavedAddressEntity)
DeleteAddressUseCase        — call(addressId)
SetDefaultAddressUseCase    — call(addressId)

## Avatar Upload Flow
1. image_picker → pick from gallery or camera (requires PermissionService.requestCamera/requestPhotos)
2. Compress image (flutter_image_compress recommended) to max 500KB
3. PUT multipart/form-data to ApiConstants.uploadAvatar
4. Backend returns new avatarUrl
5. Update UserEntity in Hive userBox

## Presentation
Cubit: ProfileCubit — loadProfile, updateProfile, uploadAvatar
Cubit: AddressCubit — loadAddresses, save, update, delete, setDefault

Pages:
  ProfilePage         — Header + menu items list
  EditProfilePage     — Form: name, email, dob, gender + avatar picker
  SavedAddressesPage  — List + add button + default badge + edit/delete swipe
  AddAddressPage      — Uses MapPickerPage + label selector + save

Widgets:
  ProfileHeader       — CircleAvatar (with camera overlay) + name + phone
  ProfileMenuItem     — Row(leading_icon, label, trailing_value?, arrow)
  AddressCard         — Label badge + address text + default star + actions
  AddressLabelPicker  — Row of chip options: 🏠 Nhà / 🏢 Cơ quan / 📍 Khác
  AvatarPickerSheet   — BottomSheet: "Chọn từ thư viện" / "Chụp ảnh"

## Rules
- Saved addresses cached in Hive addressBox — synced on each app launch
- Cannot delete the default address if it's the only address
- AddAddressPage: lat/lng come from MapPickerPage result
