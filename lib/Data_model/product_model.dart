class Productlist {
  int? id;
  String? name;
  String? category;
  String? imageUrl;
  String? oldPrice;
  String? price;

  Productlist(
      {this.id,
      this.name,
      this.category,
      this.imageUrl,
      this.oldPrice,
      this.price});

  Productlist.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    imageUrl = json['imageUrl'];
    oldPrice = json['oldPrice'];
    price = json['price'];
  }

//  Map<String,dynamic> toJson()
//  {
//   final Map<String,dynamic> data=Map<String,dynamic>();
//   data['id']=id;
//   data['name']=name;
//   data['category']=category;
//   data['imageUrl']=imageUrl;
//   data['oldPrice']=oldPrice;
//   data['price']=price;

//   return data;

//  }

//  Future <List<Productlist>> readjsondata ()
//   async {
//     final jsondata=await rootBundle.rootBundle.loadString('Data/products.json');
//     final list=jsonDecode(jsondata) as List<dynamic>;

//   return list.map((e) =>Productlist.fromjson(e)).toList();
//   }
}
