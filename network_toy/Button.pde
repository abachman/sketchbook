class Button {
    int x,y,r,b;
    int hw;
    boolean state;
    Button(int px, int py) {
        x = px;
        y = py;
        hw = 15;
        r = x + hw;
        b = y + hw;
        state = false;
    }
    void drawme() {
        stroke(0);
        if (state) fill(0);
        else noFill();
        rect(x,y,hw,hw);
    }
    boolean update(float cx, float cy) {
        if (cx > x && cx < r && cy > y && cy < b) {
            state = !state;
            return true;
        }
        return false;
    }
}
