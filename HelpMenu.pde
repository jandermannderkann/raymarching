boolean help_visible = false;

class HelpMenu {
	ArrayList<String> commands = new ArrayList<String>();
	PVector anchor;
	float line_height;

	public HelpMenu () {
		this.anchor = new PVector(width/4, height/10);
		this.line_height = 30; //TODO height/30 30 = max(comands, 30)
	}

	public ArrayList<String> getCommands() { 
		ArrayList<String> tmp = new ArrayList<String>();
		tmp.add("a: toggle animation (" + animated + ")");
		tmp.add("t: toggle trajectory (" + renderTrajectory);
		tmp.add("f: toggle fast calculation (" + fast);
		tmp.add("+/-: inc/deacrease amount of rays");
		tmp.add("r: toggle rendering of rays (" + renderRay + ")");
		tmp.add("c: toggle circle modes (" + renderCircle + ")");
		tmp.add("m: only animate on mouse move (" + animateOnMouseMove+ ")");
		tmp.add("h: toggle help");
		return tmp;
	}


	public ArrayList<String> getStats() {
		ArrayList<String> tmp = new ArrayList<String>();
		tmp.add("#rays= "+noRays);
		tmp.add("#obstacles= "+noObstacles);
		tmp.add("grainSize = "+grainSize);
		return tmp;
	}

	void render() {
		ArrayList<String> col1 = this.getCommands();
		ArrayList<String> col2 = this.getStats();
		float height = (max(max(col1.size(),col2.size()),4)-2)*line_height;

		stroke(150);
		fill(50);
		rect(anchor.x, anchor.y, anchor.x+width/4, anchor.y+height);

		float marg_ver = line_height;
		float marg_hor = 20;
		int c = 0;
		for (String row: col1) {
			fill(200);
			text(row, anchor.x + marg_hor, anchor.y+c*line_height + marg_ver);
			c++;
		}
		c = 0;
		for (String row: col2) {
			fill(200);
			text(row, anchor.x + marg_hor + width/4, anchor.y+c*line_height + marg_ver);
			c++;
		}
	}
}