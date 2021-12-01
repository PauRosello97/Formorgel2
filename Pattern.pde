class Pattern{
  ArrayList<Line> linies = new ArrayList<Line>();
  ArrayList<Node> intersections = new ArrayList<Node>();
  ArrayList<Polygon> polygon = new ArrayList<Polygon>();
  
  Pattern(ArrayList<JSONObject> jsonPatterns){
    addPattern(jsonPatterns);
    findintersections();
    //logNodeArray(intersections);
    generatePolygons();
  }
  
  void draw(){

    noStroke();
    for(int i = 0; i<polygon.size(); i++){ polygon.get(i).draw(); }
    
    for(int i = 0; i<intersections.size(); i++){
      intersections.get(i).draw();
    }
    
    strokeWeight(1);
    for(int i = 0; i<linies.size(); i++){ linies.get(i).draw();  }

  }
  
  void addPattern(ArrayList<JSONObject> jsons){
    float k = width/120.0;

    for(int j=0; j<jsons.size(); j++){
      JSONArray jsonLines = jsons.get(j).getJSONArray("lines");

      for(int i=0; i<jsonLines.size(); i++){
          JSONObject jsonLine = jsonLines.getJSONObject(i);
          JSONArray jsonStart = jsonLine.getJSONArray("start");
          JSONArray jsonEnd = jsonLine.getJSONArray("end");

          int[] start = jsonStart.getIntArray();
          int[] end = jsonEnd.getIntArray();

          linies.add(new Line(new PVector(k*start[0], k*start[1]), new PVector(k*end[0], k*end[1])));
      }
    }
  }  

  /* ----------------------- FIND INTERSECTIONS ----------------------- */

  void findintersections(){
    intersections = new ArrayList<Node>();
    //Afegim totes les interseccions a l'array.
    for(int i = 0; i<linies.size(); i++){
      for(int j=i+1; j<linies.size(); j++){
        if(linies.get(i).intersects_at(linies.get(j))!=null){
          PVector intersection = linies.get(i).intersects_at(linies.get(j));
          Line[] intersectionLines = {linies.get(i), linies.get(j)};
          intersections.add(new Node(intersection.x, intersection.y, intersectionLines) );
        }
      }
    }

    //Eliminem les interseccions que estan a fora
    for(int i = 0; i<intersections.size(); i++){
      if(intersections.get(i).pos.x<0 || intersections.get(i).pos.x>width || intersections.get(i).pos.y<0 || intersections.get(i).pos.y>height ){
        intersections.remove(i);
        i--;
      }
    }
    
    Collections.sort(intersections);
    // We merge repeated intersections
    for(int i=0; i<intersections.size(); i++){
      for(int j=0; j<intersections.size(); j++){
        if(i!=j && intersections.get(i).pos.x == intersections.get(j).pos.x && intersections.get(i).pos.y == intersections.get(j).pos.y){
          intersections.get(j).merge(intersections.get(i));
          intersections.remove(i);
          if(i>0) i--;
        }
      }
    }

  }
  
  /* ----------------------- GENERATE POLYGONS ------------------------ */
  void generatePolygons(){
    polygon = new ArrayList<Polygon>();
    
    for(int i = 0; i<intersections.size(); i++){
      ArrayList<Node> oldPath = new ArrayList<Node>();
      oldPath.add(intersections.get(i));
      followPath(oldPath);
    }

    
    //Eliminem els poligons que continguin altres poligons
    Collections.sort(polygon);
    
    for(int i = 0; i<polygon.size(); i++){
      for(int j=i+1; j<polygon.size(); j++){
        if(nodesEnComu(polygon.get(i), polygon.get(j))>2){
          polygon.remove(i);
          i--;
          j=polygon.size();
        }
      }
    }

    //--------- ORDENEM ELS POLÍGONS
    //polygon.sort(function(a, b){return b.calculaArea() - a.calculaArea()});  

    //--------- ELIMINEM POLÍGONS QUE CONTINGUIN PUNTS
    for(int i = 0; i<polygon.size(); i++){
      for(int j=0; j<intersections.size(); j++){
        if(nodeDinsPoli(intersections.get(j), polygon.get(i))){
          polygon.remove(i);
          i--;
          j=intersections.size();
        }
      }
    }
    
  }
  
  void followPath(ArrayList<Node> oldPath){
    ArrayList<Node> path = new ArrayList<Node>();
    //logPath(oldPath);
    for(int i=0; i<oldPath.size(); i++){
      path.add(oldPath.get(i));
    }

    Node lastNode = path.get(path.size()-1);

    // Agafem les linies que formen la intersecció.
    // Agafem els nodes que estan connectats al node on ens trobem
    ArrayList<Node> punts = new ArrayList<Node>();
    for(Line line : lastNode.lines){
      ArrayList<Node> otherNodes = getAdjacentNodes(lastNode, line);
      for(Node node : otherNodes){
        punts.add(node);
      }
    }
       
    for(Node punt : punts){

        ArrayList<Node> newPath = new ArrayList<Node>();
        for(int j=0; j<path.size(); j++){
          newPath.add(path.get(j));
        }
        newPath.add(punt);  
        
        if(newPath.get(0)==newPath.get(newPath.size()-1)){
          if(newPath.size()>3){
            afegeixPolygon(newPath);
          }
        }else if(!repeatedLine(newPath)){
          followPath(newPath);
          
        }
    }
  } 

  // Returns true if a line has been repeated too many times.
  boolean repeatedLine(ArrayList<Node> path){
    
    int[] repetitions = new int[linies.size()];

    // We initialize the repetitions array.
    for(int i = 0; i<linies.size(); i++) repetitions[i] = 0;


    for(Node node : path){
      for(Line line : node.lines){
        repetitions[linePosition(line)]++;
      }
    }

    boolean tooManyRepetitions = false;

    for(int i = 0; i<repetitions.length; i++){
      if(repetitions[i]>2){
        tooManyRepetitions = true;
      }
    }

    return tooManyRepetitions;
  }
  
  void afegeixPolygon(ArrayList<Node> path){
    Polygon newPoly = new Polygon(path);
    newPoly.ordenaPath();
    polygon.add(newPoly);
    polygon.get(polygon.size()-1).ordenaPath();
  }
  
  boolean sonElMateix(Node punt1, Node punt2){
    boolean son_el_mateix = true;
    if(abs(punt1.pos.x-punt2.pos.x)>0.0000001){
      son_el_mateix=false;
    }else if(abs(punt1.pos.y-punt2.pos.y)>0.0000001){
      son_el_mateix=false;
    }
    return son_el_mateix;
  }
  
  // This function returns the adjacent node to a given node of a line.
  ArrayList<Node> getAdjacentNodes(Node node, Line line){

    ArrayList<Node> otherNodes = new ArrayList<Node>();
    // Iterate through all intersections
    for(Node intersection : intersections){
      // Except this one
      if(intersection != node){
        // If the intersection contains this line
        for(Line l : intersection.lines){
          // Add the intersection to the list
          if(l == line) otherNodes.add(intersection);
        }
      }
    }

    ArrayList<Node> adjacentNodes = new ArrayList<Node>();

    // We iterate through all the other points
    for(Node nodeA : otherNodes){
      // And compare to the other ones
      boolean adjacent = true;
      for(Node nodeB : otherNodes){
        // If B is between node and nodeA, then node and nodeA are not adjacent.
        if(nodeA != nodeB && estaAlMig(node, nodeA, nodeB)) adjacent = false;
      }
      // If they are adjacent, we add them to the list.
      if(adjacent) adjacentNodes.add(nodeA);
    }

    return adjacentNodes;
  }  
  
  // Returns true if C is between A and B
  boolean estaAlMig(Node na, Node nb, Node nc){
    boolean esta_al_mig = false;

    PVector a = na.pos;
    PVector b = nb.pos;
    PVector c = nc.pos;

    if(((c.x>a.x&&c.x<b.x)||(c.x<a.x&&c.x>b.x) ) && ((c.y>a.y&&c.y<b.y)||(c.y<a.y&&c.y>b.y))){
      esta_al_mig = true;
    }else if((c.x==a.x) && ((c.y>a.y&&c.y<b.y)||(c.y<a.y&&c.y>b.y))){
      esta_al_mig = true;
    }else if((c.y==a.y) && ((c.x>a.x&&c.x<b.x)||(c.x<a.x&&c.x>b.x))){
      esta_al_mig = true;
    }
    
    return esta_al_mig;
  }

  int linePosition(Line line){
    for(int i = 0; i<linies.size(); i++){
      if(linies.get(i)==line){
        return i;
      }
    }
    return -1;
  }

  boolean jaExisteix(Polygon pol){
    boolean ja_existeix = false;
    //Recorrem tots els polígons
    for(int i = 0; i<polygon.size(); i++){
      //Comencem considerant que si que existeix.
      boolean es_igual_1 = true;
      boolean es_igual_2 = true;
      
      int l = polygon.get(i).path.size();
      
      //Mirem si els dos polígons tenen el mateix nombre de nodes.
      if(l==pol.path.size()){
        //Recorrem cada posició del polígon i.
        for(int j=0; j<l; j++){
          if(pol.path.get(j).pos!=polygon.get(i).path.get(j).pos){
            es_igual_1 = false;
          }
          if(pol.path.get(0).pos!=polygon.get(i).path.get(0).pos){
            es_igual_2 = false;
          }
          if(j!=0){
            if(pol.path.get(j).pos!=polygon.get(i).path.get(l-j).pos){
              es_igual_2 = false;
            }
          }
        }
      }else{
        // Si no tenen el mateix nombre de nodes, podem dir que no són 
        // el mateix polígon.
        es_igual_1 = false;
        es_igual_2 = false;
      }
      if(es_igual_1 || es_igual_2){
        ja_existeix = true;
      }
    }
    return ja_existeix;
  }
  
  int nodesEnComu(Polygon pol1, Polygon pol2){
    int nodes_en_comu = 0;
    for(int i = 0; i<pol1.path.size(); i++){
      for(int j=0; j<pol2.path.size(); j++){
        if(pol1.path.get(i)==pol2.path.get(j)){
          nodes_en_comu++;
        }
      }
    }
    return nodes_en_comu;
  }
  
  boolean checkcheck (float x, float y, float[] cornersX, float[] cornersY) {
      int i, j=cornersX.length-1 ;
      boolean odd = false;

      float[] pX = cornersX;
      float[] pY = cornersY;

      for (i=0; i<cornersX.length; i++) {
          if ((pY[i]< y && pY[j]>=y ||  pY[j]< y && pY[i]>=y)
              && (pX[i]<=x || pX[j]<=x)) {
                odd ^= (pX[i] + (y-pY[i])*(pX[j]-pX[i])/(pY[j]-pY[i])) < x; 
          }

          j=i; 
      }
    return odd;
  }
  
  boolean nodeDinsPoli(Node node, Polygon poli){
    float[] cornersX = new float[poli.path.size()];
    float[] cornersY = new float[poli.path.size()];

    for(int i = 0; i<poli.path.size(); i++){
      cornersX[i] = poli.path.get(i).pos.x;
      cornersY[i] = poli.path.get(i).pos.y;
    }

    boolean forma_part_del_path = false;
    for(int i = 0; i<poli.path.size(); i++){
      if(node == poli.path.get(i)){
        forma_part_del_path = true;
      }
    }

    if(forma_part_del_path){
      return false;
    }else{
      return checkcheck(node.pos.x, node.pos.y, cornersX, cornersY);
    }  
  }
}
