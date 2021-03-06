/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 2:17
 * To change this template use File | Settings | File Templates.
 */
package models
{
import config.Constants;

import de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc;

import events.CoreEvent;
import events.FieldEvent;
import events.ObjectEvent;

import flash.events.Event;
import flash.events.EventDispatcher;

import objects.ObjectModel;

import utils.IntPnt;

public class FieldModel extends EventDispatcher implements IFieldModel
{
    public static const VOID_TOOL:String = "VoidTool";
    public static const DESTROY_TOOL:String = "DestroyTool";
    public static const UP_TOOL:String = "UpTool";
    public static const DOWN_TOOL:String = "DownTool";
    public static const PLACE_OBJECT_TOOL:String = "PlaceObjetTool";

    private var _field:SnowParkField;
    private var _heightMap:Array;
    private var _allObjects:Vector.<ObjectModel> = new Vector.<ObjectModel>();

    private var _activeTool:String = VOID_TOOL;
    private var _activeToolParams:Object;

    private var _componentsHash:Object = {};

    public function FieldModel()
    {
        _field = new SnowParkField();
    }

    public function getField():SnowParkField
    {
        return _field;
    }

    private function onObjectPositionUpdated(e:ObjectEvent):void
    {
        var obj:ObjectModel = (e.target as ObjectModel);

        clearFieldPos(e.prevPos.x, e.prevPos.y);
        fillFieldByObject(obj);
    }

    private function clearFieldPos(x:Number, y:Number):void
    {
        for (var i:int = x; i < x + 1; i++)
        {
            for (var j:int = y; j < y + 1; j++)
            {
                _field.setBlock(new IntPnt(i, j), null);
            }
        }
    }

    public function get activeTool():String
    {
        return _activeTool;
    }

    public function setTool(tool:String, params:Object = null):void
    {
        _activeTool = tool;
        _activeToolParams = params;

        dispatchEvent(new FieldEvent(FieldEvent.TOOL_CHANGED));
    }

    private function fillFieldByObject(obj:ObjectModel):void
    {
        for (var x:int = obj.x; x < obj.x + 1; x++)
        {
            for (var y:int = obj.y; y < obj.y + 1; y++)
            {
                _field.setBlock(new IntPnt(x, y), obj);
            }
        }
    }

    public function isPlaceFree(x:int, y:int, width:int = 1, length:int = 1):Boolean
    {
        for (var i:int = x; i < (x + width); i++)
        {
            for (var j:int = y; j < (y + length); j++)
            {
                if (isPosInvalid(new IntPnt(i, j))
                        || (_field.getBlock(new IntPnt(i, j)) != null))
                {
                    return false;
                }
            }
        }
        return true;
    }

    public function isPosInvalid(pos:IntPnt):Boolean
    {
        return (pos.x >= Constants.MAX_FIELD_SIZE || pos.y >= Constants.MAX_FIELD_SIZE || pos.x < 0 || pos.y < 0);
    }

    public function clear():void
    {
        _field = new SnowParkField();

        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get allObjects():Vector.<ObjectModel>
    {
        return _allObjects;
    }

    public function setHeight(x:int, y:int, height:int):Boolean
    {
        if (!isHeightValid(x, y, height)) return false;

        _heightMap[x][y] = height;
        dispatchEvent(new FieldEvent(FieldEvent.HEIGHTMAP_CHANGED, new IntPnt(x, y)));
        return true;
    }

    private function isHeightValid(x:int, y:int, height:int):Boolean
    {
        for (var i:int = -1; i < 2; i++)
        {
            for (var j:int = -1; j < 2; j++)
            {
                if (i == 0 && j == 0) continue;
                var diff:int = Math.abs(_heightMap[x + i][y + j] - height);
                if (diff > 1)
                    return false;
            }
        }

        return true;
    }

    public function set heightMap(value:Array):void
    {
        _heightMap = value;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function getHeight(x:int, y:int):int
    {
        if (!_heightMap) return 0;
        if (!_heightMap[x]) return 0;
        if (!_heightMap[x][y]) return 0;

        return _heightMap[x][y];
    }

    public function tick(event:CoreEvent):void
    {
        var dt:Number = Number(event.data);
        for each(var obj:ObjectModel in allObjects)
        {
            obj.tick(dt);
        }
    }

    public function onFrame(event:CoreEvent):void
    {
        var dt:Number = Number(event.data);
        for each(var obj:ObjectModel in allObjects)
        {
            obj.onFrame(dt);
        }
    }

    public function get activeToolParams():Object
    {
        return _activeToolParams;
    }

    public function getObject(pos:IntPnt):ObjectModel
    {
        return _field.getBlock(pos);
    }

    public function destroy(m:ObjectModel):Boolean
    {
        clearFieldByObject(m);
        _allObjects.splice(_allObjects.indexOf(m), 1);
        m.removeEventListener(ObjectEvent.POSITION_UPDATED, onObjectPositionUpdated);
        dispatchEvent(new FieldEvent(FieldEvent.OBJECT_DESTROYED));
        m.destroy();

        return true;
    }

    public function createObject(objModel:ObjectModel, pos:IntPnt):Boolean
    {
        if (!isPlaceFree(pos.x, pos.y))
            return false;

        objModel.setPos(pos.x, pos.y);
        fillFieldByObject(objModel);
        _allObjects.push(objModel);

        objModel.addEventListener(ObjectEvent.POSITION_UPDATED, onObjectPositionUpdated);
        dispatchEvent(new FieldEvent(FieldEvent.OBJECT_ADDED, pos));
        return true;
    }

    private function onObjectComponentsLoaded(event:ObjectEvent):void
    {
        updateComponentsHash(event.target as ObjectModel);
    }

    private function updateComponentsHash(m:ObjectModel):void
    {
//        for (var i:int = 0; i < m.components.length; i++)
//        {
//            var c:Object = m.components[i];
//            c.
//        }
    }

    private function clearFieldByObject(obj:ObjectModel):void
    {
        for (var x:int = obj.x; x < obj.x + 1; x++)
        {
            for (var y:int = obj.y; y < obj.y + 1; y++)
            {
                _field.setBlock(new IntPnt(x, y), null);
            }
        }
    }

    public function get componentsHash():Object
    {
        return _componentsHash;
    }
}
}
