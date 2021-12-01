void logNodeArray(ArrayList<Node> nodes){
    for(int i=0; i<nodes.size(); i++){
      println(i + " - " + nodeToString(nodes.get(i)));
    }
}
  
void printPath(ArrayList<Node> path){
    String message = "";
    for(int i=0; i<path.size(); i++){
      message += nodeToString(path.get(i));
    }
    println(message);
}

String nodeToString(Node node){
    if(node!=null){
      return "[" + node.pos.x + ", " + node.pos.y + "]";
    }
    return "[null]";
}
