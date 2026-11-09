
public class FastNearestObstacleFinder extends NearestObstacleFinder{
	//ArrayList<NearestObstacleGuess> haystack;
	//NearestObstacleGuess lastHit = null; 

	public FastNearestObstacleFinder(ArrayList<Obstacle> obstacles) {
		super(obstacles);
	}

	public Obstacle getNearestObstacle(PVector p) {
		NearestObstacleGuess closest = this.lastHit;
		float minDist = diagonal;
		ArrayList<NearestObstacleGuess> leaving = new ArrayList<NearestObstacleGuess>();

		for (NearestObstacleGuess guess: this.haystack) { 
			float dist = guess.obstacle.dist(p);

			if (dist > guess.dist) {
				leaving.add(guess);
			}
			guess.dist = dist;

			minDist = min(minDist,dist);
			if (minDist == dist) {
				closest = guess; //TODO improve?
			}
		}
		leaving.remove(closest);

		for (NearestObstacleGuess leaver: leaving) {
			this.haystack.remove(leaver);
		}
		return closest.obstacle;
	}
}

public class NearestObstacleFinder {
	ArrayList<NearestObstacleGuess> haystack;
	NearestObstacleGuess lastHit = null; 

	public NearestObstacleFinder(ArrayList<Obstacle> obstacles) {
		this.haystack = new ArrayList<NearestObstacleGuess>();
		for (Obstacle obstacle: obstacles) {
			this.haystack.add(new NearestObstacleGuess(obstacle, diagonal));
		}
	}

	public Obstacle getNearestObstacle(PVector p) {
		NearestObstacleGuess closest = lastHit;
		float minDist = diagonal;
		for (NearestObstacleGuess guess: this.haystack) { 
			float dist = guess.obstacle.dist(p);

			minDist = min(minDist,dist);
			if (minDist == dist) {
				closest = guess; //TODO improve?
			}
		}

		this.lastHit = closest;
		return closest.obstacle;
	}
}