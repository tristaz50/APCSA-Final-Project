import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class GameLogic {
    private ArrayList<String> dictionary;
    private String targetWord;

    public GameLogic(ArrayList<String> dictionary) {
        this.dictionary = dictionary;
        selectTargetWord();
    }

    private void selectTargetWord() {
        Random rand = new Random();
        targetWord = dictionary.get(rand.nextInt(dictionary.size()));
    }

    public String getTargetWord() {
        return targetWord;
    }

    public boolean checkGuess(String guess) {
        return guess.equals(targetWord);
    }
    public void play(){
        Scanner s = new Scanner(System.in);
        int t = 0;
        while (t < 6){
            System.out.println("Enter your " + (t + 1) + " guess:");
            String word = s.nextLine();
            if (word.length() > 5 || word.length() < 5){
                System.out.println("Guess is not the correct length guess again");
                word = s.nextLine();
            }
            System.out.Print("Word is: " + checkGuess(word));
            
        }
    }
    public String evaluateGuess(String guess) {
        StringBuilder feedback = new StringBuilder("-----");
        for (int i = 0; i < 5; i++) {
            char guessChar = guess.charAt(i);
            if (guessChar == targetWord.charAt(i)) {
                feedback.setCharAt(i, 'G'); // G for Green (correct position)
            } else if (targetWord.contains(String.valueOf(guessChar))) {
                feedback.setCharAt(i, 'Y'); // Y for Yellow (correct letter, wrong position)
            } else {
                feedback.setCharAt(i, 'B'); // B for Black (wrong letter)
            }
        }
        return feedback.toString();
    }
}
