import 'package:equatable/equatable.dart';

class Gene<T> extends Equatable {
  const Gene({
    required this.value,
  });

  final T value;

  @override
  List<Object?> get props => [
        value,
      ];
}
