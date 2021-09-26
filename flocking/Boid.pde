class Boid {
    PVector pos = new PVector(random(width), random(height));
    PVector vel = PVector.random2D().setMag(random(1,5));
    PVector acc = new PVector(0, 0);
    float max_turn = 0.02;
    float max_speed = random(2,4);
    float ali = random(35,50);
    float coh = random(50,100);
    float sep = random(50,100);

    Boid() {}

    void flock(ArrayList<Boid> boids) {
        PVector alignment = new PVector();
        PVector cohesion = new PVector();
        PVector separation = new PVector();
        float alignment_perception = ali;
        float cohesion_perception = coh;
        float separation_perception = sep;
        int alignment_total = 0;
        int cohesion_total = 0;
        int separation_total = 0;
        
        for (Boid b : boids) {
            float b_dist = PVector.dist(b.pos, this.pos);

            if (this != b && (b_dist < alignment_perception)) {
                alignment.add(b.vel);
                alignment_total++;
            }

            if (this != b && (b_dist < cohesion_perception)) {
                cohesion.add(b.pos);
                cohesion_total++;
            }

            if (this != b && (b_dist < separation_perception)) {
                PVector diff = PVector.sub(this.pos, b.pos);
                diff.mult(1/b_dist);
                separation.add(diff);
                separation_total++;
            }
        }

        if (alignment_total > 0) {
            alignment.div(alignment_total);
            alignment.setMag(max_speed);
            alignment.sub(vel);
            alignment.limit(max_turn);
            acc.add(alignment);
        }

        if (cohesion_total > 0) {
            cohesion.div(cohesion_total);
            cohesion.sub(pos);
            cohesion.setMag(max_speed);
            cohesion.sub(vel);
            cohesion.limit(max_turn);
            acc.add(cohesion);
        }

        if (separation_total > 0) {
            separation.div(separation_total);
            separation.setMag(max_speed);
            separation.sub(vel);
            separation.limit(max_turn);
            acc.add(separation);
        }
    }

    void update() {
        pos.add(vel);
        vel.add(acc);
        acc.mult(0);
        vel.limit(max_speed);

        if (pos.x > width) {
            pos.x = 0;
        } else if (pos.x < 0) {
            pos.x = width;
        }

        if (pos.y > height) {
            pos.y = 0;
        } else if (pos.y < 0) {
            pos.y = height;
        }
    }

    void show() {
      if (this != pickedBoid) {
        stroke(255);
        fill(255);
      } else {
        stroke(255, 0, 0);
        fill(255, 0, 0);
      }
      
      ellipse(pos.x, pos.y, 5, 5);
      line(pos.x, pos.y, pos.x+vel.x*10, pos.y+vel.y*10);
    }
}
