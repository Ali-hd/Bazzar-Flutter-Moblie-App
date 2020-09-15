class Post {
  String id;
  bool approved;
  List bids;
  String createdAt;
  String description;
  List images;
  int likes;
  String location;
  bool open;
  String price;
  String startBid;
  String title;
  String updatedAt;
  Map user;
  int views;

  Post({
    this.id,
    this.approved,
    this.bids,
    this.createdAt,
    this.description,
    this.images,
    this.likes,
    this.location,
    this.open,
    this.price,
    this.startBid,
    this.title,
    this.updatedAt,
    this.user,
    this.views
  });
}