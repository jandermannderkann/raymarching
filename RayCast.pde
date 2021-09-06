boolean fast = true;
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
			Ray ray = spawnRay(map(i,0,noRays,0,360),origin);
			rays.add(ray);
		}
	}


	public Ray spawnRay(float angle, PVector origin) {
		Ray ray;
			if(traceMode) {
				ray = new TracedRay(angle, origin);
			} else if (fast) {
				ray = new FastRay(angle, origin);
			} else if (animated){
				ray = new AnimatedRay(angle, origin);
			} else {
				ray = new Ray(angle, origin);
			}
			return ray;
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

