boolean fast = true;
interface Castable {
	public void act();
	public void render();
	public boolean dead();
}


class AnimatedRayCast implements Castable{ //TODO favor over inheritance
	ArrayList<Ray> rays = new ArrayList<Ray>();
	boolean dead = false;
	public AnimatedRayCast(int noRays, PVector origin){
		for(int i = noRays; i > 0; i--) {
			Ray ray = new AnimatedRay(map(i, 0, noRays, 0, 360-1), origin);
			rays.add(ray);
		}
	}

	public void act() {
		boolean possiblyAlive = false;
		
		for (Ray ray:rays) {
			if (!ray.dead) {
				possiblyAlive = true;
			}
			ray.act();
		}
		if (!possiblyAlive) {
			this.dead = true;
		}
		println("dead?"+this.dead);
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


class RayCast implements Castable{
	ArrayList<Ray> rays = new ArrayList<Ray>();
	boolean dead = false;

	public RayCast(int noRays, PVector origin) {
		for(int i = noRays; i > 0; i--) {
			Ray ray;
			if(fast) {
				ray = new FastRay(map(i, 0, noRays, 0, 360), origin);
			}else {
				ray = new Ray(map(i, 0, noRays, 0, 360), origin);
			}
			rays.add(ray);
		}
		
		for (Ray ray:rays) {
			ray.act();
		}
		this.dead = true;
	}

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
}

