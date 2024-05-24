public class Word{
    public String word;

    public Word(String word) {
        this.word = word;
    }
    public String getWord(){
        return word;
    }
    public boolean isValidLength(){
        return word.length() == 5;
    }
}
