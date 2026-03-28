import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';
import '../widgets/fund_card.dart';
import '../widgets/action_button.dart';
import '../widgets/member_item.dart';
import '../widgets/quick_link.dart';
import '../widgets/stat_circle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isRightPanelExpanded = true;

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            Row(
              children: [
                _buildLeftPanel(context, appData),
                _buildRightPanel(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel(BuildContext context, dynamic appData) {
    return Expanded(
      flex: _isRightPanelExpanded ? 7 : 10,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FundCard(amount: appData.totalFund),
                      const SizedBox(height: 20),
                      _buildActionButtons(context),
                      const SizedBox(height: 20),
                      _buildMemberList(appData),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Text(
          '🍽️ 干饭基金',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const Spacer(),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(_isRightPanelExpanded ? Icons.menu_open : Icons.menu),
          onPressed: _togglePanel,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            icon: Icons.add_circle_outline,
            label: '充值',
            color: const Color(0xFF00B894),
            onTap: () => Navigator.pushNamed(context, '/recharge'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActionButton(
            icon: Icons.remove_circle_outline,
            label: '消费',
            color: const Color(0xFFFF7675),
            onTap: () => Navigator.pushNamed(context, '/consume'),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList(dynamic appData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '👥 成员列表',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF636E72),
              ),
            ),
            Text(
              '(${appData.members.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...appData.members.map((member) => MemberItem(
              name: member.name,
              contribution: member.contribution,
            )),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    return Expanded(
      flex: _isRightPanelExpanded ? 3 : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isRightPanelExpanded ? 1 : 0,
        child: _isRightPanelExpanded
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildQuickActions(context),
                                const SizedBox(height: 20),
                                _buildTodayStats(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('快捷操作'),
        QuickLink(
          icon: Icons.bar_chart,
          label: '统计报表',
          onTap: () => Navigator.pushNamed(context, '/history'),
        ),
        QuickLink(
          icon: Icons.file_download,
          label: '导出数据',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导出功能开发中...')),
              ),
        ),
        QuickLink(
          icon: Icons.settings,
          label: '设置',
          onTap: () => Navigator.pushNamed(context, '/members'),
        ),
      ],
    );
  }

  Widget _buildTodayStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('今日概况'),
        Column(
          children: [
            Center(
              child: StatCircle(
                label: '今日增加',
                value: ref.read(appDataProvider.notifier).getTodayRecharge(),
                color: const Color(0xFF00B894),
                isIncome: true,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: StatCircle(
                label: '今日消费',
                value: ref.read(appDataProvider.notifier).getTodayConsume(),
                color: const Color(0xFFFF7675),
                isIncome: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB2BEC3),
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _togglePanel() {
    setState(() {
      _isRightPanelExpanded = !_isRightPanelExpanded;
    });
  }
}
