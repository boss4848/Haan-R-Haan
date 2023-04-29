import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF232248);
const kSecondaryColor = Color(0xFFFFFFFF);
const kButtonColor = Color(0xFFF517CF0);
const kCompColor = Color(0xFFF8F8F8);
const kMemberCardColor = Color(0xFFD39494);
const blueBackgroundColor = Color(0xFFACB8CE);

const kDefaultPadding = 20.0;

const kDefaultBG = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0.1, 0.5, 0.4, 1.5],
  colors: [
    Color.fromARGB(255, 61, 60, 104),
    Color(0xFF232248),
    Color(0xFF232248),
    Color.fromARGB(255, 47, 46, 81),
  ],
);

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

const Description =
    'Split expenses with ease! Our app simplifies cost calculation for shared items among friends.';

//botton theme

// final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//   foregroundColor: Colors.black87,
//   minimumSize: const Size(88, 36),
//   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2.0)),
//   ),
// );

// final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: Colors.black87,
//   backgroundColor: Colors.grey[300],
//   minimumSize: const Size(88, 36),
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2)),
//   ),
// );

// final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
//   foregroundColor: Colors.black87,
//   minimumSize: Size(88, 36),
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2)),
//   ),
// ).copyWith(
//   side: MaterialStateProperty.resolveWith<BorderSide>(
//     (Set<MaterialState> states) => states.contains(MaterialState.pressed)
//         ? BorderSide(
//             color: Theme.of(context as BuildContext).colorScheme.primary,
//             width: 1,
//           )
//         : const BorderSide(),
//   ),
// );
