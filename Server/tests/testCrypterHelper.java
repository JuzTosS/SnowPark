import utils.CryptUtil;
import org.junit.Test;

import java.math.BigInteger;
import java.nio.charset.Charset;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.fail;

/**
 * Author: JuzTosS
 * Date: 02.11.12
 */
public class testCrypterHelper
{
    @Test
    public void TestMD5()
    {
        byte[] stringToHash = "md5".getBytes(Charset.forName("UTF-8"));
        BigInteger bigInt = new BigInteger("1bc29b36f623ba82aaf6724fd3b16718", 16);
        byte[] trueResult = bigInt.toByteArray();

        byte[] testResult = CryptUtil.createMD5(stringToHash);

        assertArrayEquals(trueResult, testResult);
    }

    @Test
    public void TestHashPass()
    {
        String passToHash = "md5";
        String salt = "121212";

        String hasedPass = CryptUtil.hashPass(passToHash, salt);

        if (hasedPass.length() != 32)
            fail();
    }
}
