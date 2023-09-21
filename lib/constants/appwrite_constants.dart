class AppwriteConstants {
  static const String databaseId = '65018c15dba674f3d194';
  static const String projectId = '650189feab0e62a5ca2a';
  static const String endPoint = "https://cloud.appwrite.io/v1";

  static const String usersCollection = '65018c27acb6606aad21';
  static const String tweetsCollection = '65092e4bbea69391a1a0';
  static const String notificationsCollection = '65018e7437c1413b1b83';
  static const String zconnectCollection = "650a466401f7130760e1";
  static const String imagesBucket = '65018e9dafc6a2c4d24c';
  static const String blogBucket = "650a467443243e3de7f0";

  // static const String databaseId = '650b14a9abe000b37423';
  // static const String projectId = '650b13a05585f4832bde';
  // static const String endPoint = "http://172.16.1.93/v1";

  // static const String usersCollection = '650b14da1c2bba813f0d';
  // static const String tweetsCollection = '650b150b0e3b1950236d';
  // static const String notificationsCollection = '650b15241f9029bb722a';
  // static const String zconnectCollection = "650b1535d2b108c30220";
  // static const String imagesBucket = '650b155b99047e15ede1';
  // static const String blogBucket = "650b1573506c0f838b5e";

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
  static String blogUrl(String blogId) =>
      "$endPoint/storage/buckets/$blogBucket/files/$blogId/view?project=$projectId&mode=admin";
}
