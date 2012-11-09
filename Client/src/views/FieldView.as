/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 1:11
 * To change this template use File | Settings | File Templates.
 */
package views
{
import as3isolib.data.INode;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;

import flash.events.Event;

import models.IBindableModel;

public class FieldView extends IsoScene
{
    public static const CELL_SIZE:int = 20;

    public function FieldView(model:IBindableModel)
    {
        drawGrid();
    }

    override public function addChild(child:INode):void
    {
        super.addChild(child);
        update();
    }

    public function update(event:Event = null):void
    {
        render();
    }

    private var _grid:IsoGrid;

    private function drawGrid():void
    {
        if (_grid == null)
        {
            _grid = new IsoGrid();
            _grid.setGridSize(15, 15, 0);
            _grid.cellSize = CELL_SIZE;
            this.addChild(_grid);
        }
    }
}
}
