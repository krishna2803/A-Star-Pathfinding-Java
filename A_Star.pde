public boolean h;

Grid grid;
float targetX, targetY;

long t = 0;
long delta_t = 200; // milliseconds before triggering another event
boolean diagonalSearch = false;

void settings() {
    size(640, 640);
}

void setup() {
    grid = new Grid(69, 69);
    targetX = width/2;
    targetY = width/2;
}

void draw() {
    background(255);
    
    grid.show();

    if (millis() > t) {
        if (mousePressed) {
            if (mouseButton == LEFT) {
                Node node = grid.closest(mouseX, mouseY);
                node.wall = !node.wall;
                t = millis() + delta_t;
            }
        }
    }
}

void keyPressed() {
    if (key == ENTER || key == RETURN) {
        grid.recolor();
        ArrayList<Node> path = grid.pathfind(mouseX, mouseY, targetX, targetY, diagonalSearch);
        for (Node node : path) node.c = color(25, 25, 255);
    }
    if (Character.toLowerCase(key) == 'd') diagonalSearch = !diagonalSearch;
    if (Character.toLowerCase(key) == 'h') h = !h;
}

void mouseClicked() {
    if (mouseButton == RIGHT) {
        targetX = mouseX;
        targetY = mouseY;
    }
}
