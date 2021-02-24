public class Grid {
    Node nodes[][];
    float dw;

    float D1 = 1; // scale for UDLR distance
    float D2 = 1; // scale for diagonal distance

    public Grid(int cols, int rows) {
        nodes = new Node[cols][rows];
        dw = (float) min(width, height) / cols;

        float xoff = 0;
        float yoff = 0;
        float delta = 0.01f;
        float wallChance = 0.3;

        for (int i=0; i<cols; i++) {
            for (int j=0; j<rows; j++) {
                nodes[i][j] = new Node(i, j);
                nodes[i][j].posX = (i+0.5) * dw;
                nodes[i][j].posY = (j+0.5) * dw;

                nodes[i][j].wall = random(1) < wallChance;
                xoff += delta;
            }
            yoff += delta;
        }
    }

    public float distSq(float x1, float y1, float x2, float y2) { return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2); }
    public float distSq(Node n1, Node n2) { return distSq(n1.x, n1.y, n2.x, n2.y); }
    public Node closest(float x, float y) {
        int approxX = floor(x / dw);
        int approxY = floor(y / dw);
        approxX = constrain(approxX, 0, nodes.length-1);
        approxY = constrain(approxY, 0, nodes[0].length-1);
        return nodes[approxX][approxY];
    }
    // diagonal distance heuristic function for optimity
    private float heuristic(Node n, Node end) {
        if (h) {
            float dx = abs(n.x - end.x);
            float dy = abs(n.y - end.y);
            return D1 * (dx + dy) + (D2 - 2 * D1) * min(dx, dy);
        }
        return distSq(n.x, n.y, end.x, end.y);
    }
    public void reset() {
        for (int i=0; i<nodes.length; i++) 
            for (int j=0; j<nodes[i].length; j++) {
                nodes[i][j].g = Float.MAX_VALUE;
                nodes[i][j].h = 0;
                nodes[i][j].previous = null;
            }
    }
    public ArrayList<Node> pathfind(float x1, float y1, float x2, float y2, boolean diagonals) {
        reset();
        ArrayList<Node> path = new ArrayList();
        boolean openSet[][] = new boolean[nodes.length][nodes[0].length];

        Node start = nodes[constrain(floor(x1/dw), 0, nodes.length-1)][constrain(floor(y1/dw), 0, nodes[0].length-1)];
        Node end   = nodes[constrain(floor(x2/dw), 0, nodes.length-1)][constrain(floor(y2/dw), 0, nodes[0].length-1)];
        Node current = null;

        openSet[start.x][start.y] = true;
        start.g = 0;
        start.h = heuristic(start, end);

        start.c = color(25, 255, 25);
        end.c   = color(255, 25, 25);
        end.wall = false;
        
        while (!allfalse(openSet)) {
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
            for (Node neighbor : neighbors(current, diagonals ? 8 : 4)) {
                float tentative = current.g + distSq(current, neighbor);
                if (tentative < neighbor.g) {
                    neighbor.previous = current;
                    neighbor.g = tentative;
                    neighbor.h = heuristic(neighbor, end);
                    if (!openSet[neighbor.x][neighbor.y])
                         openSet[neighbor.x][neighbor.y] = true;
                }
            }
            current.c = color(255, 255, 25);
        }
        return path; // no solution
    }
    // look in 8 directions {U, D, L, R, UL, UR, DL, DR} by default
    public ArrayList<Node> pathfind(float x1, float y1, float x2, float y2) { return pathfind(x1, y1, x2, y2, false); }

    private boolean allfalse(boolean[][] set) {
        for (int i=0; i<set.length; i++)
            for(int j=0; j<set[i].length; j++)
                if (set[i][j]) return false;
        return true;
    }
    public void recolor() {
        for (int i=0; i<nodes.length; i++)
            for (int j=0; j<nodes[i].length; j++)
                nodes[i][j].c = color(255);
    }
    public ArrayList<Node> neighbors(Node n, int fourOrEignt) {
        ArrayList<Node> res = new ArrayList();
        if (fourOrEignt == 8) {
            for (int i=n.x-1; i<=n.x+1; i++) 
                if (i >= 0 && i < nodes.length)
                    for (int j=n.y-1; j<=n.y+1; j++) 
                        if ((j >= 0 && j < nodes[i].length) && (n.x != i && n.y != j))
                            if (!nodes[i][j].wall)
                                res.add(nodes[i][j]);
        } else if (fourOrEignt == 4) {
                if (n.x-1 >= 0)             if (!nodes[n.x-1][n.y].wall) res.add(nodes[n.x-1][n.y]);
                if (n.x+1 < nodes.length)   if (!nodes[n.x+1][n.y].wall) res.add(nodes[n.x+1][n.y]);
                if (n.y-1 >= 0)             if (!nodes[n.x][n.y-1].wall) res.add(nodes[n.x][n.y-1]);
                if (n.y+1 < nodes[0].length)if (!nodes[n.x][n.y+1].wall) res.add(nodes[n.x][n.y+1]);
        }
        return res;
    }
    public ArrayList<Node> neighbors(Node n) { return neighbors(n, 8); }
    
    public void show() {
        rectMode(CENTER);
        float padding = 0.0f;
        strokeWeight(0.5);
        for (int i=0; i<nodes.length; i++) 
            for (int j=0; j<nodes[i].length; j++)
                nodes[i][j].show(dw * (1-padding), dw * (1-padding), 0);
    }
}
