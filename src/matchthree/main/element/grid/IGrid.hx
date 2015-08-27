package matchthree.main.element.grid;

/**
 * @author Anthony Ganzon
 */
interface IGrid 
{
	public function SetGridID(idx: Int, idy: Int, updatePosition: Bool = false): Void;
	public function GridIDToString(): String;
}