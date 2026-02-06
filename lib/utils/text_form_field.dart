Function(String?) isNotEmpty(String errorMessage) {
  return (value) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  };
}
