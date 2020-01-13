// Import area
import java.util.Iterator;


// Astro class
class Astro {
    
    // Setup variables
    int index;
    
    PVector position;
    PVector velocity;
    PVector acceleration;
    
    float mass;
    float size;
    
    float maxAcceleration = 10;
    float maxVelocity = 5;

    // Setup environment
    Astro (float x, float y, float inputMass, float inputSize, int inputIndex) {
        
        index = inputIndex;
        
        // Initialize size and mass
        mass = inputMass;
        size = inputSize;
        
        // Initialize vectors
        position = new PVector(x, y);
        acceleration = new PVector();
        velocity = new PVector();
    }
    
    
    // Update position
    void update (ArrayList<Astro> objects) {
        
        // Calcule new vectors
        position.add(velocity);
        velocity.add(acceleration);
        
        // Apply forces
        acceleration.mult(0);
        
        for (Astro object : objects) {
            if (object != this) {
                PVector gravity = applyGravity(object);
                acceleration.add(gravity);
            }
        }
        
        // Adjust results
        acceleration.limit(maxAcceleration);
        velocity.limit(maxVelocity);
    }
    
    
    void meltObjects (ArrayList<Astro> objects) {
        
        // Initialize variables    
        float bigX;
        float bigY;
        float smallX;
        float smallY;
          
        Iterator iterator = objects.iterator();
        Astro object;
        
        // Iterate for every astro
        while (iterator.hasNext()) {
            
            // Initialize object
            object = (Astro)iterator.next();
            
            // Check if object it is not itself
            if (object != this && object.size <= size) {
                    
                 // Get position
                 bigX = position.x;
                 bigY = position.y;
                 smallX = object.position.x;
                 smallY = object.position.y;
                
                 // Check if one is inside another
                 float distance = dist(bigX, bigY, smallX, smallY);
                 if (distance <= 4 * (object.size / 10)) {
                     iterator.remove();
                     
                     size += object.size / 2;
                     mass += object.mass / 2;
                     
                     // Calcule average velocity
                     acceleration.mult(0);
                     
                     PVector objectVector = PVector.mult(object.velocity, object.mass);
                     PVector thisVector = PVector.mult(velocity, mass);
                     
                     PVector newVelocity = PVector.add(objectVector, thisVector);
                     newVelocity.div(2);
                     newVelocity.limit(maxVelocity);
                     velocity = newVelocity;
                 }
            }
        }
    }
    
    
    // Calcule gravity
    PVector applyGravity (Astro object) {
        
        // Setup variables
        PVector force = PVector.sub(object.position, position);
        float distance = force.mag();
        force.normalize();
        
        if (distance == 0) {
            return force.mult(0);
        }
        
        float G = 1;
        float m1 = mass;
        float m2 = object.mass;
        
        // Calcule force
        double gravity = G * ((m1 * m2) / (distance * distance));
        force.mult((float)gravity);
        
        // Return vector
        return force;
    }
  
}
