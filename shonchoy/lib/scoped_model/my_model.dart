import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/model/personal.dart';

class MyModel extends Model {
  Personal personal;

  void setPersonal(Personal personal) {
    this.personal = personal;
  }
}
