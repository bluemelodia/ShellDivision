package com.example.bluemelodia.shelldivision;

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

public class MainActivity extends AppCompatActivity {
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

        game = new Game();
        game.setTurn(Game.Turn.P1);
        game.setEra(300);

        eraLabel = (TextView) findViewById(R.id.eraLabel);
        snapperPopulation = (TextView) findViewById(R.id.snapperPopulation);
        seaPopulation = (TextView) findViewById(R.id.seaPopulation);
        event = (TextView) findViewById(R.id.event);
        details = (TextView) findViewById(R.id.details);
        nextTurn = (ImageView) findViewById(R.id.nextTurn);
        nextTurn.setImageResource(R.drawable.snapper);

        final GridView gridView = (GridView) findViewById(R.id.gridView);
        // set a custom adapter (ImageAdapter) as the source for all items to be displayed in the grid
        adapter = new ImageAdapter(this);
        gridView.setAdapter(adapter);

        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Organism organism = adapter.getTileState(position);
                if (organism.getSpecies().equals(Organism.Species.Empty)) {
                    Toast.makeText(MainActivity.this, "Reset the board.", Toast.LENGTH_SHORT).show();
                    if (game.getTurn().equals(Game.Turn.P1)) {
                        organism.setSpecies(Organism.Species.Snapper);
                        adapter.setTileState(position, organism);

                        ImageView viewToChange = (ImageView) view;
                        viewToChange.setAlpha(1.0f);
                        viewToChange.setImageResource(R.drawable.snapper);

                        game.setTurn(Game.Turn.P2);
                        nextTurn.setImageResource(R.drawable.sea);
                    } else {
                        organism.setSpecies(Organism.Species.Sea);
                        adapter.setTileState(position, organism);

                        ImageView viewToChange = (ImageView) view;
                        viewToChange.setAlpha(1.0f);
                        viewToChange.setImageResource(R.drawable.sea);

                        game.setTurn(Game.Turn.P1);
                        nextTurn.setImageResource(R.drawable.snapper);
                    }
                }
            }
        });
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
