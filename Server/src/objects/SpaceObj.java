package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

/**
 * Author: JuzTosS
 * Date: 17.06.12
 */
@Entity
public class SpaceObj
{
    @Id
    ObjectId eDatabaseId;

    @Embedded
    int x;
    @Embedded
    int y;

    @Embedded
    int objectId;

    @Embedded
    int classId;

    @Embedded
    int width;

    @Embedded
    int height;

    public Object[] getSerialized()
    {
        return new Object[]{objectId, classId, x, y, width, height};
    }
}
