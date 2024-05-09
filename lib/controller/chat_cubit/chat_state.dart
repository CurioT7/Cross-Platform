part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class GetChatsLoading extends ChatState {}

final class GetChatsSuccess extends ChatState {}

final class GetChatsError extends ChatState {
  final String error;
  GetChatsError(this.error);
}

final class CheckUserNameAvilability extends ChatState {}

final class CheckUserNameAvilabilityLoading extends ChatState {}

final class CheckUserNameAvilabilitySuccess extends ChatState {
  final Map<String, dynamic> response;
  CheckUserNameAvilabilitySuccess(this.response);
}

final class CheckUserNameAvilabilityError extends ChatState {
  final String error;
  CheckUserNameAvilabilityError(this.error);
}

final class CreateNewChatLoading extends ChatState {}

final class CreateNewChatSuccess extends ChatState {
  final Map<String, dynamic> response;
  CreateNewChatSuccess(this.response);
}

final class CreateNewChatError extends ChatState {
  final String error;
  CreateNewChatError(this.error);
}

final class SendMessageLoading extends ChatState {}

final class SendMessageSuccess extends ChatState {
  final Map<String, dynamic> response;
  SendMessageSuccess(this.response);
}

final class SendMessageError extends ChatState {
  final String error;
  SendMessageError(this.error);
}

final class GetAllMessagesLoading extends ChatState {}

final class GetAllMessagesSuccess extends ChatState {
  final ChatDetails chats;
  GetAllMessagesSuccess(this.chats);
}

final class GetAllMessagesError extends ChatState {
  final String error;
  GetAllMessagesError(this.error);
}

final class GetReqChatLoading extends ChatState {}

final class GetReqChatSuccess extends ChatState {}

final class GetReqChatError extends ChatState {
  final String error;
  GetReqChatError(this.error);
}
