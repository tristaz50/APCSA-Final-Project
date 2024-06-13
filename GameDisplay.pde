import java.util.ArrayList;

ArrayList<String> dictionary;
String targetWord;
String currGuess = "";
String[] guesses = new String[6];
int guessCount = 0;
boolean showHelp = false;
boolean gameOver = false;
boolean wrongWord = false;
char[][] bank = {
    {'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'},
    {'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'},
    {'Z', 'X', 'C', 'V', 'B', 'N', 'M'}
};
ArrayList<Character> used = new ArrayList<>();
ArrayList<Character> wrongLetters = new ArrayList<>();

void setup() {
    size(700, 800);
    dictionary = loadDictionary("Dictionary.txt");
    resetGame();
    textFont(createFont("Arial", 24));
}

void draw() {
    background(255, 223, 186);
    drawGrid();
    drawGuesses();
    drawCurrGuess();
    drawBank();
    drawHelpButton();
    drawResetButton();
    if (showHelp) {
        drawHelp();
    }
    if (wrongWord) {
        drawInvalidWordMessage();
    }
    if (gameOver) {
        drawGameOverOptions();
    }
}

void drawGrid() {
    int xOffset = (width - 500) / 2; 
    int yOffset = 50; 
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 5; j++) {
            fill(255);
            stroke(150);
            strokeWeight(3);
            rect(xOffset + j * 100, yOffset + i * 100, 80, 80, 20);
        }
    }
}

void drawGuesses() {
    textSize(32);
    textAlign(CENTER, CENTER);
    int xOffset = (width - 500) / 2; 
    int yOffset = 50; 
    for (int i = 0; i < guessCount; i++) {
        String feedback = evaluateGuess(guesses[i], targetWord);
        boolean allCorrect = feedback.equals("GGGGG");
        for (int j = 0; j < 5; j++) {
            if (allCorrect) {
                fill(color(0, 255, 0)); 
            } else {
                fill(getColor(feedback.charAt(j)));
            }
            rect(xOffset + j * 100, yOffset + i * 100, 80, 80, 20);
            fill(0);
            text(guesses[i].charAt(j), xOffset + j * 100 + 40, yOffset + i * 100 + 40);
        }
    }
}

void drawCurrGuess() {
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(0);
    int xOffset = (width - 500) / 2; 
    int yOffset = 50; 
    for (int i = 0; i < currGuess.length(); i++) {
        char letter = currGuess.charAt(i);
        text(letter, xOffset + i * 100 + 40, yOffset + guessCount * 100 + 40);
    }
}

void drawBank() {
    textSize(24);
    textAlign(CENTER, CENTER);
    int yOffset = 625;
    for (int row = 0; row < bank.length; row++) {
        int xOffset = (width - bank[row].length * 50) / 2; 
        for (int col = 0; col < bank[row].length; col++) {
            char letter = bank[row][col];
            if (used.contains(letter)) {
                fill(150); 
            } else if (wrongLetters.contains(letter)) {
                fill(200); 
            } else {
                fill(255, 192, 203); 
            }
            stroke(150);
            rect(xOffset + col * 50, yOffset, 50, 50, 10);
            fill(0);
            text(letter, xOffset + col * 50 + 25, yOffset + 25);
        }
        yOffset += 60;
    }
}

void drawHelpButton() {
    fill(173, 216, 230);
    stroke(0);
    rect(600, 10, 50, 50, 10);
    fill(0);
    textSize(32);
    text("?", 625, 35);
}

void drawResetButton() {
    fill(255, 182, 193);
    stroke(0);
    rect(600, 70, 80, 50, 10);
    fill(0);
    textSize(20);
    text("Reset", 640, 95);
}

void drawHelp() {
    fill(255, 255, 200);
    rect(50, 100, 600, 400, 20);
    fill(0);
    textSize(16);
    textAlign(LEFT, TOP);
    text("Game Instructions:\n\n- Guess the 5-letter word within 6 attempts.\n- Click letters or type using your keyboard.\n- Click the ? button for help.", 70, 120, 560, 360);
}

void drawInvalidWordMessage() {
    fill(255, 0, 0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("This word is not a word", width / 2, height / 2);
}

void drawGameOverOptions() {
    fill(255, 255, 200);
    rect(150, 200, 400, 200, 20);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Game Over! The correct word was: " + targetWord, width / 2, 250);
    fill(255, 100, 100);
    rect(200, 300, 100, 50, 10);
    fill(255);
    text("Reset", 250, 325);
    fill(100, 100, 255);
    rect(400, 300, 100, 50, 10);
    fill(255);
    text("Exit", 450, 325);
}

void mousePressed() {
    if (gameOver) {
        if (mouseX > 200 && mouseX < 300 && mouseY > 300 && mouseY < 350) {
            resetGame();
        } else if (mouseX > 400 && mouseX < 500 && mouseY > 300 && mouseY < 350) {
            exit();
        }
        return;
    }

    int yOffset = 650;
    for (int row = 0; row < bank.length; row++) {
        int xOffset = (width - bank[row].length * 50) / 2; 
        for (int col = 0; col < bank[row].length; col++) {
            int x = xOffset + col * 50;
            int y = yOffset;
            if (mouseX > x && mouseX < x + 50 && mouseY > y && mouseY < y + 50) {
                char letter = bank[row][col];
                if (currGuess.length() < 5) { 
                    currGuess += letter;
                    if (currGuess.length() == 5) {
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

    if (mouseX > 600 && mouseX < 680 && mouseY > 70 && mouseY < 120) {
        resetGame();
    }
}

void keyPressed() {
    if (gameOver) return;

    if (key >= 'A' && key <= 'Z' && currGuess.length() < 5) {
        currGuess += key;
    } else if (key == BACKSPACE && currGuess.length() > 0) {
        currGuess = currGuess.substring(0, currGuess.length() - 1);
    } else if (key == ENTER && currGuess.length() == 5) {
        processGuess();
    }
}

void processGuess() {
    if (inDictionary(currGuess, dictionary)) {
        wrongWord = false;
        guesses[guessCount] = currGuess;
        if (checkGuess(currGuess, targetWord)) {
            gameOver = true;
        } else {
            keyboardState(currGuess, targetWord);
            guessCount++;
            currGuess = "";
            if (guessCount == 6) {
                gameOver = true;
            }
        }
    } else {
        wrongWord = true;
    }
    used.clear();
}

void keyboardState(String guess, String target) {
    for (int i = 0; i < guess.length(); i++) {
        char letter = guess.charAt(i);
        if (!target.contains(String.valueOf(letter))) {
            wrongLetters.add(letter);
        }
    }
}

int getColor(char feedbackChar) {
    switch (feedbackChar) {
        case 'G':
            return color(0, 255, 0); // Green
        case 'Y':
            return color(255, 255, 0); // Yellow
        default:
            return color(192, 192, 192); // Gray
    }
}

boolean checkGuess(String guess, String target) {
    return guess.equals(target);
}

String evaluateGuess(String guess, String target) {
    StringBuilder feedback = new StringBuilder("BBBBB");
    boolean[] targetUsed = new boolean[5];
    for (int i = 0; i < 5; i++) {
        if (guess.charAt(i) == target.charAt(i)) {
            feedback.setCharAt(i, 'G');
            targetUsed[i] = true;
        }
    }
    for (int i = 0; i < 5; i++) {
        if (feedback.charAt(i) != 'G') {
            for (int j = 0; j < 5; j++) {
                if (!targetUsed[j] && guess.charAt(i) == target.charAt(j)) {
                    feedback.setCharAt(i, 'Y');
                    targetUsed[j] = true;
                    break;
                }
            }
        }
    }
    return feedback.toString();
}

boolean inDictionary(String word, ArrayList<String> dict) {
    return dict.contains(word);
}

ArrayList<String> loadDictionary(String fileName) {
    ArrayList<String> dict = new ArrayList<String>();
    String[] lines = loadStrings(fileName);
    for (String line : lines) {
        dict.add(line.trim().toUpperCase());
    }
    return dict;
}

void resetGame() {
    targetWord = randomWord(dictionary);
    currGuess = "";
    guesses = new String[6];
    guessCount = 0;
    used.clear();
    wrongLetters.clear();
    gameOver = false;
    wrongWord = false;
}

String randomWord(ArrayList<String> dict) {
    return dict.get((int) random(dict.size())).toUpperCase();
}
