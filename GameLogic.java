import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;
public class GameLogic{
    public void setup() throws FileNotFoundException{
        try (Scanner s = new Scanner(new FileReader("Dictionary.txt"))) {
            ArrayList<String> list = new ArrayList<>();
            while (s.hasNext()){
                list.add(s.next());
            }   }
}

}
