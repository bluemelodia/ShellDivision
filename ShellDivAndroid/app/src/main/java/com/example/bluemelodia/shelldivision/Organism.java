package com.example.bluemelodia.shelldivision;

/**
 * Created by bluemelodia on 3/10/16.
 */
public class Organism {
    public enum Species {
        Empty, Snapper, Sea
    }

    private Species sp;

    public void spawn(Species species) {
        switch (species) {
            case Empty:
                sp = Species.Empty;
                break;
            case Snapper:
                sp = Species.Snapper;
                break;
            case Sea:
                sp = Species.Sea;
                break;
        }
    }

    public Species getSpecies() {
        return sp;
    }

    public void setSpecies(Species species) {
        sp = species;
    }
}
