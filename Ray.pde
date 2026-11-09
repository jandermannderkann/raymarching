boolean bridgeRays = false;
boolean renderTrajectory = false;
boolean searchCircles = true;
boolean renderRay = true;

float grainSize = 5;

class AnimatedRay extends Ray {
public AnimatedRay(float angle, PVector origin) {
	super(angle, origin);
	}
	public void act() {
		if (dead) {
			return;
		}
		step();
	}
}


/*
class RayGroup extends Ray{
	ArrayList<FastRay> rays;
	public RayGroup (ArrayList<FastRay> rays) {
		this.rays = rays;
	}
	
	public Obstacle getNearestObstacle() {
		Obstacle closest = this.lastNearestNeighbor;
		float minDist = this.lastMinDist;
		for (Obstacle needle: obst) { 
			float dist = needle.dist(this.crawl);
			minDist = min(minDist,dist);
			if (minDist == dist) {
				closest = needle;
			}
		}
		return closest;
	}
}
*/

class NearestObstacleGuess{
	Obstacle obstacle;
	float dist;

	public NearestObstacleGuess(Obstacle obstacle, float dist) {
		this.obstacle = obstacle;
		this.dist = dist;
	}
}


class FastRay extends Ray{

	NearestObstacleFinder finder;

	public FastRay(float angle, PVector origin) {
		super(angle, origin);
		this.finder = new FastNearestObstacleFinder(obst);
	}

}

class TracedRay extends Ray{
	public TracedRay(float angle, PVector origin) {
		super(angle, origin);
	}
	public void step() {
		PVector towards = PVector.fromAngle(radians(angle+45)); //TODO why 45
				  towards.setMag(grainSize);
		PVector between = towards.add(crawl);
		for (Obstacle obstacle: obst) {
			if (obstacle.intersects(this.crawl)) {
				die();
				return;
			}
		}
		if (offScreen(this.crawl)) {
			die();
			return;
		}
		this.crawl = between;
	}

	public void act() {
		if (dead) {
			return;
		}
		while (!dead) {
			step();
		}
		this.dist = origin.dist(this.crawl);
	}
}

class Ray {
	PVector crawl;
	PVector origin;
	float dist;
	float angle; //Deg
	ArrayList<RayCastSearchArea> searches= new ArrayList<RayCastSearchArea>();
	float maxDist = max(width,height)/2;
	boolean dead = false;
	
	NearestObstacleFinder finder;


	public Ray(float angle, PVector origin) {
		this.origin = origin;
		this.crawl = origin;
		this.angle = angle;
		this.finder = new NearestObstacleFinder(obst);
	}

	public void die () {
		this.dead = true;
		//println("dead");
	}

	public void step() {
		Obstacle nearestObst = finder.getNearestObstacle(this.crawl);
		if (nearestObst == null) {
			die();
			return;
		}

		if (offScreen(this.crawl)) {
			die();
			return;
		}

		RayCastSearchArea currentSearch = new RayCastSearchArea(crawl, nearestObst);
		searches.add(currentSearch);

		if (currentSearch.diam < grainSize) {
			die();
			return;
		}

		PVector towards = PVector.fromAngle(radians(angle+45)); //TODO why 45
				  towards.setMag(nearestObst.dist(crawl));
		PVector between = towards.add(crawl);
		this.crawl = between;
	}

	public void act() {
		if (dead) {
			return;
		}
		while (!dead) {
			step();
		}
		this.dist = origin.dist(this.crawl);
	}

	public void renderCrawler(){
		fill(color(100,0,0));
		if(!dead) {
			fill(color(0,100,0));
			circle(crawl.x, crawl.y, 10);
		} else {
			stroke(255);
			point(crawl.x, crawl.y);
		}
	}

	public void renderTrajectory() {
		pushMatrix();
		stroke(55,100);
		translate(origin.x, origin.y);
		rotate(radians(angle));

		int maxSize = max(width,height);
		line(0,0,maxSize,maxSize);

		popMatrix();
	}

	public void renderBrige() {

	}

	float grain = 10;
	float raySize = 15;
	public void renderBridges() {
		float ox = origin.x;
		float oy = origin.y;

		fill(200,20);
		noStroke();
		stroke(200,20);
		//line(this.crawl.x, this.crawl.y, ox, oy);
		for (int i = 0; i < dist; i+= grain) {
			float stepx = map(i, 0, dist, origin.x, crawl.x);
			float stepy = map(i, 0, dist, origin.y, crawl.y);
			//TODO why does this line() kill all cpu power?

			//line(this.crawl.x, this.crawl.y, ox, oy);


			//circle(stepx, stepy, lerp(0,dist,i));
			circle(stepx, stepy, raySize);
		}
	}

	public void render() {
		if (searchCircles) {
			for (RayCastSearchArea rcs : searches) {
				if (rcs == searches.get(0)){continue;} //all circles are the same here, so we dont want to render
				rcs.render();
			}
		}
		if (renderRay) {
			stroke(150);
			line(this.origin.x, this.origin.y, this.crawl.x, this.crawl.y);
		}

		renderCrawler();
		if (renderTrajectory){renderTrajectory();}

		if (bridgeRays){renderBridges();}
	}
}