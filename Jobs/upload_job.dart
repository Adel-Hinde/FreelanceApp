import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:end_project/Persistent/persistent.dart';
import 'package:end_project/Services/global_methods.dart';
import 'package:end_project/Services/global_variable.dart';
import 'package:end_project/Widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _deadLineDateController =
      TextEditingController(text: "Jb DeadLine Date");
  Widget _textTitle({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool emabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
            return null;
          },
          controller: controller,
          enabled: emabled,
          key: ValueKey(valueKey),
          style: const TextStyle(color: Colors.white),
          maxLines: valueKey == "JobDescription" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black,
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              )),
        ),
      ),
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadLineDateController.text =
            "${picked!.year} - ${picked!.month} - ${picked!.day}";
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Job Categories",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _jobCategoryController.text =
                          Persistent.jobCategoryList[index];
                    });
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Persistent.jobCategoryList[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ],
        );
      },
    );
  }

  void _uploadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_deadLineDateController.text == "Jb DeadLine Date" ||
          _jobCategoryController.text == "Select Job Category") {
        GlobalMethods.showErrorDialog(
            error: "Please Pick everything", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          "jobId": jobId,
          "uploadedBy": uid,
          "email": user.email,
          "jobTitle": _jobTitleController.text,
          "jobDescription": _jobDescriptionController.text,
          "deadLineDate": _deadLineDateController.text,
          "deadLineDateTimeStamp": deadLineDateTimeStamp,
          "jobCategory": _jobCategoryController.text,
          "jobComments": [],
          "recruitment": true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "location": location,
          "applicants": 0,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "The Task has been Upladed",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.grey,
        ));
        _jobDescriptionController.clear();
        _jobTitleController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job Category";
          _deadLineDateController.text = "Choose job DeadLine Date";
        });
      } catch (erroor) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErrorDialog(error: erroor.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("its not valid");
    }
  }

  @override
  void dispose() {
    _deadLineDateController.dispose();
    _jobCategoryController.dispose();
    _jobDescriptionController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Please fill all field",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: "Signatra",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitle(label: "Job Category :"),
                            _textFormField(
                                valueKey: "JobCategory",
                                controller: _jobCategoryController,
                                emabled: false,
                                fct: () {
                                  _showTaskCategoriesDialog(size: size);
                                },
                                maxLength: 100),
                            _textTitle(label: "Job Title :"),
                            _textFormField(
                                valueKey: "JobTitle",
                                controller: _jobTitleController,
                                emabled: true,
                                fct: () {},
                                maxLength: 100),
                            _textTitle(label: "Job Description :"),
                            _textFormField(
                                valueKey: "JobDescription",
                                controller: _jobDescriptionController,
                                emabled: true,
                                fct: () {},
                                maxLength: 100),
                            _textTitle(label: "Job DeadLine Date :"),
                            _textFormField(
                                valueKey: "DeadLine",
                                controller: _deadLineDateController,
                                emabled: false,
                                fct: () {
                                  _pickDateDialog();
                                },
                                maxLength: 100),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () {
                                    _uploadTask();
                                  },
                                  color: Colors.black,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Post Now",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: "Signatra",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 9,
                                        ),
                                        Icon(
                                          Icons.upload_file,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


  // appBar: AppBar(
  //         elevation: 5,
  //         shadowColor: Colors.black,
  //         centerTitle: true,
  //         title: const Text(
  //           "Upload Job Now",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         flexibleSpace: Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [Colors.deepOrange.shade300, Colors.blueAccent],
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //               stops: const [0.2, 0.9],
  //             ),
  //           ),
  //         ),
  //       ),




