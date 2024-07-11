//class yang berisi nama field yang ada di collection firestore

class FirebaseFieldNames {

  //field yang ada di collection user
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String uid = 'uid';
  static const String profilePicUrl = 'profile_pic_url';


  //field yang ada di collection chat room
  static const members = 'members';
  static const chatroomId = 'chatroom_id';
  static const lastMessage = 'last_message';
  static const lastMessageTs = 'last_message_ts';
  static const message = 'message';
  static const senderId = 'sender_id';
  static const receiverId = 'receiver_id';
  static const seen = 'seen';
  static const timestamp = 'timestamp';
  static const messageId = 'message_id';
  static const String createdAt = 'created_at';


  FirebaseFieldNames._();
}