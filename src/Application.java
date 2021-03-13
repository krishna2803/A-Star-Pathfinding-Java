import processing.core.PApplet;


public class Application extends PApplet {

    private Grid grid;
    private float targetX;
    private float targetY;

    public static void main(String ... args) {
        PApplet.main(Application.class.getName());
    }

    @Override
    public void settings() {
        size(640, 640);
    }

    @Override
    public void setup() {
        targetX = width * 0.5f;
        targetY = height * 0.5f;
        grid = new Grid(40, 40, this);
        background(255);
    }

    @Override
    public void draw() {
        grid.show();

        if (mousePressed && mouseButton == RIGHT) {
            targetX = mouseX;
            targetY = mouseY;
        }
    }

    @Override
    public void keyPressed() {
        if (key == ENTER || key == RETURN) {
            grid.recolor();
            for(Node node : grid.pathfind(mouseX, mouseY, targetX, targetY, false)) node.c = color(30, 30, 255);
        }
    }
}
