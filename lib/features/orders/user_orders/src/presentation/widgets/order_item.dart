/* 
part of user_orders;

class OrderItem extends StatelessWidget {
  final OrderTest order;
  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _buildOrders(context);
  }

  Widget _orderType(BuildContext context) {
    if (order.status == OrdersConst.KEY_ORDER_CURRENT) {
      return Container(
        // margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: context.appColors.secondary.shade500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'قيد التنفيذ',
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      );
    } else if (order.status == OrdersConst.KEY_ORDER_COMPLETED) {
      return Container(
        // margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: context.appColors.secondary.shade500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'مكتملة',
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _orderStatus(BuildContext context) {
    if (order.status == OrdersConst.KEY_ORDER_UNDER_REVIEW) {
      return Text(
        _orderStatusName(),
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: _orderStatusColor(context),
        ),
      );
    } else if (order.status == OrdersConst.KEY_ORDER_ACCEPTED) {
      return Text(
        _orderStatusName(),
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: _orderStatusColor(context),
        ),
      );
    } else if (order.status == OrdersConst.KEY_ORDER_REJECTED) {
      return Text(
        _orderStatusName(),
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: _orderStatusColor(context),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _orderStatusName(),
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: _orderStatusColor(context),
          ),
        ),
      );
    }
  }

  String _orderStatusName() {
    if (order.status == OrdersConst.KEY_ORDER_UNDER_REVIEW) {
      return 'قيد المراجعة';
    } else if (order.status == OrdersConst.KEY_ORDER_ACCEPTED) {
      return 'تم قبول الطلب العمرة';
    } else if (order.status == OrdersConst.KEY_ORDER_REJECTED) {
      return 'تم رفض طلب العمرة';
    } else {
      return 'تفاصيل';
    }
  }

  Color _orderStatusColor(BuildContext context) {
    if (order.status == OrdersConst.KEY_ORDER_UNDER_REVIEW) {
      return Colors.red; // AppColors.colorTextLogout fallback
    } else if (order.status == OrdersConst.KEY_ORDER_ACCEPTED) {
      return context.appColors.primary.shade400;
    } else if (order.status == OrdersConst.KEY_ORDER_REJECTED) {
      return Colors.red;
    } else {
      return context.appColors.neutral.shade900;
    }
  }

  Widget _buildOrders(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    width: double.infinity,
    // margin: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: context.appColors.primary.shade400,
      borderRadius: BorderRadius.circular(16),
    ),
    child: ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      backgroundColor: context.appColors.primary.shade400,
      collapsedBackgroundColor: context.appColors.primary.shade400,
      onExpansionChanged: (value) {},
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.appColors.neutral.shade900),
        borderRadius: BorderRadius.circular(16),
      ),

      // dense: true,
      // expandedCrossAxisAlignment: CrossAxisAlignment.end,
      // trailing: ,
      tilePadding: const EdgeInsetsDirectional.only(start: 12),
      // expandedAlignment: Alignment.topLeft,
      expansionAnimationStyle: AnimationStyle(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
        reverseCurve: Curves.easeIn,
      ),
      title: Row(
        children: [
          // const Icon(Icons.check_circle, color: context.appColors.neutral.shade900),
          // const SizedBox(width: 8),
          Expanded(
            child: Text(
              'عمره عن ${order.type}',
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
          _orderType(context),
          const SizedBox(width: 8),
          AppSvg(svgPath: AssetPaths.iconCheck),
          const SizedBox(width: 16),
        ],
      ),
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: _buildOrderData(context),
        ),
      ],
    ),
  );

  Widget _buildOrderData(BuildContext context) => Container(
    // margin: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 12),
    padding: const EdgeInsetsDirectional.symmetric(
      vertical: 12,
      horizontal: 14,
    ),
    child: Column(
      children: [
        _dataRow(context, appLocalizer.forWhomOmra, order.type),
        /* Row(
          children: [
            Expanded(
              child: Text(
                appLocalizer.forWhomOmra,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.type,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
         */
        AppDivider(thickness: 1, color: context.appColors.primary.shade400),
        Row(
          children: [
            Expanded(
              child: Text(
                appLocalizer.orderNumber,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.orderNo,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: Text(
                'رقم التسلسلي',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.serialNo,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: Text(
                appLocalizer.beneficiaryNameHint,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.umrahOwnerName,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'صورة المعتمر له',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Image.network(
                order.umrahOwnerImage,
                height: 75,
                width: 75,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: Text(
                'الملاحظات',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                order.note,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: Text(
                'أسم المعتمر',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.pilgrimName,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'صورة المعتمر',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Image.network(
                order.pilgrimImage,
                height: 75,
                width: 75,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                'تاريخ الطلب',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            Text(
              order.date,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary.shade400,
              ),
            ),
          ],
        ),
        const AppDivider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: Text(
                'حالة الطلب',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.primary.shade400,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (order.status == OrdersConst.KEY_ORDER_CURRENT ||
                    order.status == OrdersConst.KEY_ORDER_COMPLETED) {
                  // Routing handled elsewhere in future
                  AppRouteNavigator.push(
                    context,
                    UserOmrahInspectorPage.routeName,
                    const UserOmrahInspectorPage(),
                  );
                }
              },
              child: _orderStatus(context),
            ),
          ],
        ),
        if (order.status == OrdersConst.KEY_ORDER_REJECTED)
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: context.appColors.primary.shade400,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'اختيار معتمر بشكل آلي',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.neutral.shade900,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget _dataRow(
    BuildContext context,
    String title,
    String value, {
    bool isImage = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.appColors.primary.shade400,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
        ),
        if (isImage)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            child: Image.network(
              value,
              height: 75,
              width: 75,
              fit: BoxFit.cover,
            ),
          )
        else
          Text(
            value,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.appColors.primary.shade400,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}
*/
