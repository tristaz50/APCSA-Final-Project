import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class GameLogic {
    private static ArrayList<String> dictionary = new ArrayList<>();
    private static String targetWord;

    public GameLogic() {
        loadDictionary();
        selectTargetWord();
    }

    private static void loadDictionary() {
        try (Scanner read = new Scanner(new FileReader("Dictionary.txt"))) {
            while (read.hasNextLine()) {
                String line = read.nextLine();
                if (!line.isEmpty() && line.length() == 5) { // Ensure only 5-letter words are added
                    dictionary.add(line.toLowerCase());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void selectTargetWord() {
        Random rand = new Random();
        targetWord = dictionary.get(rand.nextInt(dictionary.size()));
    }

    public static String getTargetWord() {
        return targetWord;
    }

    public static boolean checkGuess(String guess) {
        return guess.equals(targetWord);
    }

    public static boolean inDictionary(String guess) {
        return dictionary.contains(guess.toLowerCase());
    }

    public static void play() {
        Scanner s = new Scanner(System.in);
        int attempts = 0;
        while (attempts < 6) {
            System.out.println("Enter your " + (attempts + 1) + " guess:");
            String word = s.nextLine().toLowerCase();
            if (word.length() != 5) {
                System.out.println("Guess is not the correct length. Guess again.");
                continue;
            }
            if (!inDictionary(word)) {
                System.out.println("The word is not in the dictionary. Guess again.");
                continue;
            }
            if (checkGuess(word)) {
                System.out.println("Congratulations! You guessed the correct word.");
                return;
            }
            System.out.println("Feedback: " + evaluateGuess(word));
            attempts++;
        }
        System.out.println("You've used all attempts! The correct word was: " + getTargetWord());
    }

    public static String evaluateGuess(String guess) {
        StringBuilder feedback = new StringBuilder("-----");
        for (int i = 0; i < 5; i++) {
            char guessChar = guess.charAt(i);
            if (guessChar == targetWord.charAt(i)) {
                feedback.setCharAt(i, 'Y'); // Y for Green (correct position)
            } else if (targetWord.contains(String.valueOf(guessChar))) {
                feedback.setCharAt(i, 'M'); // M for Yellow (correct letter, wrong position)
            } else {
                feedback.setCharAt(i, 'N'); // N for Black (wrong letter)
            }
        }
        return feedback.toString();
    }

    public static void main(String[] args) {
        new GameLogic(); 
        //System.out.println("Target Word: " + getTargetWord()); // For testing purposes, you might want to remove this line in a real game
        play();
    }
}
