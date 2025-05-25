import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:end_project/Jobs/job_details.dart';
import 'package:end_project/Services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {
  const JobWidget({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
    required this.imgUrl,
  });

  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  final int imgUrl;

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialg() {
    User? user = _auth.currentUser;
    final uid = user?.uid;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(top: 5, bottom: 4),
          actions: [
            TextButton(
                onPressed: () async {
                  try {
                    if (widget.uploadedBy == uid) {
                      await FirebaseFirestore.instance
                          .collection("jobs")
                          .doc(widget.jobId)
                          .delete();

                      // ignore: await_only_futures, use_build_context_synchronously
                      await ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text(
                          "The Task has been Deleted",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.grey,
                      ));
                      // ignore: use_build_context_synchronously
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    } else {
                      GlobalMethods.showErrorDialog(
                          error: "you cannot perform this action",
                          ctx: context);
                    }
                  } catch (error) {
                    GlobalMethods.showErrorDialog(
                        error: 'this Task can not be deleted', ctx: context);
                  } finally {}
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => JobDetailsScreen(
              userImageUrl: widget.imgUrl.isEven ? "assets/images/forget.jpg" : "assets/images/signup.png" ,
              jobId: widget.jobId,
              uploadedBy: widget.uploadedBy,

            ),
          ));
        },
        onLongPress: () {
          _deleteDialg();
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
                border: Border(
              right: BorderSide(width: 1),
            )),
            child: widget.imgUrl.isEven
                ? Image.asset("assets/images/forget.jpg")
                : Image.asset("assets/images/signup.png")),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
