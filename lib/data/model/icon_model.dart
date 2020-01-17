class IconModel {
  final String path;
  final String category;

  IconModel(this.path, this.category);

  @override
  bool operator ==(other) =>
      other is IconModel && other.path == path && other.category == category;

  @override
  int get hashCode => category.hashCode ^ path.hashCode;
}
