

class Poil{
  Vector2f pos = new Vector2f(0,0);
  float h;

  Vector2f velocity;
  Vector2f force;

  float velNorm;
  float addX;
  float addY;
  float tmpH;
  
  public Poil(float x, float y, float h, float var){
    pos.x = x + random(var) - var / 2f;
    pos.y = y + random(var) - var / 2f;
    this.h = h;
    velocity = new Vector2f(0,0);
    force = new Vector2f(1,1);
  }
  
  public void update(){
    velocity.x += -force.x * standCoef;
    velocity.y += -force.y * standCoef;
    
    if (wind){
      velocity.x += cos(noise(pos.x / windSpace , pos.y / windSpace, millis() / windTime) * 4f * PI) * windForce;
      velocity.y += sin(noise(pos.x / windSpace , pos.y / windSpace, millis() / windTime) * 4f * PI) * windForce;
    }
    force.x *= absorption;
    force.y *= absorption;
    
    force.x += velocity.x;
    force.y += velocity.y;
    
    
    force.norm();
    velNorm = (-1f / pow(force.norm * var + 1f,2) + 1) * h ;
    addX = (force.x / force.norm) * velNorm;
    addY = (force.y / force.norm) * velNorm;
    tmpH = sin(acos(velNorm / h)) * h;
    //vertex(pos.x + addX * heightCoef, pos.y + addY * heightCoef, tmpH * heightCoef);
    
    
  }
  
  public void addVelocity(Vector2f amount){
    velocity.x += amount.x;
    velocity.y += amount.y;
  }
}
