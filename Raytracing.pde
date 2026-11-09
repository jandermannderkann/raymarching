ArrayList<Obstacle> obst = new ArrayList<Obstacle>();
PVector centerP;
PVector mouse;
int noRays = 64;
int noObstacles = 100;
float diagonal;
Castable cast;
HelpMenu helpDialog;

boolean animated = false;
boolean colored = false;
boolean animateOnMouseMove = false;
color bgcol = color(20);

color c1;
color c2;


void setup(){
	size(1900,1080);
	frameRate(10);
	background(bgcol);

	centerP = new PVector(width/2, height/2);
	spawnRandomObstacles(noObstacles);
	this.diagonal = sqrt(width*width + height*height);
	initHelp();

	if (animated) {
		cast = new AnimatedRayCast(noRays, centerP);
	} else {
		cast = new RayCast(noRays, centerP);
	}
}


void draw(){
	background(bgcol);
	act();

	c1 = color(random(205)+25,random(205)+25,random(205)+25,100);
	c2 = color(random(205)+25,random(205)+25,random(205)+25,100);
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



public void act(){
	PVector newMouse = new PVector(mouseX, mouseY);
	boolean mouseUpdate = false;

	if (!newMouse.equals(this.mouse)) {
		mouseUpdate = true;
		this.mouse = newMouse;
	}
	if (animateOnMouseMove && !mouseUpdate) {
		return;
	}

	if (animated) {
		if(cast.dead()) {
			cast = new AnimatedRayCast(noRays, this.mouse);
		}
	}else {
		if (mouseUpdate) {
			cast = new RayCast(noRays, this.mouse);
		}
	}
	cast.act();
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
		renderRay= !renderRay;
	}
	if (key == 'h') {
		help_visible= !help_visible;
	}
	if (key == 'm') {
		animateOnMouseMove= !animateOnMouseMove;
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