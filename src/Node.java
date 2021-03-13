import processing.core.PApplet;


public class Node {

    public static PApplet parent;

    public int x, y;
    public float posX, posY;

    public float g, h;
    public boolean wall;
    public Node previous = null;

    public int c = -1;

    public Node(int x, int y) {
        this.x = x;
        this.y = y;
        this.g = Float.MAX_VALUE;
        this.h = Float.MAX_VALUE;
    }

    public void show(float w, float h, int curve) {
        if (wall) parent.fill(0);
        else      parent.fill(c);
        parent.rect(posX, posY, w, h, curve);
    }
}
