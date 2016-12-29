/* represetation of data in terms of a bargraph 
comparing gestures expressed and gestures recieved on the way.
*/

int plotx1=140,ploty1=100,plotx2=740,ploty2=500;
String lines[];
String gest[][];
int plotTable[][];
float plotPoints1[][];
float plotPoints2[][];

// plot x1 and y1 for top left and x2 and y2 for bottom right

void preprocess()
{
  lines = loadStrings("vals.tsv");// converts vals.tsv 
  plotTable = new int[lines.length-1][3];
  
  for(int i=1;i<lines.length;i++)
  {
    String temp[] = split(lines[i],TAB);
    
    //convert col 1 to mins
    String t[] = split(temp[0]," ");
    int fac;
    if(t[1].equals("AM") == true)
      fac = 0;
    else
      fac = 12;
    String time[] = split(t[0],":");
    plotTable[i-1][0] = ((fac+(int(time[0])%12))*60) + int(time[1]);
    
    //convert col 2 gesture to its value
    for(int j=0;j<gest.length;j++)
    {
      if(temp[1].equals(gest[j][0]) == true)
        plotTable[i-1][1] = int(gest[j][1]);
    }
    
    //convert col 3 gesture to its value
    for(int j=0;j<gest.length;j++)
    {
      if(temp[2].equals(gest[j][0]) == true)
        plotTable[i-1][2] = int(gest[j][1]);
    } 
  }
}

void makeGraphLabels()        //TODO:set parameters for text font, size color
{
  //Make axes
  stroke(145,145,145);
  strokeWeight(5);
  line(plotx1,ploty2,plotx2,ploty2);
  line(plotx1,ploty1,plotx1,ploty2);
  
  fill(255,215,0);
  //Label 0
  text("0",plotx1-10,ploty2+10);
  
  //Label y axis
  int h = ploty2-ploty1;
  int yMinVal = 0;
  int yMaxVal = int(gest[gest.length-1][1]);
  
  strokeWeight(2);
  textAlign(RIGHT,CENTER);
  for(int i=1;i<=yMaxVal;i++)
  {
    float res = map(i,yMinVal,yMaxVal,ploty2,ploty1);
    line(plotx1-10,res,plotx1+10,res);
    text(gest[i-1][0],plotx1-12,res-2);
  }
  
  fill(255,69,0);
  text("GESTURES",plotx1-20,ploty1-25);
  
  //Label x axis
  fill(255,215,0);
  textAlign(CENTER,CENTER);
  for(int i=60;i<=60*24;i=i+60)
  {
    float res = map(i,0,60*24,plotx1,plotx2);
    line(res,ploty2-10,res,ploty2+10);
    text(i/60,res,ploty2+17);
  }
  
  fill(255,69,0);
  text("HOURS",plotx2-18,ploty2+35);
  
  //Line Labels
  noStroke();
  textAlign(LEFT,CENTER);
  fill(255,62,150);
  ellipse(380,35,4,4);
  text("Gestures EXPRESSED",385,32);
  
  fill(127,255,0);
  ellipse(380,65,4,4);
  text("Gestures RECEIVED",385,62);
}
 
  
void genPlotPoints()
{
  plotPoints1 = new float[plotTable.length][2];
  plotPoints2 = new float[plotTable.length][2];
  
  for(int i=0;i<plotTable.length;i++)
  {
    //series 1, col = 0,1
    float resx = map(plotTable[i][0],0,60*24,plotx1,plotx2);
    float resy = map(plotTable[i][1],0,6,ploty2,ploty1);                    //number of feelings is hardcoded
    plotPoints1[i][0] = resx;
    plotPoints1[i][1] = resy;
    
    //series 2, col = 0,2
    resx = map(plotTable[i][0],0,60*24,plotx1,plotx2);
    resy = map(plotTable[i][2],0,6,ploty2,ploty1);                    //number of feelings is hardcoded
    plotPoints2[i][0] = resx;
    plotPoints2[i][1] = resy;
  }
}

void plotGraph()
{
  fill(255,62,150);
  stroke(255,62,150);
  //plot series 1
  int i;
  for(i=0;i<plotPoints1.length-1;i++)
  {
    ellipse(plotPoints1[i][0],plotPoints1[i][1],4,4);
    line(plotPoints1[i][0],plotPoints1[i][1],plotPoints1[i+1][0],plotPoints1[i+1][1]);
  }
  ellipse(plotPoints1[i][0],plotPoints1[i][1],4,4);
  
  
  fill(127,255,0);
  stroke(127,255,0);
  //plot series 2
  for(i=0;i<plotPoints2.length-1;i++)
  {
    ellipse(plotPoints2[i][0],plotPoints2[i][1],4,4);
    line(plotPoints2[i][0],plotPoints2[i][1],plotPoints2[i+1][0],plotPoints2[i+1][1]);
  }
  ellipse(plotPoints2[i][0],plotPoints2[i][1],4,4);
  
}

void setup()
{
  size(800,600);
  smooth(2);
  background(54,54,54);        //Background colour
  fill(54,54,54);              //Graph background colour
  rectMode(CORNERS);
  noStroke();
  rect(plotx1,ploty1,plotx2,ploty2);//defined in first line
  
  //load gestures
  String lns[] = loadStrings("Gestures.tsv");
  gest = new String[lns.length-1][2];
  for(int i=1;i<lns.length;i++)
  {
    gest[i-1][1] = split(lns[i],TAB)[0];
    gest[i-1][0] = split(lns[i],TAB)[1];
  }
  
  preprocess();
  
  /*for(int i=0;i<plotTable.length;i++)
  {
    println(plotTable[i][0] + "\t" + plotTable[i][1] + "\t" + plotTable[i][2]);
  }
  */
  
  makeGraphLabels();
  
  genPlotPoints();
  
  strokeWeight(1);
  plotGraph();
}
