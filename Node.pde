class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> lines;
    boolean special; // It is special if it has just one neightbor
    int adjacentNodes;
  
    Node(float x, float y, Line[] l) {
      lines = new ArrayList<Line>();
      this.pos = new PVector(x, y);
      this.lines.add(l[0]);
      this.lines.add(l[1]);
    }

    void draw(){
      fill(0);
      if(special) fill(0, 100, 100);
      ellipse(this.pos.x, this.pos.y, 20, 20);
      text(adjacentNodes, pos.x+ 20, pos.y+30);
    }

    void merge(Node node) {
      for(Line line : node.lines){
        if(!lines.contains(line)){
          lines.add(line);
        }
      }
    }

    Line getLineInCommon(Node node){ 
      for(Line line : lines){
        for(Line _line : node.lines){
          if(line == _line) return line;
        }
      }
      return null;
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
