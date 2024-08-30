import 'dart:io';
import 'dart:typed_data';

import 'package:expensetracker_isar/collections/expense.dart';
import 'package:expensetracker_isar/util/config.dart';
import 'package:expensetracker_isar/util/func.dart';
import 'package:expensetracker_isar/widgets/expense_category_item.dart';
import 'package:expensetracker_isar/widgets/expense_title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../collections/receipt.dart';

class ExpenseWidget extends ConsumerStatefulWidget {
  const ExpenseWidget(
      {super.key, required this.view, required this.scrollController});

  final Map<int, bool> view;
  final ScrollController scrollController;

  @override
  ConsumerState<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends ConsumerState<ExpenseWidget> with Func {
  final _expenseformKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();

  DateTime? selectedDate = DateTime.now();

  int selectedItem = 0;

  final TextEditingController subcategoryController = TextEditingController();

  String? dropdownValue;

  final TextEditingController filenameController = TextEditingController();

  Set<Receipt> receipts = {};

  bool show = false;

  List<Uint8List> files = [];

  late double _distanceToField;

  late StringTagController _descriptionController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.view[1]!,
      child: Form(
        key: _expenseformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Expense...',
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: amountController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter amount';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                hintText: 'enter a value...  ',
                suffix: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM').format(selectedDate!),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate!,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            const TitleWidget(
              title: 'Select Category...',
              clr: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
              ),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedItem = index;
                    });
                  },
                  child: ExpenseCategoryItem(
                    index: index,
                    selectedItem: selectedItem,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: subcategoryController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a subcategory';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                hintText: 'enter a subcategory...  ',
              ),
            ),
            const TitleWidget(
              title: 'Select Payment Method...',
              clr: Colors.black,
            ),
            DropdownButton(
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              ),
              value: dropdownValue,
              items:
                  paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
            ),
            // RECEIPT - UPLOAD FILE AND DISPLAY THUMBNAIL
            ListTile(
              title:
                  const TitleWidget(title: 'Add Receipt...', clr: Colors.black),
              trailing: IconButton(
                  iconSize: 30,
                  color: Colors.teal,
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(type: FileType.any);

                    if (result != null) {
                      setState(() {
                        show = true;
                      });
                      if (context.mounted) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Enter File Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal,
                                  ),
                                ),
                                content: TextField(
                                  controller: filenameController,
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => uploadFile(result),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal),
                                    child: const Text(
                                      'Save',
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      filenameController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.teal)),
                                  )
                                ],
                              );
                            });
                      }
                    }
                  },
                  icon: const Icon(Icons.upload_file_outlined)),
            ),
            Visibility(
              visible: show,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            ),
            GridView.builder(
              itemCount: files.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Image.memory(files[index]);
              },
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
              ),
            ),
            const TitleWidget(title: 'Notes...', clr: Colors.black),
            // TODO - TAGS

            TextFieldTags<String>(
              textfieldTagsController: _descriptionController,
              initialTags: const [],
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (tag.isEmpty) {
                  return 'Please enter tag';
                }
                return null;
              },
              inputFieldBuilder: (context, inputFieldValues) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onTap: () {
                      _descriptionController.getFocusNode?.requestFocus();
                    },
                    controller: inputFieldValues.textEditingController,
                    focusNode: inputFieldValues.focusNode,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 74, 137, 92),
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 74, 137, 92),
                          width: 3.0,
                        ),
                      ),
                      // helperText: 'Enter tags...',
                      // helperStyle: const TextStyle(
                      //   color: Colors.teal,
                      // ),
                      hintText: inputFieldValues.tags.isNotEmpty
                          ? ''
                          : "Enter tag...",
                      errorText: inputFieldValues.error,
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: _distanceToField * 0.74),
                      prefixIcon: inputFieldValues.tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller: inputFieldValues.tagScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 8,
                                ),
                                child: Wrap(
                                    runSpacing: 4.0,
                                    spacing: 4.0,
                                    children:
                                        inputFieldValues.tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                //print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                inputFieldValues
                                                    .onTagRemoved(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                              ),
                            )
                          : null,
                    ),
                    onChanged: inputFieldValues.onTagChanged,
                    onSubmitted: inputFieldValues.onTagSubmitted,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50)),
                onPressed: () async {
                  if (_expenseformKey.currentState!.validate()) {
                    await createExpense(
                        double.parse(amountController.text),
                        selectedDate!,
                        CategoryEnum.values[selectedItem],
                        subcategoryController.text,
                        receipts,
                        _descriptionController.getTags!,
                        dropdownValue!);

                    if (context.mounted) {
                      StatusAlert.show(context,
                          duration: const Duration(seconds: 2),
                          title: 'Expense Tracker',
                          subtitle: 'Expense added!',
                          configuration:
                              const IconConfiguration(icon: Icons.done),
                          maxWidth: 260);
                    }
                    resetForm();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadFile(FilePickerResult result) async {
    Navigator.pop(context);
    File file = File(result.files.single.path!);

    String appPath = await getPath();

    List<String> nameAndExtension = result.files.single.name.split(".");

    final reversed = nameAndExtension.reversed.toList();

    final filename =
        '${filenameController.text}_${DateFormat('d_MM_yyy').format(selectedDate!)}.${reversed[0]}';

    filenameController.clear();

    File newFile = await file.copy('$appPath/$filename');
    Uint8List imageBytes = await newFile.readAsBytes();
    files.add(imageBytes);

    final receipt = Receipt()..name = filename;
    receipts.add(receipt);

    show = false;
    setState(() {});
  }

  resetForm() {
    amountController.clear();
    subcategoryController.clear();
    receipts.clear();
    files.clear();
    _descriptionController.clearTags();

    setState(() {
      selectedItem = 0;
      dropdownValue = null;
      selectedDate = DateTime.now();
    });

    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }
}
