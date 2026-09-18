part of 'manage_kid_bloc.dart';

@freezed
sealed class ManageKidEvent with _$ManageKidEvent {
  const factory ManageKidEvent.init(ChildEntity? existing) = InitManageKid;
  const factory ManageKidEvent.nameChanged(String name) = NameChanged;
  const factory ManageKidEvent.dobChanged(DateTime dob) = DobChanged;
  const factory ManageKidEvent.genderChanged(ChildGender gender) =
      GenderChanged;
  const factory ManageKidEvent.consentChanged(bool given) = ConsentChanged;
  const factory ManageKidEvent.submit() = SubmitKid;
}
