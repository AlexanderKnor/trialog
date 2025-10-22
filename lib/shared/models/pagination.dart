import 'package:equatable/equatable.dart';

/// Pagination parameters
class Pagination extends Equatable {
  final int page;
  final int pageSize;
  final int? totalCount;
  final int? totalPages;

  const Pagination({
    required this.page,
    required this.pageSize,
    this.totalCount,
    this.totalPages,
  });

  /// Create pagination for first page
  factory Pagination.first({int pageSize = 20}) {
    return Pagination(
      page: 1,
      pageSize: pageSize,
    );
  }

  /// Create next page
  Pagination nextPage() {
    return Pagination(
      page: page + 1,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
    );
  }

  /// Create previous page
  Pagination previousPage() {
    if (page <= 1) return this;
    return Pagination(
      page: page - 1,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
    );
  }

  /// Check if has next page
  bool get hasNextPage {
    if (totalPages == null) return true;
    return page < totalPages!;
  }

  /// Check if has previous page
  bool get hasPreviousPage => page > 1;

  /// Get offset for database queries
  int get offset => (page - 1) * pageSize;

  /// Copy with new values
  Pagination copyWith({
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
  }) {
    return Pagination(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [page, pageSize, totalCount, totalPages];
}

/// Paginated response wrapper
class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final Pagination pagination;

  const PaginatedResponse({
    required this.data,
    required this.pagination,
  });

  @override
  List<Object?> get props => [data, pagination];
}
