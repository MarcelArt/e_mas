class ApiResponse<T> {
  final T? items;
  final bool isSuccess;
  final String message;

  ApiResponse({
    this.items,
    this.isSuccess = false,
    this.message = '',
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) itemsFromJson,
  ) {
    return ApiResponse<T>(
      items: json['items'] != null ? itemsFromJson(json['items']) : null,
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
    );
  }
}