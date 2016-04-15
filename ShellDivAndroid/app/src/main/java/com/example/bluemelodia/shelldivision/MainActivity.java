package com.example.bluemelodia.shelldivision;

import android.content.SharedPreferences;
import android.provider.Settings;
import android.media.Image;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends CustomActivity {
    public static final String EVENT_MESSAGES = "EventMessages";
    public static final String TILE_STATES = "TileStates";
    public static final String GAME_STATE = "GameState";
    private static ImageAdapter adapter;
    private Game game;
    TextView eraLabel;
    TextView snapperPopulation;
    TextView seaPopulation;
    TextView event;
    TextView details;
    ImageView nextTurn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // load in the previous game state and messages, or set to default values if first time playing
        SharedPreferences gamePrefs = getSharedPreferences("GAME_STATE", 0);
        game = new Game();
        game.loadGameState(gamePrefs, game);

        eraLabel = (TextView) findViewById(R.id.eraLabel);
        eraLabel.setText(String.valueOf(game.getEra()) + "mya");

        snapperPopulation = (TextView) findViewById(R.id.snapperPopulation);
        seaPopulation = (TextView) findViewById(R.id.seaPopulation);

        SharedPreferences eventMessage = getSharedPreferences(EVENT_MESSAGES, 0);
        event = (TextView) findViewById(R.id.event);
        event.setText(eventMessage.getString("eventText", ""));
        details = (TextView) findViewById(R.id.details);
        details.setText(eventMessage.getString("detailsText", ""));
        nextTurn = (ImageView) findViewById(R.id.nextTurn);

        if (game.getTurn() == Game.Turn.P1) {
            nextTurn.setImageResource(R.drawable.snapper);
        } else {
            nextTurn.setImageResource(R.drawable.sea);
        }
        final GridView gridView = (GridView) findViewById(R.id.gridView);

        // set a custom adapter (ImageAdapter) as the source for all items to be displayed in the grid
        adapter = new ImageAdapter(this);
        gridView.setAdapter(adapter);

        SharedPreferences mprefs = getSharedPreferences("TILE_STATES", 0);
        List<Organism> tempList = adapter.loadTileStates(mprefs);
        if (tempList != null) { // restore the board from previous run
            adapter.tileStates = tempList;
        }

        // recount and display the correct population based on the board state
        adapter.countPopulation();
        int snapperPops = adapter.getSnapperPopulation();
        snapperPopulation.setText(String.valueOf("Snappers: " + snapperPops));
        int seaPops = adapter.getSeaPopulation();
        seaPopulation.setText(String.valueOf("Sea: " + seaPops));

        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Organism organism = adapter.getTileState(position);
                if (organism.getSpecies().equals(Organism.Species.Empty)) {
                    if (game.getTurn().equals(Game.Turn.P1)) { // fill the tile with the appropriate species
                        organism.setSpecies(Organism.Species.Snapper);
                        adapter.setTileState(position, organism);

                        ImageView viewToChange = (ImageView) view;
                        viewToChange.setAlpha(1.0f);
                        viewToChange.setImageResource(R.drawable.snapper);

                        game.setTurn(Game.Turn.P2); // turn now goes to other player
                        nextTurn.setImageResource(R.drawable.sea); // display the species of the other player's token
                    } else {
                        organism.setSpecies(Organism.Species.Sea);
                        adapter.setTileState(position, organism);

                        ImageView viewToChange = (ImageView) view;
                        viewToChange.setAlpha(1.0f);
                        viewToChange.setImageResource(R.drawable.sea);
                        game.setTurn(Game.Turn.P1);
                        nextTurn.setImageResource(R.drawable.snapper);
                    }
                    ArrayList<Integer> toDie = adapter.interCompetition();
                    final int size = gridView.getChildCount();
                    for(int i = 0; i < size; i++) {
                        if (toDie.contains(Integer.valueOf(i))) { // these organisms defect to the other species
                            Organism org = adapter.getTileState(Integer.valueOf(i));
                            ImageView gridChild = (ImageView) gridView.getChildAt(i);
                            if (org.getSpecies().equals(Organism.Species.Snapper)) {
                                org.setSpecies(Organism.Species.Sea);
                                adapter.setTileState(Integer.valueOf(i), org);
                                gridChild.setImageResource(R.drawable.sea);

                            } else if (org.getSpecies().equals(Organism.Species.Sea)) {
                                org.setSpecies(Organism.Species.Snapper);
                                adapter.setTileState(Integer.valueOf(i), org);
                                gridChild.setImageResource(R.drawable.snapper);
                            }
                        }
                    }

                    // change population counts and era according to results of this turn
                    adapter.countPopulation();
                    int snapperPops = adapter.getSnapperPopulation();
                    snapperPopulation.setText(String.valueOf("Snappers: " + snapperPops));
                    int seaPops = adapter.getSeaPopulation();
                    seaPopulation.setText(String.valueOf("Sea: " + seaPops));
                    game.elapseTime();
                    eraLabel.setText(String.valueOf(game.getEra() + "mya"));

                    // check who won
                    if (adapter.isGridFull() || game.getEra() <= 0) {
                        int victory = adapter.determineVictor(snapperPops, seaPops);
                        switch(victory) {
                            case 1:
                                event.setText("Snappers Win");
                                details.setText("Snapping turtles have become the dominant species!");
                                break;
                            case 2:
                                event.setText("Sea Turtles Win");
                                details.setText("Sea turtles rule!");
                                break;
                            case 3:
                                event.setText("Total Extinction");
                                details.setText("Unfortunately, neither of you made it to the modern era...");
                                break;
                            case 4:
                                event.setText("No Clear Victor");
                                details.setText("Looks like you'll have to share!");
                                break;
                        }
                        // commit these messages
                        SharedPreferences eventMessages = getSharedPreferences(EVENT_MESSAGES, 0);
                        SharedPreferences.Editor editor = eventMessages.edit();
                        editor.putString("eventText", event.getText().toString());
                        editor.putString("detailsText", details.getText().toString());
                        editor.commit();
                    } // save the board and game state
                    SharedPreferences mprefs = getSharedPreferences("TILE_STATES", 0);
                    adapter.saveTileStates(mprefs);

                    SharedPreferences gamePrefs = getSharedPreferences("GAME_STATE", 0);
                    game.saveGameState(gamePrefs);
                }
            }
        });
    }

    // change all the tiles back to the shell, reset the states
    public void resetBoard(View view) {
        GridView gridView =  (GridView) findViewById(R.id.gridView);
        final int size = gridView.getChildCount();
        for(int i = 0; i < size; i++) {
            Organism org = adapter.getTileState(Integer.valueOf(i));
            org.setSpecies(Organism.Species.Empty);
            ImageView gridChild = (ImageView) gridView.getChildAt(i);
            gridChild.setImageResource(R.drawable.shell);
            gridChild.setAlpha(0.2f);
            adapter.setTileState(i, org);
        }
        SharedPreferences mprefs = getSharedPreferences("TILE_STATES", 0);
        adapter.saveTileStates(mprefs);

        game.setTurn(Game.Turn.P1);
        game.setEra(300);
        SharedPreferences gamePrefs = getSharedPreferences("GAME_STATE", 0);
        game.saveGameState(gamePrefs);

        eraLabel.setText("300mya");
        nextTurn.setImageResource(R.drawable.snapper);
        adapter.resetPops();
        seaPopulation.setText("Sea: 0");
        snapperPopulation.setText("Snappers: 0");
        event.setText("");
        details.setText("");
        SharedPreferences eventMessages = getSharedPreferences(EVENT_MESSAGES, 0);
        SharedPreferences.Editor editor = eventMessages.edit();
        editor.putString("eventText", event.getText().toString());
        editor.putString("detailsText", details.getText().toString());
        editor.commit();
    }

    @Override
    public void onStart() {
        super.onStart();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "Main Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app deep link URI is correct.
                Uri.parse("android-app://com.example.bluemelodia.shelldivision/http/host/path")
        );
    }

    @Override
    public void onStop() {
        super.onStop();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "Main Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app deep link URI is correct.
                Uri.parse("android-app://com.example.bluemelodia.shelldivision/http/host/path")
        );
    }
}
