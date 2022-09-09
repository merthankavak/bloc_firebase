part of 'tab_cubit.dart';

class TabState extends Equatable {
  final int tabIndex;

  const TabState({
    required this.tabIndex,
  });

  factory TabState.initial() {
    return const TabState(tabIndex: 0);
  }

  @override
  List<Object> get props => [tabIndex];

  TabState copyWith({
    int? tabIndex,
  }) {
    return TabState(
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  String toString() => 'TabState(tabIndex: $tabIndex)';
}
