int renderCircle = 1;
class RayCastSearchArea {
	PVector origin;
	Obstacle target;
	float diam;
	color col;

	public RayCastSearchArea(PVector origin, Obstacle target) {
		this.origin=origin;
		this.target=target;
		if (target == null) {
			this.diam = max(width, height);
		}else {
			this.diam = target.dist(origin)*2;
		}
		float dist = origin.dist(centerP);
		float mapping = map(dist, 0, max(width,height), 0, 1);
		this.col = lerpColor(c1, c2, mapping);
	}

	public void render() {
		noFill();
		if (colored) {
			fill(this.col);
		}else {
		}
		if (renderCircle == 0){
			stroke(150,100);
		}else if (renderCircle == 1){
			stroke(150,20);
		}else {
			noStroke();
		}


		circle(this.origin.x, this.origin.y, this.diam);
	}
}