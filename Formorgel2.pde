import java.util.*;
import java.util.Iterator;

int N_LINIES = 20;

JSONObject pattern001, pattern002, pattern003, pattern004, pattern005, pattern006;

Pattern pattern;

void setup(){
  size(900, 900);
  
  colorMode(HSB, 360, 100, 100);

  pattern001 = loadJSONObject("patterns/001_frame.json");
  pattern002 = loadJSONObject("patterns/002_cross.json");
  pattern003 = loadJSONObject("patterns/003_cross2.json");
  pattern004 = loadJSONObject("patterns/004_vertical_cross.json");
  pattern005 = loadJSONObject("patterns/005_lonely_line.json");
  pattern006 = loadJSONObject("patterns/006_broken_triangle.json");
  
  ArrayList<JSONObject> patterns = new ArrayList<JSONObject>();
  patterns.add(pattern001);
  patterns.add(pattern002);
  patterns.add(pattern003);
  patterns.add(pattern004);
  //patterns.add(pattern005);
  //patterns.add(pattern006);
  pattern = new Pattern(patterns);

  background(0, 0, 100);
  pattern.draw();
}
  
void draw(){}
    
