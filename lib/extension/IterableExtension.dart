extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) checkCondition) {
    for (E element in this) {
      if (checkCondition(element)) return element;
    }
    return null;
  }
}

extension MapUtils<K, V> on Map<K, V> {
  MapEntry<K, V>? entryWhereOrNull(bool Function(K, V) condition) {
    return entries.firstWhereOrNull((p0) => condition(p0.key, p0.value));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension IsNotNullOrEmpty<E> on Iterable<E>? {
  bool isNotNullOrEmpty() {
    if (this != null && this!.isNotEmpty) {
      return true;
    }
    return false;
  }
}
