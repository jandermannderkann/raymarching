ArrayList<Obstacle> obst = new ArrayList<Obstacle>();
PVector centerP;
PVector mouse;
int noRays = 64;
float diagonal;
Castable cast;
HelpMenu helpDialog;
boolean help_visible = false;
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
	spawnRandomObstacles(50);
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


class HelpMenu {
	ArrayList<String> commands = new ArrayList<String>();
	ArrayList<String> stats = new ArrayList<String>();
	PVector anchor;
	float line_height;

	public void setCommands(String[] cmds) {
		for (int i =0; i< cmds.length; i++) {
			commands.add(cmds[i]); //TODO commands.fromArray or something similar
		}
	}

	public HelpMenu () {

		this.anchor = new PVector(width/3, height/10);
		this.line_height = height/30; //TODO 30 = max(comands, 30)
	}

	void render() {
		PVector p1 = new PVector(width/3, height/10);
		stroke(150);
		fill(50);
		rect(p1.x, p1.y, p1.x+max(commands.size(),4)*line_height, p1.y+height/3);
		int c = 1;
		for (String cmd: this.commands) {
			println(cmd);
			fill(200);
			text(cmd,p1.x + 10, p1.y+c*line_height);
			c++;
		}
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
		if(cast.dead()) {
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
		renderCircle = !renderCircle;
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

void initHelp() {
	this.helpDialog = new HelpMenu();
	String[] cmd_info = {
		"a: toggle animation",
		"t: toggle trajectory",
		"f: toggle fast calculation",
		"+/-: inc/deacrease amount of rays",
		"r: toggle rendering of rays",
		"c: toggle circles",
		"h: toggle help"
		};
	this.helpDialog.setCommands(cmd_info);
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