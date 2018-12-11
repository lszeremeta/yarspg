import org.junit.Assert;
import org.junit.Test;

import java.io.File;

public class TestYARSpg {

    private static File [] ok = new File("../yarspg/examples").listFiles(pathname -> pathname.isFile());

    private static File gfiles =  new File("../yarspg/YARSpg.g4");

    @Test
    public void test(){
        Assert.assertTrue(GrammarTester.run(ok, "yarspg", gfiles));
    }


}
