// Setup variables
ArrayList<Astro> Objects;

boolean update = false;
int index = 0;
float scale = 60;


// Setup environment
void setup () {
    
    // Create canvas
    size(1000, 800);
    background(10, 10, 20);
    colorMode(HSB);
    
    // Initialize variables
    Objects = new ArrayList<Astro>();
}


// Create new astro
void mousePressed() {
    
    Astro object = new Astro(mouseX, mouseY, 100, 50, index);
    Objects.add(object);
    index++;
}


// Start simulation 
void keyPressed() {

    if (key == ' ') {
        update = !update;
    }
}


// Draw objects
void draw () {
    
    // Draw background
    background(10, 10, 20);
    
    // Change pixels colors
    changePixels();
    
    // Update galaxies objects positions
    if (update) { 
        for (Astro object : Objects) {
            object.update(Objects);
        }
    }
    
    // Check if objects melt
    Iterator index = Objects.iterator();
    Astro object;
    
    ArrayList<Astro> copyArray = (ArrayList<Astro>)Objects.clone();
    while(index.hasNext()) {
    
         // Initialize object
         object = (Astro)index.next();
         object.meltObjects(copyArray);
    }
    
    Objects = copyArray;
}


// Change canvas pixels
void changePixels () {
    
    // Initialize variables
    float distanceSum;
    
    int index;
    int objectsIndex;
    
    int X;
    int Y;
    
    // Load pixels into an array
    loadPixels();
    
    // Iterate for every pixel
    for (X = 0; X < width; X++) {
        for (Y = 0; Y < height; Y++) {
            
            // Get pixel color
            distanceSum = 0;
            
            for (objectsIndex = 0; objectsIndex < Objects.size(); objectsIndex++) {
                Astro object = Objects.get(objectsIndex);
                distanceSum += calculePixel(object, X, Y);
            }
            
            distanceSum = constrain(distanceSum, 0, 255);

            // Change pixel color
            index = X + (Y * width);
            pixels[index] = color(160, 50, distanceSum);
        }
    }
    
    // Render pixels
    updatePixels();
}


// Calcule pixel color
float calculePixel (Astro object, int X, int Y) {
    
    // Initialize variables
    float newScale = 0;
    
    float finalValue;
    float distance;
    
    float objectX;
    float objectY; 
    
    // Get object position
    objectX = object.position.x;
    objectY = object.position.y;
                        
    // Add the distance to the sum
    distance = dist(X, Y, objectX, objectY);
    newScale = scale - (distance * 0.05);
    finalValue = newScale * (object.size / distance);
    
    return finalValue;
}
