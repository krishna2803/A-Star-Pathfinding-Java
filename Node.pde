public class Node {
    public int x, y;
    public float posX, posY;
    public float g, h;
    public boolean wall;
    public Node previous = null;
    public color c = color(255);
    public Node(int x, int y) {
        this.x = x;
        this.y = y;
        this.g = Float.MAX_VALUE;
        this.h = Float.MAX_VALUE;
    }
    public void show(float w, float h, int curve) {
        if (wall) fill(0);
        else fill(c);
        rect(posX, posY, w, h, curve);
    }
}