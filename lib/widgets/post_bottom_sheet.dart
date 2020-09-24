import 'package:flutter/material.dart';

class PostBottomSheet extends StatelessWidget {
  final Function setCommentText;
  final Function postComment;
  const PostBottomSheet({
    Key key,
    @required this.setCommentText,
    @required this.postComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Material(
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    await postComment();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[600]),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(4)),
                      color: const Color(0xFF8D6E63),
                    ),
                    child: Center(
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            maxLines: null,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.start,
            cursorWidth: 1,
            autocorrect: false,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              contentPadding: EdgeInsets.all(5.0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: 'Write a comment',
              labelStyle: TextStyle(
                color: Colors.black54,
              ),
            ),
            cursorColor: Colors.black54,
            onChanged: (text) {
              setCommentText(text);
            },
            // --inital value--
            // controller: TextEditingController()..text = commentText,
          ),
        ],
      ),
    );
  }
}
