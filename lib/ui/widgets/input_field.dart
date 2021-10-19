import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:todo/ui/theme.dart';

import '../size_config.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.widget,
      this.controller})
      : super(key: key);
  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            height: 52,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor:
                        Get.isDarkMode ? Colors.grey : Colors.grey[700],
                    controller: controller,
                    autofocus: false,
                    style: subTilteStyle,
                    readOnly: widget != null ? true : false,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTilteStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
