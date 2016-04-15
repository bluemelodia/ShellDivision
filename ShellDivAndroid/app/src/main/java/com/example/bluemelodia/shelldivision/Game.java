package com.example.bluemelodia.shelldivision;

import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.List;

/**
 * Created by bluemelodia on 3/10/16.
 */
public class Game {
    public enum Turn {
        P1, P2
    }

    private int era;
    private Turn turn;

    public Turn getTurn() {
        return turn;
    }

    public void setTurn(Turn t) {
        turn = t;
    }

    public int getEra() {
        return era;
    }

    public void setEra(int e) {
        era = e;
    }

    public int elapseTime() {
        era--;
        return era;
    }

    public void saveGameState(SharedPreferences mprefs) {
        SharedPreferences.Editor editor = mprefs.edit();
        Gson gson = new Gson();
        String jsonTurn = gson.toJson(this.turn);
        editor.putString("Turn", jsonTurn);
        editor.putInt("Era", this.era);
        editor.commit();
    }

    public Game loadGameState(SharedPreferences mprefs, Game newGame) {
        Gson gson = new Gson();
        String jsonTurn = mprefs.getString("Turn", Turn.P1.toString());
        Type typeTurn = new TypeToken<Turn>(){}.getType();
        Turn gameTurn = gson.fromJson(jsonTurn, typeTurn);
        int gameEra = mprefs.getInt("Era", 300);
        newGame.setEra(gameEra);
        newGame.setTurn(gameTurn);
        return newGame;
    }
}
