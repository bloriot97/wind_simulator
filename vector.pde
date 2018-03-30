class Vector2f{
  public float x,y,norm;
  
  public Vector2f(float x, float y){
    this.x = x;
    this.y = y;
    norm();
  }
  
  public void norm(){
    norm = sqrt(x*x + y*y);
  }
  
  public float getDist(Vector2f vec){
    return sqrt( pow(x - vec.x, 2) + pow(y - vec.y, 2));
  }
  
  public Vector2f normalize(){
    x /= norm;
    y /= norm;
    return this;
  }
}


