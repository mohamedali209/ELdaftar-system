class DrawerItemModel {
  final String title;
  final String image;
  final void Function()? onTap;


const  DrawerItemModel( {this.onTap,required this.title, required this.image});
}