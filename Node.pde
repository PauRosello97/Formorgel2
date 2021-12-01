class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> linia;
  
    Node(float x, float y, Line[] l) {
      linia = new ArrayList<Line>();
      this.pos = new PVector(x, y);
      this.linia.add(l[0]);
      this.linia.add(l[1]);
    }

    void draw(){
      fill(0);
      ellipse(this.pos.x, this.pos.y, 20, 20);
      text("[" + this.pos.x + ", " + this.pos.y + "]", this.pos.x + 30 , this.pos.y +30);
    }

    void uneix(Node node) {
      if(node.linia.get(0)!=this.linia.get(0)&&node.linia.get(0)!=this.linia.get(1)){
        this.linia.add(node.linia.get(0));
      }else if(node.linia.get(1)!=this.linia.get(0)&&node.linia.get(1)!=this.linia.get(1)){
        this.linia.add(node.linia.get(1));
      }
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
