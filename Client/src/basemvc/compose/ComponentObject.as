/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 23.03.12
 * Time: 20:13
 * To change this template use File | Settings | File Templates.
 */
package basemvc.compose
{
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;

public class ComponentObject extends EventDispatcher
{
    internal var _parent:CompositeObject;
    internal var _childIndex:int;

    public function ComponentObject()
    {
    }

    public function add(c:ComponentObject):void
    {
        throw new IllegalOperationError("add operation not supported");
    }

    public function remove(c:ComponentObject):void
    {
        throw new IllegalOperationError("remove operation not supported");
    }

    public function getChild(n:int):ComponentObject
    {
        throw new IllegalOperationError("getChild operation not supported");

        return null;
    }

    public function update(event:Event = null):void
    {
        throw new IllegalOperationError("method must be reimplemented");
    }

    override public function dispatchEvent(event:Event):Boolean
    {
        var result:Boolean = super.dispatchEvent(event);

        if (event.bubbles && _parent)
            _parent.dispatchEvent(event);

        return result;
    }

    public function get childIndex():int
    {
        return _childIndex;
    }

    public function get parent():CompositeObject
    {
        return _parent;
    }

    internal function setParent(value:CompositeObject):void
    {
        dispatchEvent(new Event(Event.ADDED));
    }

    public function get root():ComponentObject
    {
        if (!parent) return null;

        var p:ComponentObject = this;
        while (p.parent)
            p = p.parent;

        return p;
    }
}
}
