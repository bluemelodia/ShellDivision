package com.example.bluemelodia.shelldivision;

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
}
