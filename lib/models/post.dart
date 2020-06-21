class Post{
  final String postIndex;
  final String dateTime;
  final String type;
  final List<String> postIndexIndex;
  final List<String> topics;
  final List<String> writings;
  final List<String> writers;

  Post({this.postIndex, this.dateTime, this.postIndexIndex, this.type, this.topics, this.writings, this.writers});
}

class PostData{
  String postIndex;
  String type;
  List<String> postIndexIndex;
  List<String> topics;
  List<String> writings;
  List<String> writers;


  PostData.fromMap (Map snapshot, String postIndex) :
      postIndex = postIndex ?? '',
      type = snapshot['타입'] ?? '',
      topics = snapshot['주제'] ?? [],
      writings = snapshot['글'] ?? [],
      writers = snapshot['글쓴이들(uid)'] ?? [],
      postIndexIndex = snapshot['포스트인덱스인덱스'] ?? [];

  toJson() {
    return {
      "type" : type,
      "topics" : topics,
      "writings" : writings,
      "writers" : writers,
      "postIndexIndex" : postIndexIndex,
    };
  }

}