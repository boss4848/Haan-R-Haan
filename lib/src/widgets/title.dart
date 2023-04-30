import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final int? count;
  final String subTitle;
  final bool isNoSpacer;
  final String? lastChild;
  final bool? isNoPadding;
  const TitleBar({
    required this.title,
    this.count,
    required this.subTitle,
    this.isNoSpacer = false,
    super.key,
    this.lastChild,
    this.isNoPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isNoPadding! ? 0 : 20,
        right: isNoPadding! ? 0 : 20,
        top: 20,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          isNoSpacer ? const Spacer() : const SizedBox(width: 8),
          Text(
            count != null ? "$count $subTitle" : subTitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (lastChild != null) const Spacer(),
          if (lastChild != null)
            Text(
              lastChild!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
        ],
      ),
    );
  }
}
