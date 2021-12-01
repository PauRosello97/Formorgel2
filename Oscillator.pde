class Oscilator{
  Oscilator(){
    
  }
  
  ArrayList<Line> getLines(){
    ArrayList<Line> lines = new ArrayList<Line>();
    for (int i=0; i<10; i++){
      PVector start = new PVector(random(width), random(height));
      PVector end = new PVector(random(width), random(height));
      lines.add(new Line(start, end));
    }
    return lines;
  }
}
