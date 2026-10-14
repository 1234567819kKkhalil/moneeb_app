part of app_material;

class MultiselectDropDown extends StatefulWidget {
  const MultiselectDropDown({super.key});

  @override
  State<MultiselectDropDown> createState() => _MultiselectDropDownState();
}

class _MultiselectDropDownState extends State<MultiselectDropDown> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
  ];
  List<String> selectedItems = [];

  int progressIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:context.appColors.appBackgroundColor,
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonHideUnderline(
              child: CustomDropdownButton(
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Select Items',
                    style: context.regular.copyWith(
                        color: context.appColors.neutral.shade500,
                        fontSize: Dimensions.normal),
                  ),
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    //disable default onTap to avoid closing menu when selecting an item
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = selectedItems.contains(item);
                        return AppCheckBoxTile(
                          value: isSelected,
                          title: item,
                          onChanged: (value) {
                            isSelected
                                ? selectedItems.remove(item)
                                : selectedItems.add(item);
                            setState(() {});
                            menuSetState(() {});
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
                value: selectedItems.isEmpty ? null : selectedItems.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return items.map(
                    (item) {
                      return Wrap(
                          children: selectedItems.map((e) {
                        return InkWell(
                          onTap: () {
                            selectedItems.remove(e);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: context.appColors.primary.shade900,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 1,
                                  color: context.appColors.appBorderColor,
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(e,
                                    style: context.regular.copyWith(
                                        fontSize: Dimensions.normal,
                                        color: context.appColors.primary.shade500)),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.close,
                                    size: 15, color: context.appColors.primary.shade500),
                              ],
                            ),
                          ),
                        );
                      }).toList());
                    },
                  ).toList();
                },
                dropdownStyleData: DropdownStyleData(
                  maxHeight: MediaQuery.of(context).size.height * .3,
                  elevation: 1,
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all<Color>(
                        context.appColors.primary.shade900),
                    thickness: MaterialStateProperty.all<double>(8),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: context.appColors.neutral.shade50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    color: context.appColors.neutral.shade50,
                    border: Border.all(color: context.appColors.neutral.shade50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 100,
          ),

          Row(
            children: List<Widget>.generate(
                3,
                (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: progressIndex == index ? 40 : 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                    )).toList(),
          ),

          // [].

          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: progressIndex == 0 ? 20 : 40,
            height: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (progressIndex > 2) {
            progressIndex = 0;
          } else {
            progressIndex++;
          }
          setState(() {});
        },
      ),
    );
  }
}
