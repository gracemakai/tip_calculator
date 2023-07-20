import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tip_calculator/controllers/bill.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final TextEditingController billTextController = TextEditingController();

  final BillController billController = Get.put(BillController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1.5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Bill Total: "),
                        SizedBox(
                          width: width * 0.5,
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            decoration: const InputDecoration(
                              hintText: "100",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: UnderlineInputBorder(),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: billTextController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is required';
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              billController.bill.value =
                                  double.tryParse(value) ?? 0;
                            },
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Tip: "),
                        buildText("\$${calculateTip()} "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Total: "),
                        buildText("\$${calculateTotalBill()} "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1.5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: width * 0.2, child: buildText("Tip %: ")),
                        Slider(
                            value: billController.tip.value,
                            max: 100,
                            min: 0,
                            onChanged: (double value) {
                              billController.tip.value =
                                  value.truncateToDouble();
                            }),
                        SizedBox(
                            width: width * 0.2,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: buildText(
                                    "${billController.tip.value}% "))),
                      ],
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: width * 0.2, child: buildText("Split: ")),
                        Slider(
                            value: billController.split.value,
                            max: 100,
                            min: 1,
                            onChanged: (double value) {
                              billController.split.value =
                                  value.truncateToDouble();
                            }),
                        SizedBox(
                            width: width * 0.2,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: buildText(
                                    "${billController.split.value.toInt()}"))),
                      ],
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Split Tip: "),
                        buildText("\$${calculateSplitTip()} "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Split Total: "),
                        buildText("\$${calculateSplitTotal()} "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  double calculateTip() {
    double bill = billController.bill.value;

    return bill > 0
        ? (bill *
                ((billController.tip.value > 0 ? billController.tip.value : 0) /
                    100))
            .toPrecision(2)
        : 0;
  }

  double calculateTotalBill() {
    int bill = int.tryParse(billTextController.text) ?? 0;
    double totalTip = calculateTip();
    return bill + totalTip;
  }

  double calculateSplitTip() {
    return (calculateTip() / billController.split.value).toPrecision(2);
  }

  double calculateSplitTotal() {
    return (calculateSplitTip() +
            (calculateTotalBill() / billController.split.value))
        .toPrecision(2);
  }

  Text buildText(String text) => Text(
        text,
        style: const TextStyle(fontSize: 16),
      );
}
