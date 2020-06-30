import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy_agent/model/agent.dart';

class MyModel extends Model {
  Agent agent;

  void setAgent(Agent agent) {
    this.agent = agent;
  }
}
