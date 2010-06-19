size(1800,500,P2D);noStroke();
fill(30);      background(51);
float w = 3,h = 0, a = height;
for (int n=0; n<1800/3; n++) {
h=random(a/2);rect(n*w,0,w,h);
  rect(n*w,h+w,w,random(a/4));
} saveFrame("bg.png"); exit();
