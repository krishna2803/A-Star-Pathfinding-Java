import processing.core.PApplet;
import java.util.ArrayList;

public class Grid {

    private static PApplet parent;

    private Node nodes[][];
    private float dw;

    public float D1 = 1;
    public float D2 = 1;

    public Grid(int cols, int rows, PApplet parent) {
        this.parent = parent;
        nodes = new Node[cols][rows];
        dw = (float) parent.min(parent.width, parent.height) / parent.max(cols, rows);

        float wallChance = 0.3f;

        Node.parent = parent;
        for (int i=0; i<cols; i++) 
            for (int j=0; j<rows; j++) {
                nodes[i][j] = new Node(i, j);
                nodes[i][j].posX = (i+0.5f) * dw;
                nodes[i][j].posY = (j+0.5f) * dw;

                nodes[i][j].wall = parent.random(1) < wallChance;
            }
    }

    public float distSq(float x1, float y1, float x2, float y2) { return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2); }
    public float distSq(Node n1, Node n2) { return distSq(n1.x, n1.y, n2.x, n2.y); }
    public Node closest(float x, float y) {  return nodes[parent.constrain(parent.floor(x / dw), 0, nodes.length-1)][parent.constrain(parent.floor(y / dw), 0, nodes[0].length-1)]; }
    private float heuristic(Node n, Node end) {
        float dx = parent.abs(n.x - end.x);
        float dy = parent.abs(n.y - end.y);
        return D1 * (dx + dy) + (D2 - 2 * D1) * parent.min(dx, dy);
    }
    public void reset() {
        for (int i=0; i<nodes.length; i++) 
            for (int j=0; j<nodes[i].length; j++) {
                nodes[i][j].g = Float.MAX_VALUE;
                nodes[i][j].h = 0;
                nodes[i][j].previous = null;
            }
    }
    public ArrayList<Node> pathfind(float x1, float y1, float x2, float y2, boolean diagonalSearch) {
        reset();
        ArrayList<Node> path = new ArrayList<Node>();
        boolean openSet[][] = new boolean[nodes.length][nodes[0].length];

        Node start = nodes[parent.constrain(parent.floor(x1/dw), 0, nodes.length-1)][parent.constrain(parent.floor(y1/dw), 0, nodes[0].length-1)];
        Node end   = nodes[parent.constrain(parent.floor(x2/dw), 0, nodes.length-1)][parent.constrain(parent.floor(y2/dw), 0, nodes[0].length-1)];
        Node current = null;

        openSet[start.x][start.y] = true;
        start.g = 0;
        start.h = heuristic(start, end);

        start.c = parent.color(25, 255, 25);
        end.c   = parent.color(255, 25, 25);
        end.wall = false;
        
        int closed = 0;
        int max = nodes.length * nodes[0].length;
        while (closed < max) {
            float fmin = Float.MAX_VALUE;
            for (int i=0; i<nodes.length; i++) 
                for (int j=0; j<nodes[i].length; j++)
                    if (openSet[i][j]) {
                        float f = nodes[i][j].g + nodes[i][j].h;
                        if (f < fmin) {
                            fmin = f;
                            current = nodes[i][j];
                        }
                    }

            if (current.equals(end)) {
                while (current.previous != null && current.previous!=start) {
                    path.add(current.previous);
                    current = current.previous;
                }
                return path;
            }

            openSet[current.x][current.y] = false;
            closed ++;
            for (Node neighbor : neighbors(current, diagonalSearch)) {
                float tentative = current.g + distSq(current, neighbor);
                if (tentative < neighbor.g) {
                    neighbor.previous = current;
                    neighbor.g = tentative;
                    neighbor.h = heuristic(neighbor, end);
                    if (!openSet[neighbor.x][neighbor.y]) {
                        openSet[neighbor.x][neighbor.y] = true;
                        closed ++;
                    }
                }
            }
        }
        return path; // no solution
    }
    public ArrayList<Node> pathfind(float x1, float y1, float x2, float y2) { return pathfind(x1, y1, x2, y2, false); }
    public void recolor() {
        for (int i=0; i<nodes.length; i++)
            for (int j=0; j<nodes[i].length; j++)
                nodes[i][j].c = parent.color(255);
    }
    public ArrayList<Node> neighbors(Node n, boolean diagonalSearch) {
        ArrayList<Node> res = new ArrayList<Node>();
        if (diagonalSearch) {
            for (int i=n.x-1; i<=n.x+1; i++) 
                if (i >= 0 && i < nodes.length)
                    for (int j=n.y-1; j<=n.y+1; j++) 
                        if ((j >= 0 && j < nodes[i].length) && (n.x != i && n.y != j))
                            if (!nodes[i][j].wall)
                                res.add(nodes[i][j]);
        } else {
                if (n.x-1 >= 0)             if (!nodes[n.x-1][n.y].wall) res.add(nodes[n.x-1][n.y]);
                if (n.x+1 < nodes.length)   if (!nodes[n.x+1][n.y].wall) res.add(nodes[n.x+1][n.y]);
                if (n.y-1 >= 0)             if (!nodes[n.x][n.y-1].wall) res.add(nodes[n.x][n.y-1]);
                if (n.y+1 < nodes[0].length)if (!nodes[n.x][n.y+1].wall) res.add(nodes[n.x][n.y+1]);
        }
        return res;
    }
    public ArrayList<Node> neighbors(Node n) { return neighbors(n, false); }
    public void show() {
        float padding = 0.0f;
        parent.rectMode(PApplet.CENTER);
        parent.strokeWeight(0.5f);
        for (int i=0; i<nodes.length; i++) 
            for (int j=0; j<nodes[i].length; j++)
                nodes[i][j].show(dw * (1.0f-padding), dw * (1.0f-padding), 0);
    }
}
