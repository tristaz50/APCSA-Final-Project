import java.util.ArrayList;

ArrayList<String> dictionary;
String targetWord;
String currentGuess = "";
String[] guesses = new String[6];
int guessCount = 0;
boolean showHelp = false;
char[][] letterBank = {{'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'},
                       {'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'},
                       {'Z', 'X', 'C', 'V', 'B', 'N', 'M'}};
ArrayList<Character> usedLetters = new ArrayList<>();

void setup() {
    size(700, 800);
    dictionary = loadDictionary("Dictionary.txt");
    targetWord = selectTargetWord(dictionary);
    for (int i = 0; i < 6; i++) {
        guesses[i] = "";
    }
}

void draw() {
    background(255);
    drawGrid();
    drawGuesses();
    drawCurrentGuess();
    drawLetterBank();
    drawHelpButton();
    if (showHelp) {
        drawHelp();
    }
}

void drawGrid() {
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 5; j++) {
            fill(255);
            rect(j * 100, i * 100, 100, 100);
        }
    }
}

void drawGuesses() {
    textSize(32);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < guessCount; i++) {
        for (int j = 0; j < 5; j++) {
            char letter = guesses[i].charAt(j);
            String feedback = evaluateGuess(guesses[i], targetWord);
            fill(getColor(feedback.charAt(j)));
            text(letter, j * 100 + 50, i * 100 + 50);
        }
    }
}

void drawCurrentGuess() {
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(0);
    for (int i = 0; i < currentGuess.length(); i++) {
        char letter = currentGuess.charAt(i);
        text(letter, i * 100 + 50, guessCount * 100 + 50);
    }
}


void drawLetterBank() {
    textSize(24);
    textAlign(CENTER, CENTER);
    int yOffset = 650;
    for (int row = 0; row < letterBank.length; row++) {
        for (int col = 0; col < letterBank[row].length; col++) {
            char letter = letterBank[row][col];
            if (usedLetters.contains(letter)) {
                fill(150);
            } else {
                fill(255);
            }
            rect(col * 50 + 50, yOffset, 50, 50);
            fill(0);
            text(letter, col * 50 + 75, yOffset + 25);
        }
        yOffset += 60;
    }
}
String evaluateGuess(String guess, String target) {
    StringBuilder feedback = new StringBuilder("NNNNN");
    for (int i = 0; i < 5; i++) {
        char guessChar = guess.charAt(i);
        if (guessChar == target.charAt(i)) {
            feedback.setCharAt(i, 'G');
        } else if (target.contains(String.valueOf(guessChar))) {
            feedback.setCharAt(i, 'Y');
        }
    }
    return feedback.toString();
}
void drawHelpButton() {
    fill(200);
    rect(600, 10, 50, 50);
    fill(0);
    textSize(32);
    text("?", 625, 35);
}

void drawHelp() {
    fill(255, 255, 200);
    rect(50, 100, 600, 400);
    fill(0);
    textSize(16);
    textAlign(LEFT, TOP);
    text("Game Instructions:\n\n- Guess the 5-letter word within 6 attempts.\n- Click letters or type using your keyboard.\n- Click the ? button for help.", 70, 120, 560, 360);
}

void mousePressed() {
    int yOffset = 650;
    for (int row = 0; row < letterBank.length; row++) {
        for (int col = 0; col < letterBank[row].length; col++) {
            int x = col * 50 + 50;
            int y = yOffset;
            if (mouseX > x && mouseX < x + 50 && mouseY > y && mouseY < y + 50) {
                char letter = letterBank[row][col];
                if (!usedLetters.contains(letter)) {
                    currentGuess += letter;
                    usedLetters.add(letter);
                    if (currentGuess.length() == 5) {
                        processGuess();
                    }
                }
            }
        }
        yOffset += 60;
    }

    if (mouseX > 600 && mouseX < 650 && mouseY > 10 && mouseY < 60) {
        showHelp = !showHelp;
    }
}

void keyPressed() {
    if (key >= 'a' && key <= 'z' && currentGuess.length() < 5) {
        currentGuess += Character.toUpperCase(key);  // Convert to uppercase
    } else if (key == BACKSPACE && currentGuess.length() > 0) {
        currentGuess = currentGuess.substring(0, currentGuess.length() - 1);
    } else if (key == ENTER && currentGuess.length() == 5) {
        processGuess();
        
    }
}

void processGuess() {
    if (inDictionary(currentGuess, dictionary)) {
        guesses[guessCount] = currentGuess;
        if (checkGuess(currentGuess, targetWord)) {
            println("Congratulations! You guessed the correct word.");
        } else {
            guessCount++;
            currentGuess = "";
            if (guessCount == 6) {
                println("You've used all attempts! The correct word was: " + targetWord);
            }
        }
    } else {
        println("The word is not in the dictionary.");
    }
    usedLetters.clear();  // Clear used letters after each guess
}

int getColor(char feedbackChar) {
    switch (feedbackChar) {
        case 'G':
            return color(0, 255, 0); // Green
        case 'Y':
            return color(255, 255, 0); // Yellow
        default:
            return color(150); // Gray
    }
}

ArrayList<String> loadDictionary(String filename) {
    ArrayList<String> words = new ArrayList<String>();
    String[] lines = loadStrings(filename);
    for (String line : lines) {
        line = line.trim().toLowerCase();
        if (line.length() == 5) {
            words.add(line);
        }
    }
    if (words.size() == 0) {
        println("Dictionary is empty. Cannot select target word.");
    } else {
        println("Dictionary loaded with " + words.size() + " words.");
    }
    return words;
}

String selectTargetWord(ArrayList<String> words) {
    if (words.isEmpty()) {
        return "";
    }
    int index = int(random(words.size()));
    return words.get(index);
}

boolean checkGuess(String guess, String target) {
    return guess.equals(target);
}

boolean inDictionary(String guess, ArrayList<String> words) {
    return words.contains(guess.toLowerCase());
}
