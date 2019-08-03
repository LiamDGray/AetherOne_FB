   //---------- TAB RADIONICSELEMENTS
import controlP5.*;

ControlP5 cp5;

public class RadionicsElements {

  private PApplet p = null;
  private ControlFont fontTextfield;
  private ControlFont font;
  private ControlFont smallFont;
  private CColor c;

  public Integer startAtX;
  public Integer startAtY;
  public Integer usualWidth;
  public Integer usualHeight;

     //----------=====================================
  Dong[][] d;             
  int nx = 12;            
  int ny = 10;
     //----------=====================================

  public RadionicsElements(PApplet p) {

    this.p = p;
    cp5 = new ControlP5(p);

    PFont pfont = createFont("Arial", 11, true);
    font = new ControlFont(pfont, 11);
    fontTextfield = new ControlFont(pfont, 13);
    PFont pSmallFont = createFont("Arial", 10, true);
    smallFont = new ControlFont(pSmallFont, 10);

    c = new CColor();
    c.setBackground(color(43, 0, 118));
    c.setActive(color(0, 0, 0));
    c.setForeground(color(255, 125, 0));
  }
     //---------- add 25 febr. vanaf regel 42 tm regel 55
  public void setValue(String objectName, Float value) {
        if (cp5 != null) {
            cp5.get(objectName).setValue(value);
        }
    }

    public Float getValue(String objectName) {
        if (cp5 != null) {
            return cp5.get(objectName).getValue();
        }

        return null;
    }
    
     //----------==================================================
  public RadionicsElements initPeggotty(int xx, int yy) {
       

      
    Matrix m = cp5.addMatrix("peggotty")
      .setPosition(xx, yy)  
      .setSize (210, 188)  
      .setGrid(nx, ny)
      .setGap(5, 5) 
      .setInterval(160)
      .setMode(ControlP5.MULTIPLES)
      .setColorBackground(color (19, 33, 99))  
      .setBackground(color (0, 21));      

    m.getCaptionLabel().set("");

    cp5.getController("peggotty").getCaptionLabel().setFont(font).alignX(CENTER);

      

    d = new Dong[nx][ny];
    for (int x = 0; x<nx; x++) {
      for (int y = 0; y<ny; y++) {
        d[x][y] = new Dong();
      }
    }  
    noStroke();
    smooth();

    return this;
  }
     //----------=======================================
   public RadionicsElements addSlider(String text, int range) {
        addSlider(text, startAtX, startAtY, usualWidth, usualHeight, range);
        startAtY += usualHeight + 3;
        return this;
    }
    
    public RadionicsElements addSlider(String text, int x, int y, int w, int h, int range) {
    cp5.addSlider(text)
      .setPosition(x, y)
      .setSize(w, h)
      .setRange(0, range);

    return this;
  }

  public RadionicsElements addButton(String text) {
    addButton(text, 0, startAtX, startAtY, usualWidth, usualHeight);
    startAtY += usualHeight + 3;
    return this;
  }

  public RadionicsElements addButtonHorizontal(String text) {
    addButton(text, 0, startAtX, startAtY, usualWidth, usualHeight);
    startAtX += usualWidth + 3;
    return this;
  }

  public void addButton(String text, int value, int x, int y, int w, int h) {
    cp5.addButton(text)
      .setFont(font)
      .setValue(value)
      .setPosition(x, y)
      .setSize(w, h)
      .setColor(c);
  }

public RadionicsElements addTextField(String textfieldName, boolean focus) {

        addTextField(textfieldName, startAtX, startAtY, usualWidth, usualHeight, focus);
        startAtY += usualHeight + 3;

        return this;
    }
    
  public RadionicsElements addTextField(String textfieldName, int x, int y, int w, int h, boolean focus) {

    cp5.addTextfield(textfieldName)
      .setPosition(x, y)
      .setSize(w, h)
      .setFont(font)
      .setFocus(focus)
      .setColor(c)
      .setColorCursor(255)
      .setLabel("");

    return this;
  }

public RadionicsElements addKnob(String name, int radius, int rangeStart, int rangeEnd, int value, Colors colors) {

        addKnob(name, startAtX, startAtY, radius, rangeStart, rangeEnd, value, colors);
        startAtX += usualWidth + 3;
        return this;
    }
    
  public RadionicsElements addKnob(String name, int x, int y, int radius, int rangeStart, int rangeEnd, int value, Colors colors) {

    if (colors == null) colors = new Colors();

    cp5.addKnob(name)
      .setRange(rangeStart, rangeEnd)
      .setValue(value)
      .setPosition(x, y)
      .setRadius(radius)
      .setNumberOfTickMarks(10)
      .setTickMarkLength(4)
      .setColorActive(color(colors.aRed, colors.aGreen, colors.aBlue))
      .setColorBackground(color(colors.bRed, colors.bGreen, colors.bBlue))
      .setColorForeground(color(colors.fRed, colors.fGreen, colors.fBlue))
      .setDragDirection(Knob.HORIZONTAL);

    return this;
  }

  public void clearDials() {
    for (int i=0; i<12; i++) {
      cp5.get(Knob.class, "R" + (i + 1)).setValue(0);
      cp5.get(Knob.class, "A" + (i + 1)).setValue(0);
    }
  }
  
     //----------add dd 17 febr.
  
  public void generateRateForDials() {    
    for (int i=0; i<18; i++) {  
    float r = random(100);
    
      cp5.get(Knob.class, "R" + (i + 1)).setValue(1-100);   
      cp5.get(Knob.class, "A" + (i + 1)).setValue(1-360);  
    }
  }
  
     //----------end add 17 febr.
  
  public String getRatesFromDials() {
    String rate = "";
    
    if (cp5.get(Knob.class, "amplifier").getValue() > 0) {
      rate = "A" + (int) cp5.get(Knob.class, "amplifier").getValue();
    }
    
    for (int i=0; i<12; i++) {
      if (rate.length() > 0) rate += ".";
      rate += (int) cp5.get(Knob.class, "R" + (i + 1)).getValue();
    }
    return rate;
  }
}

public class Colors {
  public int fRed = 255;
  public int fGreen = 255;
  public int fBlue = 255;

  public int bRed = 0;
  public int bGreen = 45;
  public int bBlue = 90;

  public int aRed = 120;
  public int aGreen = 0;
  public int aBlue = 0;
}

   //---------- add 26 feb
public class AnalysisData {

   public String intention;    
   public String rateList;     
}  
public class BroadCastData {

    public Boolean clear = false;       
    public String intention;           
    public String signature;            
    public String ratefromdials;
    public Integer delay = 25;          
    public Integer repeat = 1;          
    public Integer enteringWithGeneralVitality;   
    public Integer leavingWithGeneralVitality;    
}
   //---------- end add 26 feb
