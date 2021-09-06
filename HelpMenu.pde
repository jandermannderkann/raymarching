boolean help_visible = false;

class HelpMenu {
	ArrayList<String> commands = new ArrayList<String>();
	PVector anchor;
	float line_height;


	public HelpMenu () {
		this.anchor = new PVector(width/4, height/10);
		this.line_height = height/30; //TODO 30 = max(comands, 30)
	}

	public ArrayList<String> getCommands() { 
		ArrayList<String> tmp = new ArrayList<String>();

		//tmp.add("#rays= "+noRays);
		//tmp.add("#obstacles= "+noObstacles);
		//tmp.add("grainSize = "+grainSize);
		tmp.add("a: toggle animation");
		tmp.add("t: toggle trajectory");
		tmp.add("f: toggle fast calculation");
		tmp.add("+/-: inc/deacrease amount of rays");
		tmp.add("r: toggle rendering of rays");
		tmp.add("c: toggle circles");
		tmp.add("m: only animate on mouse move");
		tmp.add("h: toggle help");
		//for (int i = 0; i < cmd_info.length; i++) {
			//commands.add(cmd_info[i]); //TODO commands.fromArray or something similar
		//}
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
		stroke(150);
		fill(50);
		float height = max(commands.size(),4)*line_height;
		rect(anchor.x, anchor.y, anchor.x+width/4, anchor.y+height);
		int c = 1;
		for (String cmd: this.getCommands()) {
			fill(200);
			text(cmd, anchor.x + 10, anchor.y+c*line_height);
			c++;
		}
		c=1;
		for (String stat: this.getStats()) {
			fill(200);
			text(stat, anchor.x + width/4, anchor.y+c*line_height);
			c++;
		}
	}
}


void initHelp() {
	this.helpDialog = new HelpMenu();
	//this.helpDialog.setCommands(cmd_info);
}