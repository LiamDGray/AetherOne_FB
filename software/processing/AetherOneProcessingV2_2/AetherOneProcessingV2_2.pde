/**    //----------<>   //----------    //----------<>   //----------    //----------<>   //----------  //<>//
 * TAB AETHERONEPROCESSING 3 aug.2019
 * AETHERONE PROCESSING
 *
 * Each line is a file pattern followed by one or more contributers:
 * 
 * One of them is an EX-girhub-users: Radionics a.k.a Ken. 
 * This code is not committed to the original repository because the original deleted from Github bij the first owner.
 * 
 * The second contributer is Stella Estel. 
 * For more information visit the facebook-group: https://www.facebook.com/groups/174120139896076
 *
 * The changes of Stella Estel are related to the:
 * - redesign of the functions/aperances of the processing screen like place and the name of the buttons.
 * - additional buttons and functions
 * - numbers of the dials, from 12 to 16.
 * - generate rates function
 * - broadcast rates function
 * - resizablefunction of the screen
 * - autobroadcastfunctions for all the buttons
 * - data with rates
 *   
 * The rates-database is a convertion from several PDF sources converted in excel and then in TXT-files. 
 * Feel free to change the database.
 * 
 * This program is licensed by MIT License, which permits you to copy, edit and redistribute,
 * but you need to distribute this license too, letting people know that this project is
 * open source.
 *
 * 
 */
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.image.BufferedImage;
import java.awt.Graphics2D;
import processing.net.*;
import processing.serial.*;
import java.util.*;
import java.lang.reflect.*;
import java.security.*;
    //----------============================== Add Stella 
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;    
import java.awt.event.ActionListener;   
import java.util.ArrayList;   
import java.util.List;
import java.util.Random;
   //----------========================
import java.io.Serializable;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Collections;
import java.util.Comparator;
import java.util.Calendar;
   //----------ADD DD 19 mei 2019  line 62 to 105

import cc.arduino.*;
Arduino arduino;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;
   //---------- Visualizer efaults 
float valScale = 1.0;
float maxVisible = 10.0;
float beatThreshold = 0.25;
float colorOffset = 30;
float autoColorOffset = 0.01;

   //---------- Show text if recently adjusted

boolean showscale = false;
boolean showBeatThreshold = false;
boolean showHelp = false;
float beatH = 0;
float beatS = 0;
float beatB = 0;
float arduinoBeatB = 0;

float[] lastY;
float[] lastVal;

int buffer_size = 1024;     //---------- also sets FFT size (frequency resolution)
float sample_rate = 44100;

int redPin = 4;    //----------int redPin = 5;
int greenPin = 3;   //----------int greenPin = 6;
int bluePin = 2;    //----------int bluePin = 3;
boolean fullscreen = false;
int lastWidth = 0;
int lastHeight = 0;
boolean arduinoConnected = false;
//----------int arduinoIndex = 0;    //---------- dubbel 
//----------String arduinoMessage = "";    //---------- dubbel
//----------END ADD DD 19 mei 2019

RadionicsElements radionicsElements;
ArduinoSerialConnection arduinoConnection;
AetherOneCore core;
Tile tile;
   
String statusText; //----------=============== END ADD 2 juli Stella

boolean initFinished = false;
int maxEntries = 19;    //----------17; add Stella
List<PImage> photos = new ArrayList<PImage>();
JSONObject configuration;
PImage backgroundImage;
int arduinoConnectionMillis;
   //----------===========Add Stella
int  getDecimalPrecision;
   
   //----------=========== End Add Stella
File selectedDatabase;
String monitorText = "";
long timeNow;
Integer generalVitality = null;
Integer progress = 0;
boolean connectMode = false;
boolean disconnectMode = false;
boolean trngMode = true;
List<RateObject> rateList = new ArrayList<RateObject>();
List<ImagePixel> imagePixels = new ArrayList<ImagePixel>();
List<ImagePixel> broadcastedImagePixels = new ArrayList<ImagePixel>();
Map<String, File> selectableFiles = new HashMap<String, File>();
Map<String, Integer> ratesDoubles = new HashMap<String, Integer>();
int gvCounter = 0;
boolean stopBroadcasting = false;

                                                  //----------PWindow win;
int arduinoIndex = 0;                            //---------- ADD DD 19 mei 2019 
String arduinoMessage = "";                      //----------ADD DD 19 mei 2019 
/**
 * Get current time in milliseconds
 */
long getTimeMillis() {
  Calendar cal = Calendar.getInstance();
  timeNow = cal.getTimeInMillis();
  return timeNow;
}

/**
 * SETUP the processing environment
 */
void setup() {
     //----------fullScreen();
  size(1285, 760);           //----------old size(1298, 721);
  
//----------  ==== RESIZE FRAME === Add Stella
  surface.setResizable(true);     //---------- it was>>   frame.setResizable(true); and it was wrong//---------- ADD DD 19 mei 2019 and it works perfect!  Use surface.setResizable() instead of frame.setResizable in Processing 3
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
  
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(16, 2);
  fft.window(FFT.HAMMING);
  
  lastY = new float[fft.avgSize()];
  lastVal = new float[fft.avgSize()];
 //----------initLasts(); deze geeft problemen als die actief is.. heeft te maken met de resize code. dan moet ik de background elimineren
 //----------initArduino();  deze geeft problemen als die actief is.. dan moet ik de background elimineren
  frame.setAlwaysOnTop(true);

  
  backgroundImage = loadImage ("AetherOneFB.jpg");   //---------- =================here you can change the imagename
  
  surface.setTitle("AetherOneV2.2_resize");        //---------- =================here you can change the frame name
  noStroke();              //----------noSmooth(); do not use <noSmooth>, you will like get a strange fonds
  core = new AetherOneCore();
  arduinoConnection = new ArduinoSerialConnection(this, 9600, core);
  arduinoConnectionMillis = millis();
  arduinoConnection.getPort();
  initConfiguration();


   //---------- V2_1 RADIONICSELEMENTS             //---------- =========== place of the buttons, here you change the position of the buttons
  radionicsElements = new RadionicsElements(this);
  radionicsElements.startAtX = 941;               //----------308;
  radionicsElements.startAtY = 7;                 //----------10;   //----------62;
  radionicsElements.usualWidth = 113;             //----------122;
  radionicsElements.usualHeight = 13;             //----------15;   //----------18;
  radionicsElements    //---------- =========== place of the buttons, here you change the names 
    
    .addButton("general vitality")
    .addButton("select data")
    .addButton("analyze")    
    .addButton("broadcast")
    .addButton("stop broadcast")
    .addButton("ommanipadmehum")
    .addButton("univercalsource")
    .addButton("anahata")
    .addButton("homeopathy")
    .addButton("acupuncture")
    .addButton("biological")
    .addButton("symbolism")
    .addButton("divine")
    .addButton("essences")  
    .addButton("chemical") 
    .addButton("energy")
    .addButton("grounding")
    
    .addTextField("Input", 71, 6, 509, 20, true)   
    .addTextField("Output", 71, 29, 509, 20, false); 

     //----------2th buttons row 
  radionicsElements.startAtX = 1057;
  radionicsElements.startAtY = 7;   //----------10;
  radionicsElements
    .addButton("all")
    .addButton("hair")
    .addButton("busby")
    .addButton("korbler")
    .addButton("grabovoi")
    .addButton("rife")
    //.addButton("aaaaaaaaaaaaaaaaa")
    .addButton("agriculture")
    .addButton("check items")
     //.addButton("check file") function was never active 
    .addButton("copy")
    .addButton("clear screen")
    .addButton("clear")
    .addButton("connect")
    .addButton("disconnect");
     //.addButton("potency");
     //----------3th buttons row 
  radionicsElements.startAtX = 1173;
  radionicsElements.startAtY = 7;   //---------- was 10;
  radionicsElements
      .addButton("TRNG/PRNG")
      .addButton("Peggotty rate")    //---------- generate a peggotty rate and enbed it in the peggotty You can also just put a rate in the peggotty squairs 
      .addButton("clear peggotty")
      .addButton("photography")
      .addButton("select image")
      .addButton("paste image")
      .addButton("clear image")
      .addButton("broadcast image")
      .addButton("generate md5")
      .addButton("target") 
      .addButton("broadcast rate")
      .addButton("generate rate")
      .addButton("clear dials")
      .addButton("potency");

  radionicsElements.addSlider("progress", 10, 273, 530, 10, 100);   
  radionicsElements.addSlider("hotbits", 10, 288, 530, 10, 100);  

  radionicsElements.startAtX = 330; 
  radionicsElements.startAtY = 107; 
  radionicsElements
    .initPeggotty (330, 73);    
radionicsElements
   .addKnob("Max Hits", 216, 66, 35, 1, 100, 10, null)   
    .addKnob("Broadcast Repeats", 216, 166, 35, 1, 99999, 72, null)   
    .addKnob("Delay", 145, 183, 25, 1, 250, 25, null);
    

     //----------16 DIALS  add Stella
  int xx = 963;     
  int yy = 321;     
  int rCounter = 1;

  for (int y=0; y<4; y++) {
    for (int x=0; x<4; x++) {    // add Stella ----------for (int x=0; x<3; x++) {
      radionicsElements
        .addKnob("R" + rCounter, xx, yy, 27, 0, 100, 0, null);    //---------- .addKnob("R" + rCounter, xx, yy, 50, 0, 100, 0, null);
      xx += 77;                  //----------xx += 130;
      rCounter += 1;
    }

    xx = 963;  //---------- hier zijn de rest van de 16 dials.. de overige 4 zitten in de regels hiervoor op positie 963..
    yy += 78;

    Colors color_gold = new Colors();  //----------goudkleur dial
    color_gold.bRed = 250;
    color_gold.bGreen = 200;
    color_gold.bBlue = 0;
    color_gold.fRed = 0;
    color_gold.fGreen = 0;
    color_gold.fBlue = 0;

    radionicsElements.startAtX = 1073; 
    radionicsElements.startAtY = 630; 
    radionicsElements
      .addKnob("amplifier", 1073, 630, 35, 0, 360, 0, color_gold);    //----------.addKnob("amplifier", 1088, 635, 35, 0, 360, 0, color_gold);
  }

  prepareExitHandler ();
  initFinished = true;
  core.updateCp5ProgressBar();
}

/**
 * Before leaving the program save hotbits and other stuff
 */
private void prepareExitHandler () {

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {

    public void run () {

      saveJSONObject(configuration, "configuration.json");
      core.persistHotBits();
    }
  }
  ));
}

int leftBorder()   { return int(.05 * width); }
int rightBorder()  { return int(.05 * width); }
int bottomBorder() { return int(.05 * width); }
int topBorder()    { return int(.05 * width); }

void initLasts()
{
  
  for(int i = 0; i < fft.avgSize(); i++) {
    lastY[i] = height - bottomBorder();
    lastVal[i] = 0;
  }
  
}


/**
 * Initialize a JSON configuration
 */
void initConfiguration() {
  try {
    configuration = loadJSONObject("configuration.json");
  } 
  catch(Exception e) {
       //----------do nothing
  }

  if (configuration == null) {
    configuration = new JSONObject();
  }
}

/**
 * Listen to serialEvents and transmit them to the ArduinoConnection class
 */
void serialEvent(Serial p) {                             //---------- add Stella 9 frb maar geeft problemen 
  arduinoConnection.serialEvent(p);                      //---------- add Stella 9 frb maar geeft problemen
}

/**
 * Subroutine checking if at least one rate was choosen by TRNG max times
 */
public boolean reachedSpecifiedHits(Map<String, Integer> ratesDoubles, int max) {

  for (String rateKey : ratesDoubles.keySet()) {
    if (ratesDoubles.get(rateKey) >= max) {
      return true;
    }
  }

  return false;
}

/**
 * BROADCAST a signature
 */
void broadcast(String broadcastSignature) {
  Float fBroadcastRepeats = cp5.get(Knob.class, "Broadcast Repeats").getValue();
  int broadcastRepeats = fBroadcastRepeats.intValue();
  Float fDelay = cp5.get(Knob.class, "Delay").getValue();
  println(fDelay);
  arduinoConnection.iDelay = fDelay.intValue();
  println(arduinoConnection.iDelay);

  println("broadcastSignature = " + broadcastSignature);
  byte[] data = broadcastSignature.getBytes();
  String b64 = Base64.getEncoder().encodeToString(data);
  println("broadcastSignature encoded = " + b64);
  arduinoConnection.broadCast(b64, broadcastRepeats);
}

/**
 * A rate object for analysis
 */
public class RateObject {
  String rate;
  Integer level = 0;
  Integer gv = 0;
}
