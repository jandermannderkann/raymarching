ArrayList<Obstacle> obst = new ArrayList<Obstacle>();
PVector centerP;
PVector mouse;
int noRays = 100;
Castable cast;
boolean animated = false;
boolean colored = false;

color bgcol = color(20);

color c1;
color c2;

void setup(){
	size(1900,1080);
	frameRate(10);
	background(bgcol);
	centerP = new PVector(width/2, height/2);
	spawnRandomObstacles(20);

	if (animated) {
		cast = new AnimatedRayCast(noRays, centerP);
	} else {
		cast = new RayCast(noRays, centerP);
	}
	

}

void spawnRandomObstacles(int n) {
	for(int i = 0; i < n; i++) {
		float x = random(width);
		float y = random(height);
		PVector cp = new PVector(x,y);

		float size = random(50)+10;
		PVector p2 = new PVector(size,size);
		p2.add(cp);

		CircObstacle newObst = new CircObstacle(cp, p2);
		if (newObst.intersects(this.centerP)){
			continue;
		}
		obst.add(newObst);
	}
}

void draw(){
	background(bgcol);
	act();

	c1 = color(random(205)+25,random(205)+25,random(205)+25,100);
	c2 = color(random(205)+25,random(205)+25,random(205)+25,100);
	cast.render();
	for (Obstacle obstacle: obst) {
		obstacle.render();
	}


}

boolean update = false;
public void act(){
	PVector newMouse = new PVector(mouseX, mouseY);

	if (newMouse.equals(this.mouse)) {
		return;
	}
	this.mouse = newMouse;

	if (animated) {
		println("ilive");
		if(cast.dead()) {
			println("imdead");

			cast = new AnimatedRayCast(noRays, centerP);
		}
		cast.act();
	}else {

		cast = new RayCast(noRays, this.mouse);
	}
}


public void mouseClicked() {
	create_obst();
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


public boolean offScreen(PVector p) {
	if (p.x< 0 || p.y<0) {
		return true;
	}
	if (p.x>width || p.y > height) {
		return true;
	}
	return false;
}


