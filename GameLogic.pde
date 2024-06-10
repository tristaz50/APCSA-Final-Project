import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class GameLogic1 {
    private ArrayList<String> dictionary = new ArrayList<>();
    private String targetWord;

    public ArrayList<String> loadDictionary(String filename) {
        ArrayList<String> words = new ArrayList<>();
        try {
            Scanner read = new Scanner(new FileReader(filename));
            while (read.hasNextLine()) {
                String line = read.nextLine().toLowerCase();
                if (line.length() == 5) {
                    words.add(line);
                }
            }
            System.out.println("Dictionary loaded with " + words.size() + " words.");
        } catch (IOException e) {
            System.err.println("Error loading dictionary: " + e.getMessage());
        }
        return words;
    }

    private void selectTargetWord() {
        if (!dictionary.isEmpty()) {
            Random rand = new Random();
            targetWord = dictionary.get(rand.nextInt(dictionary.size()));
            System.out.println("Target word selected: " + targetWord);
        } else {
            System.err.println("Dictionary is empty. Cannot select target word.");
        }
    }

    public String getTargetWord() {
        return targetWord;
    }

    public boolean checkGuess(String guess) {
        return guess.equals(targetWord);
    }

    public boolean inDictionary(String guess) {
        return dictionary.contains(guess.toLowerCase());
    }

    public String evaluateGuess(String guess) {
        StringBuilder feedback = new StringBuilder("NNNNN");
        for (int i = 0; i < 5; i++) {
            char guessChar = guess.charAt(i);
            if (guessChar == targetWord.charAt(i)) {
                feedback.setCharAt(i, 'G'); 
            } else if (targetWord.contains(String.valueOf(guessChar))) {
                feedback.setCharAt(i, 'Y'); 
            }
        }
        return feedback.toString();
    }
}
