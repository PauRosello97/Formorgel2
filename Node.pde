class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> lines;
  
    Node(float x, float y, Line[] l) {
      lines = new ArrayList<Line>();
      this.pos = new PVector(x, y);
      this.lines.add(l[0]);
      this.lines.add(l[1]);
    }

    void draw(){
      fill(0);
      ellipse(this.pos.x, this.pos.y, 20, 20);
      text("[" + lines.size() + "]", this.pos.x + 10 , this.pos.y +20);
      text("[" + lines.size() + "]", this.pos.x + 10 , this.pos.y -20);
      text("[" + lines.size() + "]", this.pos.x - 10 , this.pos.y +20);
      text("[" + lines.size() + "]", this.pos.x - 10 , this.pos.y -20);
    }

    void merge(Node node) {
      println("MERGE: " + node.pos.x + ", " + node.pos.y);
      for(Line line : node.lines){
        if(!lines.contains(line)){
          println("add");
          lines.add(line);
          println(lines.size());
        }
      }
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
