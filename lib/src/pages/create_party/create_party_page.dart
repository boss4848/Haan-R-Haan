import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/party_view_model.dart';
import '../../widgets/button.dart';

class CreatePartyPage extends StatefulWidget {
  const CreatePartyPage({super.key});

  @override
  State<CreatePartyPage> createState() => _CreatePartyPageState();
}

class _CreatePartyPageState extends State<CreatePartyPage> {
  final partyNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool isPromptPay = true;
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(context),
          _buildBanner(context),
        ],
      ),
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      color: blueBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 160),
              InputBox(
                controller: partyNameController,
                errorText: "",
                label: "Party Name",
              ),
              const SizedBox(height: 10),
              InputBox(
                controller: descriptionController,
                errorText: "",
                label: "Description",
              ),
              const SizedBox(height: 10),
              Text(
                "Promptpay",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      checkColor: blueBackgroundColor,
                      value: isPromptPay,
                      onChanged: (value) {
                        const Duration(milliseconds: 100);
                        setState(() {
                          isPromptPay = value!;
                        });
                      },
                      fillColor: MaterialStateProperty.all(
                        kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "Use your phone number",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!isPromptPay)
                InputBox(
                  controller: phoneNumberController,
                  errorText: "error",
                  label: "Phone Number",
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Button(() async {
                  final partyViewModel = Provider.of<PartyViewModel>(
                    context,
                    listen: false,
                  );
                  final createData = await partyViewModel.createParty(
                    partyName: partyNameController.text,
                    partyDesc: descriptionController.text,
                    promptpay: phoneNumberController.text,
                    context: context,
                  );
                  Navigator.pop(context);
                }, "Create"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kDefaultBG,
      ),
      height: 140,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Create Party",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
