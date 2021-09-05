interface Obstacle {
  public boolean intersects(PVector needle);
  public float dist(PVector target);
  public void render();
  public void mark();
}
 
boolean noborder = true;
public class CircObstacle implements Obstacle {
  PVector anchor;
  float rad;
  color col = 0;
public CircObstacle(PVector c1, PVector c2) {
    this.anchor =  c1;
    float dx = c2.x-c1.x;
    float dy = c2.y-c1.y;
    this.rad = c1.dist(c2);
  }

  public void mark() {
    this.col = color(100,0,0);
  }

  public PVector pos () {
    return anchor;
  }
  
  public float dist(PVector target) {
    return anchor.dist(target)-rad; //TODO fix
  }

    @Override
    public String toString() {
        return String.format("("+this.anchor+")");
    }

  public void render() {
    if (this.col != 0) {
      fill(this.col);
    } else {
      fill(bgcol);
    }
    noStroke();
	  if (!noborder){stroke(50);}
	  circle(anchor.x, anchor.y, rad*2);
	  //circle(anchor.x, anchor.y, 5);
  }

   public boolean intersects (PVector sample) {
	if (sample.dist(anchor) < rad) {
		return true;
	}
	return false;
   }
 
}


public class RectObstacle implements Obstacle {
  PVector anchor;
  float w;
  float h;
  public PVector pos () {
    return anchor;
  }//TODO remove

  public float dist(PVector target) {
    return anchor.dist(target); //TODO
  }
  
  public void mark() {
  }

  public boolean intersects (PVector sample) {

	  if (sample.x > anchor.x && sample.x< anchor.x + w) {
		  stroke(255,0,0);
		  line(anchor.x, anchor.y, sample.x, sample.y);
		  if (sample.y > anchor.y && sample.y < anchor.y + h) {
			  delay(100);
			circle(sample.x, sample.y, 50);
		  	line(anchor.x, anchor.y, sample.x, sample.y);
			return true;
		  }
	  }

	  //TODO CHECK LINE INTERSECTION

       for (PVector corner: this.corners()) {
	 
	int hits  =0;
      } 

	return false;
  }


	public float size() {
		return max(w,h);
	}

  public PVector[] corners() {
	  PVector[] corners = new PVector[4];
	  corners[0] = this.anchor;
	  corners[1] = new PVector(this.anchor.x+w, this.anchor.y);
	  corners[2] = new PVector(this.anchor.x, this.anchor.y+h);
	  corners[3] = new PVector(this.anchor.x+w, this.anchor.y+h);

	  return corners;

  }
  public String str() {
    return "("+anchor.x+","+anchor.y+")"+w+"--"+h;
  }

  public void render() {
    fill(0);
    stroke(255);
    rect(anchor.x, anchor.y, w, h); 
    circle(anchor.x, anchor.y, 5);


  }

  public RectObstacle(PVector c1, PVector c2) {
    this.anchor =  c1;

    float dx = c2.x-c1.x;
    float dy = c2.y-c1.y;
    w = dx;
    h = dy;
  }

  public RectObstacle(int x, int y, int x2, int y2) {
    this.anchor = new PVector(x,y);
    float dx = x2-x;
    float dy = y2-y;
  }
}
