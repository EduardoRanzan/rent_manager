import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_repository.dart';
import 'package:rent_manager/database/repositories/properties/properties_repository.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  static String routeName = '/report';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ExpensesRepository _expensesRepository = ExpensesRepository();
  final PropertiesRepository _propertiesRepository = PropertiesRepository();
  final NumberFormat _currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  List<ExpensesModel> _expenses = [];
  List<PropertiesModel> _properties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final report = _buildReportData();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Relatórios',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Acompanhe receitas, despesas e ocupação dos imóveis em um só lugar.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle(context, 'Resumo geral'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _summaryCard(
                  context: context,
                  title: 'Receita mensal',
                  value: _currency.format(report.monthlyRevenue),
                  subtitle: '${report.rentedProperties} imóveis alugados',
                  icon: Icons.trending_up,
                  color: theme.colorScheme.tertiary,
                ),
                _summaryCard(
                  context: context,
                  title: 'Despesas do mês',
                  value: _currency.format(report.currentMonthExpenses),
                  subtitle: '${report.currentMonthExpensesCount} lançamentos',
                  icon: Icons.receipt_long,
                  color: theme.colorScheme.primary,
                ),
                _summaryCard(
                  context: context,
                  title: 'Saldo estimado',
                  value: _currency.format(report.estimatedBalance),
                  subtitle: 'Receita mensal - despesas do mês',
                  icon: Icons.account_balance_wallet_outlined,
                  color: report.estimatedBalance >= 0
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.error,
                ),
                _summaryCard(
                  context: context,
                  title: 'Despesas vencidas',
                  value: _currency.format(report.overdueExpensesTotal),
                  subtitle: '${report.overdueExpensesCount} contas em atraso',
                  icon: Icons.warning_amber_rounded,
                  color: report.overdueExpensesCount > 0
                      ? theme.colorScheme.error
                      : theme.colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, 'Ocupação'),
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Taxa de ocupação',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${report.occupancyRate.toStringAsFixed(0)}%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: report.occupancyRate / 100,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _metricTile(
                            context,
                            title: 'Total',
                            value: report.totalProperties.toString(),
                            icon: Icons.home_work_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _metricTile(
                            context,
                            title: 'Alugados',
                            value: report.rentedProperties.toString(),
                            icon: Icons.key_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _metricTile(
                            context,
                            title: 'Vagos',
                            value: report.vacantProperties.toString(),
                            icon: Icons.meeting_room_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, 'Alertas'),
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _alertTile(
                      context: context,
                      icon: Icons.error_outline,
                      title: 'Contas vencidas',
                      value:
                          '${report.overdueExpensesCount} | ${_currency.format(report.overdueExpensesTotal)}',
                      color: report.overdueExpensesCount > 0
                          ? theme.colorScheme.error
                          : theme.colorScheme.secondary,
                    ),
                    const Divider(height: 24),
                    _alertTile(
                      context: context,
                      icon: Icons.schedule_outlined,
                      title: 'Vencem nos próximos 7 dias',
                      value:
                          '${report.upcomingExpensesCount} | ${_currency.format(report.upcomingExpensesTotal)}',
                      color: theme.colorScheme.primary,
                    ),
                    const Divider(height: 24),
                    _alertTile(
                      context: context,
                      icon: Icons.payments_outlined,
                      title: 'Potencial máximo de receita',
                      value: _currency.format(report.totalPotentialRevenue),
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, 'Imóveis com maior receita'),
            const SizedBox(height: 12),
            _propertiesRankingCard(report),
            const SizedBox(height: 24),
            _sectionTitle(context, 'Últimas despesas'),
            const SizedBox(height: 12),
            _recentExpensesCard(report.recentExpenses),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final width = (MediaQuery.sizeOf(context).width - 44) / 2;

    return SizedBox(
      width: width,
      child: Card(
        color: theme.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.16),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.16),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _propertiesRankingCard(_ReportData report) {
    final theme = Theme.of(context);

    if (report.topRevenueProperties.isEmpty) {
      return _emptyCard(
        title: 'Nenhum imóvel cadastrado',
        subtitle: 'Cadastre imóveis para acompanhar o potencial de receita.',
      );
    }

    return Card(
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: report.topRevenueProperties.map((property) {
            final isRented = property.isRented;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: (isRented
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.primary)
                    .withValues(alpha: 0.16),
                child: Icon(
                  isRented ? Icons.key : Icons.home_outlined,
                  color: isRented
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.primary,
                ),
              ),
              title: Text(property.name),
              subtitle: Text(isRented ? 'Alugado' : 'Disponível'),
              trailing: Text(
                _currency.format(property.rentPrice),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _recentExpensesCard(List<_ExpenseWithProperty> recentExpenses) {
    final theme = Theme.of(context);

    if (recentExpenses.isEmpty) {
      return _emptyCard(
        title: 'Nenhuma despesa lançada',
        subtitle: 'As despesas mais recentes vão aparecer aqui.',
      );
    }

    return Card(
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: recentExpenses.map((item) {
            final isOverdue = item.expense.deadline.isBefore(_startOfToday());

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: (isOverdue
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary)
                    .withValues(alpha: 0.16),
                child: Icon(
                  isOverdue ? Icons.priority_high : Icons.receipt,
                  color: isOverdue
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              title: Text(item.expense.name),
              subtitle: Text(
                '${item.propertyName} • vence em ${_dateFormat.format(item.expense.deadline)}',
              ),
              trailing: Text(
                _currency.format(item.expense.value),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _emptyCard({
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _loadData() async {
    final expenses = await _expensesRepository.getAll();
    final properties = await _propertiesRepository.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _expenses = expenses;
      _properties = properties;
      _isLoading = false;
    });
  }

  _ReportData _buildReportData() {
    final today = _startOfToday();
    final nextWeek = today.add(const Duration(days: 7));
    final monthStart = DateTime(today.year, today.month, 1);
    final nextMonthStart = DateTime(today.year, today.month + 1, 1);

    final rentedProperties = _properties.where((property) => property.isRented);
    final overdueExpenses = _expenses.where(
      (expense) => expense.deadline.isBefore(today),
    );
    final upcomingExpenses = _expenses.where(
      (expense) =>
          !expense.deadline.isBefore(today) && expense.deadline.isBefore(nextWeek),
    );
    final currentMonthExpenses = _expenses.where(
      (expense) =>
          !expense.date.isBefore(monthStart) && expense.date.isBefore(nextMonthStart),
    );

    final recentExpenses = [..._expenses]..sort(
        (a, b) => b.date.compareTo(a.date),
      );

    final topRevenueProperties = [..._properties]..sort(
        (a, b) => b.rentPrice.compareTo(a.rentPrice),
      );

    return _ReportData(
      totalProperties: _properties.length,
      rentedProperties: rentedProperties.length,
      vacantProperties: _properties.where((property) => !property.isRented).length,
      occupancyRate:
          _properties.isEmpty ? 0 : (rentedProperties.length / _properties.length) * 100,
      monthlyRevenue:
          rentedProperties.fold(0, (sum, property) => sum + property.rentPrice),
      totalPotentialRevenue:
          _properties.fold(0, (sum, property) => sum + property.rentPrice),
      currentMonthExpenses:
          currentMonthExpenses.fold(0, (sum, expense) => sum + expense.value),
      currentMonthExpensesCount: currentMonthExpenses.length,
      overdueExpensesTotal:
          overdueExpenses.fold(0, (sum, expense) => sum + expense.value),
      overdueExpensesCount: overdueExpenses.length,
      upcomingExpensesTotal:
          upcomingExpenses.fold(0, (sum, expense) => sum + expense.value),
      upcomingExpensesCount: upcomingExpenses.length,
      recentExpenses: recentExpenses
          .take(5)
          .map(
            (expense) => _ExpenseWithProperty(
              expense: expense,
              propertyName: _propertyNameById(expense.propertyId),
            ),
          )
          .toList(),
      topRevenueProperties: topRevenueProperties.take(5).toList(),
    );
  }

  String _propertyNameById(int id) {
    final property = _properties.cast<PropertiesModel?>().firstWhere(
          (item) => item?.id == id,
          orElse: () => null,
        );

    return property?.name ?? 'Imóvel não encontrado';
  }

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}

class _ReportData {
  _ReportData({
    required this.totalProperties,
    required this.rentedProperties,
    required this.vacantProperties,
    required this.occupancyRate,
    required this.monthlyRevenue,
    required this.totalPotentialRevenue,
    required this.currentMonthExpenses,
    required this.currentMonthExpensesCount,
    required this.overdueExpensesTotal,
    required this.overdueExpensesCount,
    required this.upcomingExpensesTotal,
    required this.upcomingExpensesCount,
    required this.recentExpenses,
    required this.topRevenueProperties,
  });

  final int totalProperties;
  final int rentedProperties;
  final int vacantProperties;
  final double occupancyRate;
  final double monthlyRevenue;
  final double totalPotentialRevenue;
  final double currentMonthExpenses;
  final int currentMonthExpensesCount;
  final double overdueExpensesTotal;
  final int overdueExpensesCount;
  final double upcomingExpensesTotal;
  final int upcomingExpensesCount;
  final List<_ExpenseWithProperty> recentExpenses;
  final List<PropertiesModel> topRevenueProperties;

  double get estimatedBalance => monthlyRevenue - currentMonthExpenses;
}

class _ExpenseWithProperty {
  _ExpenseWithProperty({
    required this.expense,
    required this.propertyName,
  });

  final ExpensesModel expense;
  final String propertyName;
}
