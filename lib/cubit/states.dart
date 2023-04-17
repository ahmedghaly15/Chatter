import '../models/user_model.dart';

abstract class ChatterAppStates {}

class InitialState extends ChatterAppStates {}

//============ The Current User's States ============
class GetUserLoadingState extends ChatterAppStates {}

class GetUserSuccessState extends ChatterAppStates {}

class GetUserErrorState extends ChatterAppStates {
  final String error;
  GetUserErrorState(this.error);
}

//============ Getting All Users States ============
class GetAllUserSuccessState extends ChatterAppStates {}

class GetAllUserErrorState extends ChatterAppStates {
  final String error;
  GetAllUserErrorState(this.error);
}

//============ Updating The Current User States ============
class UserUpdateErrorState extends ChatterAppStates {}

//============ Profile Image States ============
class ProfileImagePickedSuccessState extends ChatterAppStates {}

class ProfileImagePickedErrorState extends ChatterAppStates {}

class UploadingProfileImageLoadingState extends ChatterAppStates {}

class UploadProfileImageSuccessState extends ChatterAppStates {}

class UploadProfileImageErrorState extends ChatterAppStates {}

//============ Messages States ============
class SendMessageSuccessState extends ChatterAppStates {}

class SendMessageErrorState extends ChatterAppStates {}

class GetMessagesSuccessState extends ChatterAppStates {}

class MessageImagePickedSuccessState extends ChatterAppStates {}

class MessageImagePickedErrorState extends ChatterAppStates {}

class UploadMessageImageLoadingState extends ChatterAppStates {}

class UploadMessageImageSuccessState extends ChatterAppStates {}

class UploadMessageImageErrorState extends ChatterAppStates {}

class RemovedMessageImageSuccessState extends ChatterAppStates {}

//============ Search States ============
class InvertIsSearchingSuccessState extends ChatterAppStates {}

class SearchListUpdateSuccessState extends ChatterAppStates {
  final List<UserModel> list;
  SearchListUpdateSuccessState(this.list);
}

class OnChangeTextSuccessState extends ChatterAppStates {}
