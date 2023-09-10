import 'package:chat/widget/Dialogs/NegativeActionButton.dart';
import 'package:chat/widget/Dialogs/PosActionButton.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MyDialogUtils {
  static Future<void> showLoadingDialog(
      BuildContext context, String message) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: MyTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(30),
              content: Row(
                children: [
                  const CircularProgressIndicator(
                    color: MyTheme.blue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.blue),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: false);
  }

  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showFailMessage({
    required BuildContext context,
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    List<Widget> actionList = [];

    // add the button to the action list if it doesn't equal null
    if (negativeActionTitle != null) {
      if (negativeAction != null) {
        actionList.add(NegativeActionButton(
          negativeActionTitle: negativeActionTitle,
          negativeAction: negativeAction,
        ));
      } else {
        actionList.add(
            NegativeActionButton(negativeActionTitle: negativeActionTitle));
      }
    }

    // add the button to the action list if it doesn't equal null
    if (posActionTitle != null) {
      if (actionList.isNotEmpty) {
        actionList.add(const SizedBox(
          width: 20,
        ));
      }
      if (posAction != null) {
        actionList.add(PosActionButton(
          posActionTitle: posActionTitle,
          posAction: posAction,
        ));
      } else {
        actionList.add(PosActionButton(posActionTitle: posActionTitle));
      }
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: MyTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.zero,
              content: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(1000)),
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: MyTheme.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: actionList,
                    ),
                  )
                ],
              ),
            ),
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: false);
  }

  static showSuccessMessage({
    required BuildContext context,
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    List<Widget> actionList = [];

    // add the button to the action list if it doesn't equal null
    if (negativeActionTitle != null) {
      if (negativeAction != null) {
        actionList.add(NegativeActionButton(
          negativeActionTitle: negativeActionTitle,
          negativeAction: negativeAction,
        ));
      } else {
        actionList.add(
            NegativeActionButton(negativeActionTitle: negativeActionTitle));
      }
    }

    // add the button to the action list if it doesn't equal null
    if (posActionTitle != null) {
      if (actionList.isNotEmpty) {
        actionList.add(const SizedBox(
          width: 20,
        ));
      }
      if (posAction != null) {
        actionList.add(PosActionButton(
          posActionTitle: posActionTitle,
          posAction: posAction,
        ));
      } else {
        actionList.add(PosActionButton(posActionTitle: posActionTitle));
      }
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: MyTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.zero,
              content: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          EvaIcons.checkmarkCircle,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: MyTheme.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: actionList,
                    ),
                  )
                ],
              ),
            ),
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: false);
  }

  static showQuestionMessage({
    required BuildContext context,
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    List<Widget> actionList = [];

    // add the button to the action list if it doesn't equal null
    if (negativeActionTitle != null) {
      if (negativeAction != null) {
        actionList.add(NegativeActionButton(
          negativeActionTitle: negativeActionTitle,
          negativeAction: negativeAction,
        ));
      } else {
        actionList.add(
            NegativeActionButton(negativeActionTitle: negativeActionTitle));
      }
    }

    // add the button to the action list if it doesn't equal null
    if (posActionTitle != null) {
      if (actionList.isNotEmpty) {
        actionList.add(const SizedBox(
          width: 20,
        ));
      }
      if (posAction != null) {
        actionList.add(PosActionButton(
          posActionTitle: posActionTitle,
          posAction: posAction,
        ));
      } else {
        actionList.add(PosActionButton(posActionTitle: posActionTitle));
      }
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: MyTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.zero,
              content: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: MyTheme.blue,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          EvaIcons.questionMark,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: MyTheme.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: actionList,
                    ),
                  )
                ],
              ),
            ),
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: false);
  }
}
