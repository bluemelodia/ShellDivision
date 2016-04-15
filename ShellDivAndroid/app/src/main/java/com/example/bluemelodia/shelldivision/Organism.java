package com.example.bluemelodia.shelldivision;

import android.content.Context;
import android.content.SharedPreferences;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * Created by bluemelodia on 3/10/16.
 */
public class Organism {
    protected Context context;

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

    public void saveOrganism(Context context) {
        SharedPreferences prefs = (SharedPreferences) context.getApplicationContext();
        SharedPreferences.Editor editor = prefs.edit();
        Gson gson = new Gson();
        editor.putString("Organism", gson.toJson(this));
        editor.commit();
    }

    public Organism loadOrganism() {
        Gson gson = new GsonBuilder().create();
        return gson.fromJson("Organism", Organism.class);
    }
}
