ArrayList<Obstacle> obst = new ArrayList<Obstacle>();
PVector centerP;
PVector mouse;
int noRays = 64;
int noObstacles = 20;
float diagonal;
RayCast cast;
HelpMenu helpDialog;

boolean traceMode = false;
boolean animated = false;
boolean colored = false;
boolean animateOnMouseMove = false;
boolean doUpdate = false;

int bgcol_val = 20;
color bgcol = color(bgcol_val);

color c1 = color(random(205)+25,random(205)+25,random(205)+25,100);
color c2 = color(random(205)+25,random(205)+25,random(205)+25,100);
color c3 = color(random(205)+25,random(205)+25,random(205)+25,100);

void setup(){
	size(1920,1080);
	frameRate(60);
	background(bgcol);
	textSize(20); 
	colorMode(HSB);
	centerP = new PVector(width/2, height/2);
	spawnRandomObstacles(noObstacles);
	this.diagonal = sqrt(width*width + height*height);
	this.helpDialog = new HelpMenu();

	cast = new RayCast(noRays, centerP);
}

void draw(){
	background(bgcol);
	act();

	render();
}

void render() {
	cast.render();
	for (Obstacle obstacle: obst) {
		obstacle.render();
	}
	if (help_visible) {
		this.helpDialog.render();
	}
}

class RenderListener {
	boolean redraw = false;
}

int colorShift=0;
public void act(){
	PVector newMouse = new PVector(mouseX, mouseY);
	boolean mouseUpdate = false;
	if (!newMouse.equals(this.mouse)) {
		this.mouse = newMouse;
		mouseUpdate = true;
	}

	if (cast.dead()) {
		doUpdate = true;
	}
	if (doUpdate) {
		if (animated) {
			cast = new RayCast(noRays, this.mouse);
		}else {
			cast = new RayCast(noRays, this.mouse);
		}
		doUpdate = false;
	}
	if (animated && animateOnMouseMove && !mouseUpdate) {
		return;
	}

	colorUpdate();
	cast.act();
}


float colorShiftTime = 50;
boolean shift_first= false;

public void bicolorUpdate() {
		colorShift++;
		if (colorShift > colorShiftTime) {
			colorShift=0;
			c3 = color(random(255),255,255);
			println("reset");
		}
		if (colorShift == colorShiftTime/2) {
			c3 = color(random(255),255,255);
		}
		if (colorShift < colorShiftTime/2) {
			float val = (float)((colorShift)/(colorShiftTime/2.0));
			println("v"+val);
			c1 = lerpColor(c1, c3, val);
		} else {
			float val = (float)((colorShift/2.0)/(colorShiftTime/2.0));
			println("v"+val);
			c2 = lerpColor(c2, c3, val);
		}
}

public void colorUpdate() {
		colorShift++;
		if (colorShift > colorShiftTime) {
			colorShift=0;
			c2 = c3;
			c3 = color(random(255),155,155);

		}
		float val = (float)((colorShift)/(colorShiftTime));
		this.c1 = lerpColor(c2, c3, val);
}

public void mouseClicked() {
	create_obst();
}


void keyTyped() {
	if (key == 43) {
		this.noRays*=2;
	}
	if (key == 45) {
		if (this.noRays>1){
			this.noRays/=2;
		}
	}
	if (key == 'c') {
		if (colored) {
			colored = false;
			renderCircle = 2;
			return;
		}
		renderCircle ++;
		renderCircle = renderCircle%3;
	}
	if (key == 't') {
		renderTrajectory = !renderTrajectory;
	}
	if (key == 'a') {
		animated = !animated;
	}
	if (key == 'f') {
		fast= !fast;
	}
	if (key == 'r') {
		renderRay++;
		renderRay = renderRay %3;
	}
	if (key == 'h') {
		help_visible= !help_visible;
	}
	if (key == 'm') {
		animateOnMouseMove= !animateOnMouseMove;
	}
	if (key == 'e') {
		traceMode= !traceMode;
	}
	if (key == 'o') {
		colored = !colored;
		if (colored) {
			renderCircle = 2;	
		}else {
			renderCircle = 0;
		}
		
	}
}


PVector firstClick = null;
public void create_obst() {
  if (firstClick != null) {
    PVector secondClick = new PVector(mouseX, mouseY);
    obst.add(new CircObstacle(firstClick, secondClick));

    firstClick = null;
    return;
  }
  firstClick = new PVector(mouseX, mouseY);
}


void spawnRandomObstacles(int n) {
	for(int i = 0; i < n; i++) {
		Obstacle newObst = getRandomObstacle();
		if (newObst.intersects(this.centerP)){
			continue;
		}
		obst.add(newObst);
	}
}


public boolean offScreen(PVector p) {
	if (p.x< 0 || p.y<0) {
		return true;
	}
	if (p.x>width || p.y > height) {
		return true;
	}
	return false;
}
