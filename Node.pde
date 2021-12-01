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
      text("[" + this.pos.x + ", " + this.pos.y + "]", this.pos.x + 30 , this.pos.y +30);
    }

    void merge(Node node) {
      for(Line line : node.lines){
        if(!lines.contains(line)) lines.add(line);
      }
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
