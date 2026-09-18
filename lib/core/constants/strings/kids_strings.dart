class KidsStrings {
  KidsStrings._();

  static const String title = 'My Kids';
  static const String emptyStateTitle = 'Tell Us About Your Li’l Ones';
  static const String emptyStateSubtitle = "We'll help you find their next fave styles.";

  static const String addChild = 'Add child';
  static const String addAnotherChild = 'Add another child';
  static const String addChildSubtitle = 'Personalize for more little ones';

  static const String deleteConfirmTitle = 'Delete Child Profile?';
  static const String deleteConfirmDescription =
      "Are you sure you want to delete this child's profile? This action is permanent and cannot be undone.";
  static const String deleteConfirmButton = 'Delete Profile';
  static const String deleteSuccessMessage = 'Child Profile Deleted Successfully';
  static const String addSuccessMessage = 'Child Profile Added Successfully';
  static const String editSuccessMessage = 'Child Profile Updated Successfully';

  // ── Add / edit form ──
  static const String addFormTitle = 'Add A Child';
  static const String editFormTitle = 'Edit Profile';
  static const String formHeading = "Let's add your little one";
  static const String formSubheading = "We'll personalize your shopping experience for them.";
  static const String editFormHeading = 'Edit your child\'s profile';
  static const String editFormSubheading = 'Keep their details updated for the best curated collections.';
  static const String nameLabel = "Child's Name";
  static const String dobLabel = 'DD - MM - YYYY';
  static const String genderBoy = 'Boy';
  static const String genderGirl = 'Girl';

  static const String whyWeAskBannerTitle = 'Why we ask for this?';
  static const String whyWeAskBannerSubtitle =
      "We'll show sizes, styles and collections that suit your child's age.";
  static const String consentText =
      "I consent to sharing my child's name, birth date and gender so this app can "
      'personalize their shopping experience. This info is stored securely and never sold.';
  static const String viewPrivacyPolicy = 'View Privacy Policy';
  static const String consentRequiredError = "Consent is required to add your child's information";
  static const String saveButton = 'Add Child';
  static const String saveChangesButton = 'Save Changes';
  static const String nameRequiredError = 'Please enter a name';
  static const String genderRequiredError = 'Please select Boy or Girl';
  static const String dobRequiredError = 'Please enter a date of birth';
  static const String discardChangesTitle = 'Discard changes?';
  static const String discardChangesDescription = "You'll lose the details you've entered if you go back now.";
  static const String discardChangesConfirm = 'Discard';
  static const String discardChangesCancel = 'Keep editing';

  // Shown as an inline banner (not the submit-error toast) when saving the
  // child fails at the network/server level rather than a validation issue.
  static const String apiErrorBannerTitle = 'Oops! Something Went Wrong';
  static const String apiErrorBannerSubtitle = "We're fixing things behind the scenes.";
}
