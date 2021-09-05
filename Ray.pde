class AnimatedRay extends Ray {
public AnimatedRay(float angle, PVector origin) {
	super(angle, origin);
	}
	public void act() {
		if (dead) {
			return;
		}
		//println(origin.dist(this.crawl));
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
class FastRay extends Ray{
	Obstacle lastNearestNeighbor = null;
	float lastMinDist = max(width, height);

	Obstacle furthestNeighbor = null;
	float maxDist = 0;
	ArrayList<Obstacle> obstacles;

	public FastRay(float angle, PVector origin) {
		super(angle, origin);
		this.obstacles = (ArrayList)obst.clone();
	}

	public Obstacle getNearestObstacle() {
		Obstacle closest = this.lastNearestNeighbor;
		float minDist = this.lastMinDist;
		Obstacle furthest = null;
		float maxDist = 0;
		//int furthest_index = 0 ;
		int counter = 0;
		//println(this.obstacles.size());
		for (Obstacle needle: this.obstacles) { 
			float dist = needle.dist(this.crawl);
			minDist = min(minDist,dist);
			maxDist = max(maxDist,dist);
			if (minDist == dist) {
				closest = needle; //TODO improve?
			}
			if (maxDist == dist) {
				furthest = needle;	
				//furthest_index = counter;
			}
			counter++;
		}

		if (furthest == this.furthestNeighbor) {
			//println(furthestNeighbor +"="+ furthest);
			//println(maxDist + ">?" + this.maxDist);
			if (maxDist > this.maxDist) {
				this.obstacles.remove(furthest);
				//furthest.mark();
				//println("removing"+ furthest);
				//println("from "+this.obstacles.size());
				//println("main has" + obst.size());
			}
		}
		this.furthestNeighbor = furthest;
		this.maxDist = maxDist;
		return closest;
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


	public Ray(float angle, PVector origin) {
		this.origin = origin;
		this.crawl = origin;
		this.angle = angle;
	}

	public Obstacle getNearestObstacle() {
		Obstacle closest = null;
		float minDist = max(width, height);
		for (Obstacle needle: obst) { 
			float dist = needle.dist(this.crawl);
			minDist = min(minDist,dist);
			if (minDist == dist) {
				closest = needle;
			}
		}
		return closest;
	}

	public void die () {
		this.dead = true;
		//println("dead");
	}

	public void step() {
		Obstacle nearestObst = getNearestObstacle();
		if (nearestObst == null) {
			die();
			return;
		}

		//TODO what if no obstacle
		RayCastSearchArea currentSearch = new RayCastSearchArea(crawl, nearestObst);
		searches.add(currentSearch);

		PVector towards = PVector.fromAngle(radians(angle+45)); //TODO why 45
				  towards.setMag(nearestObst.dist(crawl));
		PVector between = towards.add(crawl);
		this.crawl = between;

		if (offScreen(this.crawl)) {
			die();
			return;
		}

		if (currentSearch.diam < 10) {
			die();
			return;
		}
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

	boolean bridgeRays = false;
	boolean trajectory = true;
	boolean searchCircles = true;
	public void render() {
		if (searchCircles) {
			for (RayCastSearchArea rcs : searches) {
				if (rcs == searches.get(0)){continue;} //all circles are the same here, so we dont want to render
				rcs.render();
			}
		}
		renderCrawler();
		if (trajectory){renderTrajectory();}

		if (bridgeRays){renderBridges();}
	}
}