import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:curio/Models/chat_request_model.dart';
import 'package:curio/Models/chatmodel.dart';
import 'package:curio/services/chat_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);

  final _api = ChatApiServices();

  List<Chat> chats = [];
  Future<void> getChats({required token}) async {
    chats = [];
    emit(GetChatsLoading());
    try {
      chats.addAll(await _api.getChats(token));
      chats.forEach(print);
      emit(GetChatsSuccess());
    } catch (error) {
      log(error.toString());
      emit(GetChatsError(error.toString()));
    }
  }

  toinitState() {
    emit(CheckUserNameAvilability());
  }

  Future<void> checkUserNameAvilability(username) async {
    emit(CheckUserNameAvilabilityLoading());
    try {
      var response = await _api.checkUserNameAvilability(username);
      if (response['success'] == true) {
        emit(CheckUserNameAvilabilitySuccess(response));
      } else {
        emit(CheckUserNameAvilabilityError(response['message']));
      }
    } catch (error) {
      log(error.toString());
      emit(CheckUserNameAvilabilityError(error.toString()));
    }
  }

  //!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------
//!---------------------------------Create New Chat--------------------------------
//!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------

  Future<void> createNewChat(
    String username,
    String token,
    String message, {
    String media = '',
  }) async {
    emit(CreateNewChatLoading());
    try {
      var response = await _api.createNewChat(
          username: username, token: token, message: message, media: media);
      if (response['success'] == true) {
        emit(CreateNewChatSuccess(response));
      } else {
        emit(CreateNewChatError(response['message']));
      }
    } catch (error) {
      log(error.toString());
      emit(CreateNewChatError(error.toString()));
    }
  }

  //!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------
//!---------------------------------Send Message-----------------------------------
//!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------

  Future<void> sendMessage({
    required int index,
    required String token,
    required String message,
    required String chatID,
    String media = '',
  }) async {
    emit(SendMessageLoading());
    try {
      var response = await _api.sendMessage(
          token: token, message: message, chatID: chatID, media: media);
      if (response['success'] == true) {
        emit(SendMessageSuccess(response));
        getAllMessages(index, token: token, chatID: chatID);
      } else {
        emit(SendMessageError(response['message']));
      }
    } catch (error) {
      log(error.toString());
      emit(SendMessageError(error.toString()));
    }
  }

  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  //!-----------------------------------Get all Message------------------------------
  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  Chat? chat;
  getAllMessages(index, {required String token, required String chatID}) async {
    emit(GetAllMessagesLoading());
    try {
      chat = await _api.getChatMessages(chatID, token);
      log(chat!.messages.length.toString());
      chats[index].messages = chat!.messages;
      emit(GetAllMessagesSuccess(chat!));
    } catch (error) {
      log(error.toString());
      emit(GetAllMessagesError(error.toString()));
    }
  }

  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  //!-----------------------------------Get chat Request-----------------------------
  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------

  List<Chat> chatRequests = [];
  Future<void> getChatRequest({required String token}) async {
    emit(GetReqChatLoading());
    try {
      var response = await _api.fetchChatRequests(token: token);
      log(response.toString());

      emit(GetReqChatSuccess());
    } catch (error) {
      log(error.toString());
      emit(GetReqChatError(error.toString()));
    }
  }
}
