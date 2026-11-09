
class AnimatedRayCast implements Castable{ //TODO favor over inheritance
	ArrayList<Ray> rays = new ArrayList<Ray>();
	boolean dead = false;
	public AnimatedRayCast(int noRays, PVector origin){
		for(int i = noRays; i > 0; i--) {
			Ray ray = new AnimatedRay(map(i, 0, noRays, 0, 360-1), origin);
			rays.add(ray);
		}
		println("dead?");
		println(this.dead);
	}

	public void act() {
		boolean possiblyAlive = false;
		println("dead?"+this.dead);
		
		for (Ray ray:rays) {
			if (!ray.dead) {
				println("someones alive");
				possiblyAlive = true;
			}
			ray.act();
		}
		if (!possiblyAlive) {
			this.dead = true;
		}
		println("dead?"+this.dead);
		/*
		for (int i = 0; i< rays.size(); i++) {
			Ray ray = rays.get(i);
			ray.act();
			if (ray.dead) {
				rays.remove(i);
				if (rays.size() == 0) {
					this.finishedCast = true;
				}
			 }else{
				 println("notdead");
			 }
		}*/
	}

	public boolean dead() {
		return this.dead;
	}

	public void render() {
		for (Ray ray:rays) {
			ray.render();
		}
	}

}

interface Castable {
	public void act();
	public void render();
	public boolean dead();
}

class RayCast implements Castable{
	ArrayList<Ray> rays = new ArrayList<Ray>();
	boolean dead = false;

	public RayCast(int noRays, PVector origin) {
		for(int i = noRays; i > 0; i--) {
			Ray ray = new FastRay(map(i, 0, noRays, 0, 360-1), origin);
			rays.add(ray);
		}
		
		for (Ray ray:rays) {
			ray.act();
		}
		boolean dead = true;
	}

/*
	public void renderBridges() {
		float dist = this.crawl.dist(this.origin);
		float grain = 5;

		boolean bridgeRays = true;
		float raySize = 10;

		for (int i = 0; i < max(width,height); i+= grain) {
		//for (int i = 0; i < dist; i+= grain) {
			for (Ray ray : rays)){
				ray.renderBrige();
			}
			float stepx = map(i, 0, max(width,heigh), origin.x, crawl.x);
			float stepy = map(i, 0, max(width,heigh), origin.y, crawl.y);
			stroke(100); //TODO why does this kill all cpu power?
			//line(origin.x, origin.y, stepx, stepy);
			noStroke();
			if (bridgeRays){

				fill(200,20);
				point(stepx, stepy);
				noStroke();
				//circle(stepx, stepy, lerp(0,dist,i));
				circle(stepx, stepy, 5);
			}
		}
	}
*/
	public void act() {

	}
	public void render() {
		for (Ray ray:rays) {
			ray.render();
		}
	}

	public boolean dead() {
		return this.dead;
	}
	/*public void act(){
		for (Ray ray:rays) {
			ray.act();
		}
	}*/
}

