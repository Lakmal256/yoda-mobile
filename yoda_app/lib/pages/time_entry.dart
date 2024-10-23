import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ext/string.dart';
import '../util/file_pick.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import '../locator.dart';

class TimeTracker extends StatefulWidget {
  const TimeTracker({Key? key}) : super(key: key);

  @override
  State<TimeTracker> createState() => _TimeTrackerState();
}

var filesMock = [
  AttachedFile(file: File(""), name: 'assets/images/icons.doc', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.docx', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.pdf', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.xlsx', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.xls', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.jpg', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.jpeg', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons.png', size: 1024),
  AttachedFile(file: File(""), name: 'assets/images/icons', size: 1024),
];

class _TimeTrackerState extends State<TimeTracker> {
  // final timeEntryFormController = TimeEntryFormController(initialValue: TimeEntryFormValue(files: filesMock));
  final timeEntryFormController = TimeEntryFormController();

  Future<List<ProjectDto>?>? projects;
  Future<List<EpicDto>?>? epics;
  Future? createAction;

  @override
  void initState() {
    _fetchProjects();
    super.initState();
  }

  _fetchProjects() {
    setState(() {
      projects = locate<RestService>().fetchProjects();
    });
  }

  _fetchEpics(ProjectDto? project) {
    if (project != null) {
      setState(() {
        epics = locate<RestService>().fetchEpicsByProjectId(project.id!);
      });
    }
  }

  List<String> _validate() {
    timeEntryFormController.resetErrors();
    final value = timeEntryFormController.value;

    if (value.project == null) {
      timeEntryFormController.setError(
        TimeEntryForm.project,
        "Project is required",
      );
    }

    if (value.epic == null) {
      timeEntryFormController.setError(
        TimeEntryForm.epic,
        "Epic is required",
      );
    }

    if (value.date == null) {
      timeEntryFormController.setError(
        TimeEntryForm.date,
        "Start Date is required",
      );
    }

    try {
      if (value.hours == null) {
        timeEntryFormController.setError(
          TimeEntryForm.hours,
          "Hours is required",
        );
      } else if (value.dHours == 0) {
        timeEntryFormController.setError(
          TimeEntryForm.hours,
          "Hours cannot be '0'",
        );
      }
    } on FormatException {
      timeEntryFormController.setError(
        TimeEntryForm.hours,
        "Invalid hours",
      );
    }

    /// Task Validations
    ///   - Should be mandatory.
    ///   - Should be able to type up to 50 words.
    ///   - Minimum 1 word.
    ///     - If one word is entered for the task,
    ///       the word should consist of at least 3 letters

    if (value.task == null || value.task!.trim().isEmpty) {
      timeEntryFormController.setError(
        TimeEntryForm.task,
        "Task is required",
      );
    }

    int taskWordCount = (value.task ?? "").countWords();
    if (taskWordCount > 50) {
      timeEntryFormController.setError(
        TimeEntryForm.task,
        "Please Limit Your Word Count To 50 Words",
      );
    }

    if (taskWordCount == 1) {
      int letterCount = (value.task ?? "").countCharacters();
      if (letterCount < 3) {
        timeEntryFormController.setError(
          TimeEntryForm.task,
          "Task should consist of at least 3 characters",
        );
      }
    }

    /// End of Task Validations
    final descriptionWordCount = value.description?.split(" ").length ?? 0;
    if (descriptionWordCount > 500) {
      timeEntryFormController.setError(
        TimeEntryForm.description,
        "Please Limit Your Word Count To 500 Words",
      );
    }

    return value.errors.values.toList();
  }

  Future createTimeEntry() async {
    _validate();

    final value = timeEntryFormController.value;
    final errors = value.errors;
    if (errors.isNotEmpty) return;

    final confirmation = await _showBoolDialog(context);
    if (confirmation == null || !confirmation) return;

    final user = await locate<RestService>().fetchCurrentUser();
    if (user == null) return;
    locate<UserViewService>().user = user;

    final result = await locate<RestService>().createTimeEntry(
      user: user,
      project: value.project!,
      epic: value.epic!,
      date: value.date!,
      minutes: value.dMinutes,
      task: value.task!,
      description: value.description,
      files: value.files.map((file) => file.name).toList(),
    );

    if (result == null) return;

    // Show success dialog and disappear after 1 second
    if (!mounted) return;
    _showSuccessDialog(context);
    Future.delayed(
      const Duration(seconds: 1),
      Navigator.of(context, rootNavigator: true).pop,
    );

    timeEntryFormController.clear();
  }

  handleSubmit() {
    setState(() {
      createAction = createTimeEntry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: "Time Entry"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TimeEntryForm(
                  controller: timeEntryFormController,
                  projects: projects,
                  epics: epics,
                  onProjectChange: _fetchEpics,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: timeEntryFormController.clear,
                      child: const Text("CLEAR"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FutureBuilder(
                      future: createAction,
                      builder: (context, snapshot) {
                        return snapshot.connectionState != ConnectionState.waiting
                            ? ValueListenableBuilder(
                                valueListenable: timeEntryFormController,
                                builder: (context, snapshot, _) => ElevatedButton(
                                  onPressed: timeEntryFormController.isEmpty ? null : handleSubmit,
                                  child: const Text("SUBMIT"),
                                ),
                              )
                            : const SizedBox();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttachedFile {
  File file;
  int size;

  // Name that returned by the upload API
  String name;

  AttachedFile({required this.file, required this.name, required this.size});

  String get humanizedSize => readableFileSize(size, base1024: true);
}

class TimeEntryFormValue {
  ProjectDto? project;
  EpicDto? epic;
  DateTime? date;
  String? hours;
  String? task;
  String? description;
  List<AttachedFile> files;
  Map<String, String> errors;

  TimeEntryFormValue(
      {this.project, this.epic, this.date, this.hours, this.task, this.description, List<AttachedFile>? files})
      : files = files ?? [],
        errors = {};

  // double value of the String [hours].
  double get dHours => double.parse(hours ?? '0');
  double get sDHours => double.tryParse(hours ?? '0') ?? 0.0; // Safe double
  double get dMinutes => sDHours * 60;
}

class TimeEntryFormController extends ValueNotifier<TimeEntryFormValue> {
  TimeEntryFormController({
    TimeEntryFormValue? initialValue,
  }) : super(initialValue ?? TimeEntryFormValue());

  clear() {
    value = TimeEntryFormValue();
  }

  setValue(TimeEntryFormValue newValue) {
    value = newValue;
    notifyListeners();
  }

  setError(String fieldName, String error) {
    value.errors.addAll({fieldName: error});
    notifyListeners();
  }

  resetErrors() {
    value.errors.clear();
    notifyListeners();
  }

  bool _isEmpty() {
    return (value.files.isEmpty) &&
        value.description == null &&
        value.task == null &&
        value.hours == null &&
        value.epic == null &&
        value.project == null &&
        value.date == null;
  }

  bool get isEmpty => _isEmpty();
}

class TimeEntryForm extends StatefulWidget {
  static const project = "0";
  static const epic = "1";
  static const date = "2";
  static const hours = "3";
  static const files = "4";
  static const task = "5";
  static const description = "6";

  TimeEntryForm({
    Key? key,
    this.projects,
    this.epics,
    DateFormat? dateFormat,
    required this.controller,
    required this.onProjectChange,
  })  : dateFormat = dateFormat ?? DateFormat.yMEd(),
        super(key: key);

  final TimeEntryFormController controller;
  final Future<List<ProjectDto>?>? projects;
  final Future<List<EpicDto>?>? epics;
  final Function(ProjectDto?) onProjectChange;
  final DateFormat dateFormat;

  final int maxFileCount = 3;

  /*
    More excel file extensions:
    https://support.microsoft.com/en-us/office/file-formats-that-are-supported-in-excel-0943ff2c-6014-4e8d-aaea-b83d51d46247
  */
  final List<String> acceptedFileExtensions = ["doc", "docx", "pdf", "xlsx", "xls", "jpg", "jpeg", "png"];

  @override
  State<TimeEntryForm> createState() => _TimeEntryFormState();
}

class _TimeEntryFormState extends State<TimeEntryForm> {
  final descriptionController = TextEditingController();
  final taskController = TextEditingController();
  final hoursController = TextEditingController();
  Future? uploaderFuture;
  Stream<UploaderStreamedResponse>? uploaderStream;

  // On form controller is changed private text controllers should
  // update manually (ex. on form clear)
  _handleFormControllerEvent() {
    final value = widget.controller.value;

    final hours = value.hours ?? "";
    hoursController.value = hoursController.value.copyWith(
      text: hours,
    );

    final description = value.description ?? "";
    descriptionController.value = descriptionController.value.copyWith(
      text: description,
    );

    final task = value.task ?? "";
    taskController.value = taskController.value.copyWith(
      text: task,
    );
  }

  setValue(TimeEntryFormValue nextValue) {
    widget.controller.setValue(nextValue);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleFormControllerEvent);
  }

  @override
  void didUpdateWidget(covariant TimeEntryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleFormControllerEvent);
      widget.controller.addListener(_handleFormControllerEvent);
    }
  }

  Widget _buildProjectSelector(BuildContext context) {
    return FutureBuilder(
      future: widget.projects,
      builder: (context, snapshot) {
        return DropdownSelector<ProjectDto>(
          hint: "Project Name",
          isRequired: true,
          isDense: false,
          inputDecoration: InputDecoration(
            errorText: widget.controller.value.errors[TimeEntryForm.project],
          ),
          isBusy: snapshot.connectionState == ConnectionState.waiting,
          isDisabled: snapshot.hasError || !snapshot.hasData,
          value: widget.controller.value.project,
          items: (snapshot.data ?? [])
              .map((item) => DropdownMenuItem<ProjectDto>(
                    value: item,
                    child: Text(item.name!),
                  ))
              .toList(),
          onChange: (value) {
            setValue(widget.controller.value
              ..project = value
              ..epic = null);
            widget.onProjectChange(value);
          },
        );
      },
    );
  }

  Widget _buildEpicSelector(BuildContext context) {
    return FutureBuilder(
      future: widget.epics,
      builder: (context, snapshot) {
        return DropdownSelector<EpicDto>(
          hint: "Epic",
          isRequired: true,
          isDense: false,
          inputDecoration: InputDecoration(
            errorText: widget.controller.value.errors[TimeEntryForm.epic],
          ),
          isBusy: snapshot.connectionState == ConnectionState.waiting,
          isDisabled: snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty,
          value: widget.controller.value.epic,
          items: (snapshot.data ?? [])
              .map((item) => DropdownMenuItem<EpicDto>(
                  value: item,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(item.epicName!),
                  )))
              .toList(),
          onChange: (value) {
            setValue(widget.controller.value..epic = value);
          },
        );
      },
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    String? error = widget.controller.value.errors[TimeEntryForm.date];
    bool isEmpty = widget.controller.value.date == null;
    return GestureDetector(
      child: InputDecorator(
        isEmpty: isEmpty,
        decoration: InputDecoration(
          errorText: error,
          prefixIcon: const Icon(
            Icons.calendar_month_outlined,
          ),
          label: const InputLabel(hint: "Start Date", isRequired: true),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        child: isEmpty
            ? null
            : FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.dateFormat.format(widget.controller.value.date!),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
      ),
      onTap: () async {
        setValue(
          widget.controller.value
            ..date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialDatePickerMode: DatePickerMode.day,
            ),
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextFormField(
      maxLines: 5,
      controller: descriptionController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: widget.controller.value.errors[TimeEntryForm.description],
        label: const InputLabel(hint: "Description"),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setValue(widget.controller.value..description = value);
      },
    );
  }

  Widget _buildTask(BuildContext context) {
    return TextFormField(
      controller: taskController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: widget.controller.value.errors[TimeEntryForm.task],
        label: const InputLabel(hint: "Task", isRequired: true),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setValue(widget.controller.value..task = value);
      },
    );
  }

  Widget _buildHoursField(BuildContext context) {
    return TextFormField(
      controller: hoursController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.access_time_rounded,
          color: Theme.of(context).disabledColor,
        ),
        errorText: widget.controller.value.errors[TimeEntryForm.hours],
        label: const InputLabel(hint: "Hours", isRequired: true),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      onChanged: (value) {
        setValue(widget.controller.value..hours = value);
      },
    );
  }

  showAlert(String message) {
    final controller = locate<PopupController>();
    controller.addItemFor(
        AlertCard(
          message: message,
          onDismiss: (me) => controller.removeItem(me),
        ),
        const Duration(seconds: 5));
  }

  handleUpload() async {
    // Count limitation (3)
    if (widget.controller.value.files.length == widget.maxFileCount) return;

    Source? source = await showSourceSelector(context);
    if (source == null) return;

    File? file = await pickFile(source, extensions: widget.acceptedFileExtensions);
    if (file != null) {
      // Prevent from duplicating
      if (widget.controller.value.files.any((element) => element.file.name == file.name)) {
        showAlert("File already exists");
        return;
      }

      // Block extensions before uploading
      String extension = file.name.split(".").last.toLowerCase();
      if (!widget.acceptedFileExtensions.contains(extension)) {
        showAlert("Unsupported file format");
        return;
      }

      final bytes = await file.readAsBytes();
      setState(() {
        uploaderFuture = (() async {
          final result = await locate<RestService>().uploadAsync(file.name, bytes);
          if (result != null) {
            // Result is the name returned by the API
            setValue(widget.controller.value
              ..files.add(AttachedFile(
                file: file,
                name: result,
                size: file.lengthSync(),
              )));
          }
        }).call();
      });
    }
  }

  handleStreamUpload() async {
    Source? source = await showSourceSelector(context);
    if (source == null) return;
    File? file = await pickFile(source);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(
        () => uploaderStream = locate<RestService>().uploadFileStream(file.name, bytes).asBroadcastStream(),
      );
    }
  }

  handleFileRemove(AttachedFile file) {
    setValue(widget.controller.value..files.remove(file));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Column(
          children: [
            _buildProjectSelector(context),
            const SizedBox(
              height: 20,
            ),
            _buildEpicSelector(context),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDateSelector(context),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: _buildHoursField(context),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _buildTask(context),
            const SizedBox(
              height: 20,
            ),
            _buildDescription(context),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: uploaderFuture,
              builder: (context, snapshot) {
                return UploadContainer(
                  child:
                      (widget.controller.value.files.isNotEmpty || snapshot.connectionState == ConnectionState.waiting)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Text("Attachments"),
                                      ),
                                      if (widget.controller.value.files.length < widget.maxFileCount)
                                        IconButton(
                                          onPressed: handleUpload,
                                          icon: const Icon(Icons.add),
                                        )
                                    ],
                                  ),
                                ),
                                GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(4),
                                  children: [
                                    ...widget.controller.value.files
                                        .map(
                                          (file) => Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: FileIcon(
                                              iconType: IconType.image,
                                              name: file.name,
                                              fileSize: file.humanizedSize,
                                              onRemove: () => handleFileRemove(file),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    if (snapshot.connectionState == ConnectionState.waiting)
                                      const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: FileIcon(name: "", loading: true),
                                      )
                                  ],
                                ),
                              ],
                            )
                          : Center(
                              child: InkWell(
                                onTap: handleUpload,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 25),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.upload_file_outlined,
                                          color: Theme.of(context).colorScheme.secondary,
                                          size: 58,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text("Upload from Mobile or Others"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

_showBoolDialog(BuildContext context) => showDialog(
      context: context,
      barrierColor: Colors.black12,
      useRootNavigator: false,
      builder: (context) => const DialogCard(),
    );

class DialogCard extends StatelessWidget {
  const DialogCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Are you sure you want to submit?",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(true),
                          child: const Center(
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(false),
                          child: const Center(
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_showSuccessDialog(BuildContext context) => showDialog(
      context: context,
      barrierColor: Colors.black12,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const SuccessDialog(),
    );

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 50,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your time entry was successfully submitted",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
