String generateChatId({
  required String uid1,
  required String uid2,
}) {
  List uidList = [uid1, uid2];
  uidList.sort();

  /// another method => uidList.join();
  String chatId =
      uidList.fold('', (previousId, currentId) => '$previousId$currentId');
  return chatId;
}
